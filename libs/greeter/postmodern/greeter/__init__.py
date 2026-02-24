from cowsay import say


def greet() -> str:
    msg = say("Hello!")
    return msg


def greet_with_name(name: str) -> str:
    msg = say(f"Hello, {name}!")
    return msg
