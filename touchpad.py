#! /usr/bin/env python
# -*- coding: utf-8 -*-
# Benötigt libnotify-bin sowie SHMConfig

import subprocess
import shlex

def read_touchpad_config():
    proc = subprocess.Popen(['synclient', '-l'], stdout=subprocess.PIPE)
    config = {}
    for i, line in enumerate(proc.stdout):
        # remove first line, which does only contain a headline
        if i == 0: continue
        key, _, value = shlex.split(line)
        config[key] = value
    return config


def toggle_touchpad_state(current_state):
    subprocess.call(['synclient', 'TouchpadOff=%i' % (not current_state)])

def send_notify():
    config = read_touchpad_config()
    if config['TouchpadOff'] == '1':
        subprocess.Popen(['notify-send', 'Touchpad', 'Das Touchpad wurde ausgeschaltet', '-t', '2000'])
    else:
        subprocess.Popen(['notify-send', 'Touchpad', 'Das Touchpad wurde eingeschaltet', '-t', '2000'])

def main():
    config = read_touchpad_config()
    toggle_touchpad_state(config['TouchpadOff'] == '1')
    send_notify()

if __name__ == '__main__':
    main()
