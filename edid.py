from prometheus_client import start_http_server, Gauge
import time
import subprocess

edid_status = Gauge('edid_connection_status', 'EDID connection status')

def check_edid():
    try:
        # Replace this with appropriate command for your system
        result = subprocess.run(['xrandr', '--props'], capture_output=True, text=True)
        if "EDID" in result.stdout:
            return 1
        return 0
    except:
        return 0

if __name__ == '__main__':
    start_http_server(9111)
    while True:
        edid_status.set(check_edid())
        time.sleep(10)
