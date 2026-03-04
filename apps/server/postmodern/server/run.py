from fastapi import FastAPI
from postmodern.greeter import greet_with_name

app = FastAPI()


@app.get("/greet")
def greet(name: str):
    return {
        "message": greet_with_name(name),
    }


def main():
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
