import magenta
import tensorflow
import magenta.music as mm
from magenta.music.protobuf import music_pb2
from magenta.models.melody_rnn import melody_rnn_sequence_generator
from magenta.models.shared import sequence_generator_bundle
from magenta.music.protobuf import generator_pb2
from magenta.music.protobuf import music_pb2

from flask import Flask
app = Flask(__name__)

@app.before_first_request
def setup_model():
    twinkle_twinkle = music_pb2.NoteSequence()

    # Add the notes to the sequence.
    twinkle_twinkle.notes.add(pitch=60, start_time=0.0, end_time=0.5, velocity=80)
    twinkle_twinkle.notes.add(pitch=60, start_time=0.5, end_time=1.0, velocity=80)
    twinkle_twinkle.notes.add(pitch=67, start_time=1.0, end_time=1.5, velocity=80)
    twinkle_twinkle.notes.add(pitch=67, start_time=1.5, end_time=2.0, velocity=80)
    twinkle_twinkle.notes.add(pitch=69, start_time=2.0, end_time=2.5, velocity=80)
    twinkle_twinkle.notes.add(pitch=69, start_time=2.5, end_time=3.0, velocity=80)
    twinkle_twinkle.notes.add(pitch=67, start_time=3.0, end_time=4.0, velocity=80)
    twinkle_twinkle.notes.add(pitch=65, start_time=4.0, end_time=4.5, velocity=80)
    twinkle_twinkle.notes.add(pitch=65, start_time=4.5, end_time=5.0, velocity=80)
    twinkle_twinkle.notes.add(pitch=64, start_time=5.0, end_time=5.5, velocity=80)
    twinkle_twinkle.notes.add(pitch=64, start_time=5.5, end_time=6.0, velocity=80)
    twinkle_twinkle.notes.add(pitch=62, start_time=6.0, end_time=6.5, velocity=80)
    twinkle_twinkle.notes.add(pitch=62, start_time=6.5, end_time=7.0, velocity=80)
    twinkle_twinkle.notes.add(pitch=60, start_time=7.0, end_time=8.0, velocity=80) 
    twinkle_twinkle.total_time = 8

    twinkle_twinkle.tempos.add(qpm=60)

    # Initialize the model.
    print("Initializing attention Melody RNN...")
    bundle = sequence_generator_bundle.read_bundle_file('content/attention_rnn.mag')
    generator_map = melody_rnn_sequence_generator.get_generator_map()
    app.melody_rnn = generator_map['attention_rnn'](checkpoint=None, bundle=bundle)
    app.melody_rnn.initialize()

    # Model options. Change these to get different generated sequences! 

    app.input_sequence = twinkle_twinkle # change this to teapot if you want
    num_steps = 128 # change this for shorter or longer sequences
    temperature = 1.0 # the higher the temperature the more random the sequence.

    # Set the start time to begin on the next step after the last note ends.
    last_end_time = (max(n.end_time for n in app.input_sequence.notes)
                    if app.input_sequence.notes else 0)
    qpm = app.input_sequence.tempos[0].qpm 
    seconds_per_step = 60.0 / qpm / app.melody_rnn.steps_per_quarter
    total_seconds = num_steps * seconds_per_step

    app.generator_options = generator_pb2.GeneratorOptions()
    app.generator_options.args['temperature'].float_value = temperature
    generate_section = app.generator_options.generate_sections.add(
    start_time=last_end_time + seconds_per_step,
    end_time=total_seconds)

    # Ask the model to continue the sequence.
    # print(app.melody_rnn.generate(app.input_sequence, app.generator_options))

@app.route('/')
def hello():
    return str(app.melody_rnn.generate(app.input_sequence, app.generator_options))
    # return "Hello World!"
