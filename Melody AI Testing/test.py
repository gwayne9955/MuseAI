from flask import Flask
app = Flask(__name__)

@app.before_first_request
def custom_call():
    print("BEFORE THE VERY FIRST REQUEST!")

@app.before_request
def before_request_func():
    print("before_request is running!")
 
@app.route("/")
def hello():
    return "Hello World!"
 
if __name__ == "__main__":
    # app.before_first_request(custom_call)
    # app.before_request(before_request_func)
    app.run(host='0.0.0.0', port=5000)