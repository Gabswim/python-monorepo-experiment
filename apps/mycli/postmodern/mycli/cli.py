import urllib3


def main():
    resp = urllib3.request("GET", "http://httpbin.org/robots.txt")
    print(f"Status: {resp.status}")


if __name__ == "__main__":
    main()
