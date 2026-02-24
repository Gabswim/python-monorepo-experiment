from postmodern.greeter import greet, greet_with_name


def main():
    msg = greet()
    print("[server2]", msg)
    name = "Bob"
    msg_with_name = greet_with_name(name)
    print("[server2]", msg_with_name)


if __name__ == "__main__":
    main()
