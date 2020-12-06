from http.client import HTTPConnection
import sys
import argparse
import time
from comm_retarder import check_now, go_to_angle, get_angle

parser = argparse.ArgumentParser()

parser.add_argument('--angle')
args = parser.parse_args()

angle = args.angle


ACCURACY = 0.2

if __name__ == "__main__":
    conn = HTTPConnection("localhost", port=8000)
    conn.close()
    conn = HTTPConnection("localhost", port=8000)

    angle_to = float(angle) + 180
    angle_now = get_angle()
    dangle = abs(angle_now - angle_to)
    # print(angle_now, angle_to)

    if (dangle < ACCURACY) or (dangle > (360 - ACCURACY)):
        # print(dangle)
        time.sleep(0.5)
        sys.exit(angle)

    # by Sunho Jin (BOAO troubleshooting)
    # go_to_angle(0)
    # time.sleep(10)

    go_to_angle(angle_to)
    # print(angle_to)
    time.sleep(0.5)

    time_initial = time.time()
    time_start = time.time()
    while True:
        time.sleep(0.3)  # For every 0.3 sec

        angle_now = get_angle()
        dangle = abs(angle_now - angle_to)
        # print(angle_now, angle_to)
        time.sleep(0.3)
        sys.exit(angle)

        # if (dangle < ACCURACY) or (dangle > (360 - ACCURACY)):
        # print(dangle)
        #	time.sleep(0.3)
        #	sys.exit(angle)

        #time_now = time.time()
        #dtime = time_now - time_start

        # If not at the desired place for 8 sec,
        # (1) reset angle to 0
        # (2) reset the starting time.
        # if dtime > 15:
        #	go_to_angle(-80)
        #	time.sleep(10)
        #	time_start = time.time()
        #	go_to_angle(angle_to)
