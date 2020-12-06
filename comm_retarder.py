from http.client import HTTPConnection
import time


__all__ = ["check_now", "go_to_angle", "get_angle"]


def check_now(conn, time_start, angle_to):
    ''' not used in the main part -- only for debugging
    '''
    # print("  now      to     delta")
    while True:
        time_now = time.time()
        dtime = time_now - time_start

        if dtime > 15:
            return False

        conn.request("GET", "/get/angle/now")
        r = conn.getresponse()
        angle_now = r.read()
        dangle = abs(float(angle_now) - float(angle_to))

        #print(f"{float(angle_now):6.2f} - {float(angle_to):6.2f} = {dangle:6.2f}")
        if (dangle > 1) and (dangle < 359):
            time.sleep(0.5)
            conn.close()

        else:
            break

    return True


def go_to_angle(angle_to):
    conn = HTTPConnection("localhost", port=8000)
    conn.request("GET", f"/move/{str(angle_to)}")


def get_angle():
    conn = HTTPConnection("localhost", port=8000)
    conn.request("GET", "/get/angle/now")
    r = conn.getresponse()
    angle_now = float(r.read())
    return angle_now
