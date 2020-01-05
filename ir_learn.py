"""Script to learn commands from Xiaomi IR Blaster.

To get the IP and access token of your blaster:

    npx miio discover

Then update the constants.

Usage:

    python ir_learn.py power

Then you have 5 seconds to point your remote at your blaster and hit the power
button on your remote. Repeat with different key for each button you want to
get a command for.
"""

import sys
import time
from miio import ChuangmiIr

IP = '192.168.1.61'
TOKEN = ''
ir = ChuangmiIr(IP, TOKEN)


def _main(x):
    ir.learn(key=1)
    time.sleep(5)
    print(x, ir.read(key=1).get('code'))


if __name__ == '__main__':
    _main(sys.argv[1:])
