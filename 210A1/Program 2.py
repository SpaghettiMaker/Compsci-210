#Author: xzho684

from decimal import *


def fraction_to_binary(fraction_string, significant_binary_digits):
    """Convert a string of decimal digits up to 32 digits long representing a positive decimal fractional
    value into its equivalent binary digit string"""
    max_length = 28
    fraction_format = Decimal(fraction_string)
    binary_format = ""
    round_off = int(significant_binary_digits)
    sig_figures = int(significant_binary_digits)

    while max_length > 0:
        max_length -= 1
        fraction_format *= 2
        if fraction_format >= 1:
            binary_format += "1"
            fraction_format -= 1
        else:
            binary_format += "0"

    i = 0
    sig = False
    temp = ""
    temp += binary_format[i]
    if binary_format[0] == "1":
        sig = True
        significant_binary_digits -= 1

    while significant_binary_digits > -1:
        i += 1
        if binary_format[i] == "1":
            sig = True
        if sig:
            significant_binary_digits -= 1
        temp += binary_format[i]
    binary_format = temp
    print(" ".join(binary_format))

    temp2 = []
    for i in temp:
        temp2.append(i)

    count = 0
    for i in temp2:
        if i == "1":
            break
        count += 1

    carry = False
    temp2 = temp2[::-1]

    for i in range(0, len(temp2)):
        if carry:
            if temp2[i] == "0":
                temp2[i] = "1"
                carry = False
                break
            elif temp2[i] == "1":
                temp2[i] = "0"
        if temp2[0] == "1":
            carry = True
        elif temp2[0] == "0":
            break
    temp2 = temp2[::-1]
    if carry:
        temp2[-1] = "0"
        temp2 = temp2[:sig_figures + count - 1]
        strfinal = ""
        for i in range(0, len(temp2)):
            strfinal += temp2[i]
        print("1.{}".format(strfinal))
    else:
        strfinal = ""
        i = 0
        sig2 = False

        for i in range(0, len(temp2) - 1):
            strfinal += temp2[i]
            if temp2[i] == "1":
                sig2 = True
            if sig2:
                sig_figures -= 1
            if sig_figures == 0:
                break
        print("0.{}".format(strfinal))

print('Test values without rounding problems.')
test_values = '0.5 0.25 0.0625'.split()
significant = [1, 2, 4, 10]

for value in test_values:
    print('Decimal:', value)
    for digits in significant:
        print(digits, 'sig digit/s:')
        fraction_to_binary(value, digits)
    print()
	
print('Test values with rounding problems.')
test_values = '0.75 0.1 0.3333333333333333333333333333'.split()
significant = [1, 2, 4, 10]

for value in test_values:
    print('Decimal:', value)
    for digits in significant:
        print(digits, 'sig digit/s:')
        fraction_to_binary(value, digits)
    print()