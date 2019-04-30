#Author: xzho684

import re


def valid_float(num_string):
    """Checks weather fraction_string is a valid floating point number with optional negative sign"""
    return re.match("^[-]?[1-9]+[0-9]*\.?[0-9]*[0-9]+$|^[-]?[0]\.?[0-9]*[0-9]+$", num_string)
	
def check(num_string):
    print(num_string, end=' is ')
    if not valid_float(num_string):
        print(end='not ')
    print('valid')

test_values = "1234 -1234 +123 123. 12.4 0.6 00.6 .6 -12.4 -0.6 -1234567890.123456789 12-.6335".split()
for number in test_values:
    check(number)