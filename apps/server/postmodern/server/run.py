from postmodern.greeter import greet, greet_with_name


def main():
    msg = greet()
    print(msg)
    name = "Alice"
    msg_with_name = greet_with_name(name)
    print(msg_with_name)


if __name__ == "__main__":
    main()
