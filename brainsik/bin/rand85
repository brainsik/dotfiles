#!/usr/bin/env python3
#
#   rand85 - Mimics `openssl rand`. Outputs num pseudo-random bytes using the
#            ascii85 encoding.
#
import sys
import os
import math
from base64 import a85encode


def main(n_bytes=None):
    if not n_bytes:
        print("usage: {} num".format(os.path.basename(__file__)))
        raise SystemExit(1)

    print(str(a85encode(os.urandom(n_bytes)), 'ascii'))


def parse_args():
    return int(sys.argv[1]) if len(sys.argv) >= 2 else None


if __name__ == '__main__':
    main(parse_args())
