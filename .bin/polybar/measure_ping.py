#!/usr/bin/env python3

"""
A custom module script for Polybar which measures and outputs the
current ping time periodically or upon receiving a SIGUSR1 signal.

Author: Benedikt Vollmerhaus
License: MIT
"""

import signal
import subprocess
import threading

PING_CMD = ("ping 8.8.8.8 -c 1 | "
            "sed -En 's/.*time=([0-9]+(\\.[0-9]+)?) ms$/\\1/p'")


def update_output(_signum=None, _frame=None) -> None:
    """
    Measure the current ping time, output it and (re-) start the
    function timer for triggering the next automatic measurement.

    This may also be called upon receiving a SIGUSR1 signal, which
    therefore updates the output immediately and resets the timer.

    :param _signum: The signal number, if called by one
    :param _frame: The signal's stack frame, if called by one
    :return: None
    """
    if update_output.timer is not None:
        update_output.timer.cancel()

    try:
        ping = float(measure_ping_time())
        print(f'{str(ping)} ms', flush=True)
    except ValueError:
        print('- ms', flush=True)

    update_output.timer = threading.Timer(10, update_output)
    update_output.timer.start()


update_output.timer = None


def measure_ping_time() -> str:
    """
    Measure the current round-trip time (RTT), i.e. ping.

    :return: The current ping
    """
    ping = subprocess.check_output(PING_CMD, shell=True)
    return ping.decode('utf-8').strip()


if __name__ == '__main__':
    update_output()
    signal.signal(signal.SIGUSR1, update_output)
