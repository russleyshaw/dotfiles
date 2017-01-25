#!/bin/python

import os
import subprocess

def main():
    tmp_file = "/tmp/project.txt"

    modes = os.listdir(os.path.expanduser("~/.screenlayout/"))

    # Get new mode
    new_mode = None
    try:
        with open(tmp_file, 'r') as f:
            curr_mode = f.read()
            curr_idx = modes.index(curr_mode)
            new_mode = modes[ (curr_idx + 1) % len(modes) ]
    except:
        with open(tmp_file, 'w') as f:
            new_mode = modes[0]
            f.write(new_mode)

    # Update file with new mode
    with open(tmp_file, 'w') as f:
        f.write(new_mode)

    abs_file = os.path.join(os.path.expanduser('~/.screenlayout/'), new_mode)

    # Update display
    subprocess.call(abs_file)
    subprocess.call(["notify-send", "Switching to mode: {}".format(new_mode)])

if __name__ == '__main__':
    main()