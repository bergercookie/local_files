import numpy as np

def pr_divisors(n):
    """
    Compute the proper divisors of the given n number,
    Returns a tuple with 
    - a list of the divisors
    - number of divisors
    """

    prop_div = []
    j = 0
    for i in range(1, n / 2 + 1):
        if n % i  == 0 :
            prop_div.append(i)

    if n == 1: 
        print "Proper Divisors of 1?"
        return ([1], 1)
    else:
        return(prop_div, len(prop_div))

def is_abundant(n):
    """Function to determine if n is abundant."""

    return sum(pr_divisors(n)[0]) > n
