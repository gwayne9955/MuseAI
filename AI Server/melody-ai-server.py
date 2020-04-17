import magenta
import tensorflow
import magenta.music as mm
from magenta.music.protobuf import music_pb2
from magenta.models.melody_rnn import melody_rnn_sequence_generator
from magenta.models.shared import sequence_generator_bundle
from magenta.music.protobuf import generator_pb2
from magenta.music.protobuf import music_pb2

from flask import Flask
from flask import request

from google.protobuf.json_format import MessageToJson

app = Flask(__name__)

@app.before_first_request
def setup_model():
    # Initialize the model.
    print("Initializing attention Melody RNN...")
    bundle = sequence_generator_bundle.read_bundle_file('content/attention_rnn.mag')
    generator_map = melody_rnn_sequence_generator.get_generator_map()
    app.melody_rnn = generator_map['attention_rnn'](checkpoint=None, bundle=bundle)
    app.melody_rnn.initialize()

@app.route('/melody', methods = ['POST'])
def hello():
    body = request.get_json()
    input_sequence = music_pb2.NoteSequence()
    input_sequence.tempos.add(qpm=body['tempo'])
    input_sequence.total_time = body['totalTime']

    # Add the notes to the sequence.
    for note in body['notes']:
        input_sequence.notes.add(
            pitch=note['pitch'], 
            start_time=note['startTime'], 
            end_time=note['endTime'], 
            velocity=note['velocity']
        )

    # change this for shorter or longer sequences
    num_steps = body['numSteps'] if 'numSteps' in body else 128
    # the higher the temperature the more random the sequence.
    temperature = body['temperature'] if 'temperature' in body else 1.0 

    # Set the start time to begin on the next step after the last note ends.
    last_end_time = (max(n.end_time for n in input_sequence.notes) if input_sequence.notes else 0)
    qpm = input_sequence.tempos[0].qpm 
    seconds_per_step = 60.0 / qpm / app.melody_rnn.steps_per_quarter
    total_seconds = num_steps * seconds_per_step

    generator_options = generator_pb2.GeneratorOptions()
    generator_options.args['temperature'].float_value = temperature
    generate_section = generator_options.generate_sections.add(
    start_time=last_end_time + seconds_per_step,
    end_time=total_seconds)

    # Ask the model to continue the sequence.
    print("Evaluating " + str(len(body['notes'])) + " notes...")
    data = app.melody_rnn.generate(input_sequence, generator_options)
    print("Sending back response")
    return app.response_class(
        response=MessageToJson(data),
        status=200,
        mimetype='application/json'
    )
