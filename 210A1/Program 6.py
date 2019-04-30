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
    return "{}{}.{}".format(parts_number[2], integer, fraction)

def float_string_to_binary(value):
    """converts and prints the given float value and converts it to the specified binary 16-bit format"""
    is_negative = "0"
    twos_complement = print_binary(value, max_length=23)
    if twos_complement[0] == "-":
        is_negative = "1"
    twos_complement = twos_complement[1:]
    temp = twos_complement.split(".")
    bits = 0
    if Decimal(twos_complement) == 0:
        exponent = "0000"
    else:
        if temp[0] == "0":
            for i in temp[1]:
                bits -= 1
                if i == "1":
                    break
        else:
            bits = len(temp[0]) - 1
        exponent = integer_to_binary(bits + 7)
    if bits < 0:
        temp[1] = temp[1][abs(bits) - 1:12 + abs(bits)]
    else:
        temp[1] = temp[1][:12]

    carry = False
    temp2 = list(temp[1])
    temp2 = temp2[::-1]

    for i in range(0, len(temp2) - 1):
        if carry:
            if temp2[i] == "0":
                temp2[i] = "1"
                break
            elif temp2[i] == "1":
                temp2[i] = "0"
        if temp2[0] == "1":
            carry = True
        elif temp2[0] == "0":
            break

    mantissa = ""
    temp2 = temp2[::-1]
    exponent = str(exponent)
    if len(temp2) > 12:
        temp2 = temp2[:12]
    while len(exponent) < 4:
        exponent = "0" + exponent

    if temp[0] == "0":
        temp2 = temp2[1:12]
        for i in temp2:
            mantissa += i
    else:
        mantissa = temp[0][1:]
        for i in temp2:
            mantissa += i
    mantissa = mantissa[:11]
    print("{} {} {}".format(is_negative, exponent, mantissa))
	
test_values = '0 0.000'.split()

for value in test_values:
    print(value)
    float_string_to_binary(value)
    print()
'''
test_values = '127 -100.5'.split()

for value in test_values:
    print(value)
    float_string_to_binary(value)
    print()
	
test_values = '1.2 -0.2'.split()

for value in test_values:
    print(value)
    float_string_to_binary(value)
    print()
	
test_values = '511.875 -0.007816314697265625'.split()

for value in test_values:
    print(value)
    float_string_to_binary(value)
    print()'''