#!/usr/bin/env python3
#
"""
Simple filter to timestamp every line
"""
import os, fileinput, datetime
import argparse
parser = argparse.ArgumentParser(description='timestamp input')
parser.add_argument('files', help='the files to read (stdin if none)',
                    nargs='?', default=['-'])

def main():
    args = parser.parse_args()
    files = args.files
    for line in fileinput.input(files):
        print(
            str(datetime.datetime.now())+': ',
            line,
            end='',
            flush=True
        )

if (__name__ == '__main__'):
    main()


