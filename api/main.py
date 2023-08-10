from datetime import datetime
from fastapi import FastAPI

app = FastAPI()
@app.get("/")
def read_root():
    now = datetime.now()

    current_time = now.strftime("%H:%M:%S")
    return current_time