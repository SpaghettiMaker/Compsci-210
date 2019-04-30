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

    return binary_format[::-1]


def fraction_to_binary(fraction_string, max_length):
    """Convert a string of decimal digits up to 32 digits long representing a positive decimal fractional
    value into its equivalent binary digit string"""
    fraction_string = "0." + str(fraction_string)
    fraction_format = Decimal(fraction_string)
    binary_format = ""

    while max_length > 0:
        max_length -= 1
        fraction_format *= 2
        if fraction_format >= 1:
            binary_format += "1"
            fraction_format -= 1
        else:
            binary_format += "0"

    return binary_format


def break_into_parts(number):
    """Breaks the decimal string into the sign, the integer part and the fractional part"""
    sign = "+"
    if number[0] == "-":
        number = number[1:]
        sign = "-"
    decimal_parts = number.split(".")
    if len(decimal_parts) < 2:
        decimal_parts.append("0")
    decimal_parts.append(sign)
    return decimal_parts


def print_binary(number, max_length):
    """Prints the binary version of the decimal number string"""
    parts_number = break_into_parts(number)
    integer = integer_to_binary(parts_number[0])
    fraction = fraction_to_binary(parts_number[1], max_length)
    print("{}{}.{}".format(parts_number[2], integer, fraction))
	
test_values = "0 1234 -1234 12.4 0.6 -12.4 -0.6 -1234567890.123456789".split()
for number in test_values:
    print(number, end=': ')
    print_binary(number, 10)