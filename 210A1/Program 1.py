#Author: xzho684

from decimal import *


def integer_to_binary(integer_string):
    """converts integers to binary"""
    decimal_format = int(integer_string)
    binary_format = ""
    while decimal_format != 0:
        if decimal_format % 2 == 0:
            binary_format += "0"
        else:
            binary_format += "1"
        decimal_format //= 2

    if binary_format == "":
        binary_format = "0"

    print(" ".join(binary_format))
    print(binary_format[::-1])

test_values = '0 10 100 65535 65536 9903520314283042199192993792'.split()
for value in test_values:
    print('Decimal:', value)
    integer_to_binary(value)