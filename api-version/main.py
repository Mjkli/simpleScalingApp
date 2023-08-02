from flask import Flask, request
from datetime import datetime


app = Flask(__name__)

@app.route('/', methods=['GET'])
def time():
    now = datetime.now()

    current_time = now.strftime("%H:%M:%S")

    if request.method == 'GET':
        return current_time,200
    else:
        return "Error",404

app.run(host='0.0.0.0',port=5000)