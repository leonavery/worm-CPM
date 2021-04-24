#!/usr/bin/env python3
#
import os, sys
import argparse
import fileinput

parser = argparse.ArgumentParser(description='print out specified fields')
parser.add_argument('fields', help='fields to print (comma-separated python slices)',
                    nargs=1, type=str, default='1:')
parser.add_argument('files', help='input filenames (stdin if none)',
                    nargs='?', default=['-'])
parser.add_argument('-s', '--separator', default=None, type=str,
                    help='field separator')
parser.add_argument('-t', '--tab', action='store_true',
                    help='tab-separated fields')
parser.add_argument('-e', '--empty', action='store_true',
                    help='delete empty lines')
parser.add_argument('-o', '--out-separator', default=None, type=str,
                    help='output field separator')

#
# from https://stackoverflow.com/questions/680826/python-create-slice-object-from-string
# Eric Cousineau's answer
#
def make_slices(expr):
    def to_piece(s):
        return s and int(s) or None

    for sl in expr.split(','):
        pieces = list(map(to_piece, sl.split(':')))
        if len(pieces) == 1:
            if pieces[0] == -1:
                yield(slice(pieces[0], None))
            else:
                yield slice(pieces[0], pieces[0] + 1)
        else:
            yield slice(*pieces)
    

def main():
    args = parser.parse_args()
    sep = args.separator
    if args.tab:
        if sep:
            raise RuntimeError('-s and -t are incompatible')
        sep = '\t'
    if args.out_separator is not None:
        outsep = args.out_separator
    elif sep is None:
        outsep = ' '
    else:
        outsep = sep
    slices = list(make_slices(args.fields[0]))
    for line in fileinput.input(args.files):
        line = line.rstrip('\r\n')
        fields = ['field 0'] + line.split(sep=sep)
        ofields = []
        for sl in slices:
            ofields.extend(fields[sl])
        if (not args.empty or len(ofields) > 0):
            print(outsep.join(ofields))

if (__name__ == '__main__'):
    main()


