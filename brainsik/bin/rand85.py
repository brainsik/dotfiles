#!/usr/bin/env python3
import sys
import os
import math
from base64 import a85encode


def printem(n_bytes):
    msg = "Generating {} bit random ascii85 strings".format(n_bytes * 8)
    print(msg)
    print("-" * len(msg))
    for _ in range(3):
        print(str(a85encode(os.urandom(n_bytes)), 'ascii'))
    return


def main(n_bits=None):
    for bits in ([n_bits] if n_bits else [32, 64, 80, 96, 112, 128, 256]):
        printem(math.ceil(bits / 8))  # round up to bytes
        print()


def parse_args():
    return int(sys.argv[1]) if len(sys.argv) >= 2 else None


if __name__ == '__main__':
    main(parse_args())
