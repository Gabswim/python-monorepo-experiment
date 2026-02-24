from fastapi import FastAPI
from postmodern.greeter import greet_with_name

app = FastAPI()


@app.get("/greet")
def greet(name: str):
    return {
        "message": greet_with_name(name),
    }
