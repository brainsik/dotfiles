#!/usr/bin/env python3
import sys
import os
import math
from base64 import a85encode


def parse_args():
    if len(sys.argv) >= 2:
        return int(sys.argv[1])


def printem(n_bytes):
    msg = "Generating {} bit random ascii85 strings".format(n_bytes * 8)
    print(msg)
    print("-" * len(msg))
    for _ in range(5):
        print(str(a85encode(os.urandom(n_bytes)), 'ascii'))
    return


def main(n_bits=None):
    if n_bits:
        printem(math.ceil(n_bits / 8))
        return

    for n_bits in [64, 80, 96, 128, 256]:
        printem(math.ceil(n_bits / 8))
        print()


if __name__ == '__main__':
    main(parse_args())
