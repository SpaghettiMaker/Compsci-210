#Author: xzho684

def break_into_parts(number):
    """Breaks the decimal string into the sign, the integer part and the fractional part"""
    sign = "+"
    if number[0] == "-":
        number = number[1:]
        sign = "-"
    decimal_parts = number.split(".")
    if len(decimal_parts) < 2:
        decimal_parts.append("0")
    print("sign: {} integer: {} fraction: {}".format(sign, decimal_parts[0], decimal_parts[1]))
	
test_values = "0 1234 -1234 12.4 0.6 -12.40 -0.06 -1234567890.123456789".split()
for number in test_values:
    print(number)
    break_into_parts(number)