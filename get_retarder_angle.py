#import requests

# url='http://127.0.0.1:8000/'
#r = requests.get(url + "get/angle/to")
# print(r.text)


from http.client import HTTPConnection
import time
import sys

__all__ = ["get_angle"]


def get_angle():
    try:
        start = time.time()
        conn = HTTPConnection("localhost", port=8000)
        conn.close()
        conn = HTTPConnection("localhost", port=8000)
        conn.request("GET", "/get/angle/to")
        r = conn.getresponse()
        angle = float(r.read())
        if time.time() - start > 20:
            sys.stderr.write("TIMEOUT")
            sys.exit()

    except ConnectionRefusedError:
        sys.exit()
    sys.exit(angle)


if __name__ == '__main__':
    get_angle()
