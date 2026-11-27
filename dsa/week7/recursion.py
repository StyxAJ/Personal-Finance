# iterative
def factorial_iterative(x):
    result = 1
    for i in range(1, x + 1):
        result *= i
    return result


# recursion
def factorial(x):
    if x == 0 or x == 1:
        return 1
    else:
        return x * factorial(x - 1)


print(factorial_iterative(5))  # Output: 120
print(factorial_iterative(0))  # Output: 1

print(factorial(5))  # Output: 120
print(factorial(0))  # Output: 1


# Fibonacci sequence using recursion


# iterative
def fibonacci_iterative(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a


# recursion
def fibonacci(n):
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fibonacci(n - 1) + fibonacci(n - 2)


print(fibonacci_iterative(5))  # Output: 5
print(fibonacci_iterative(0))  # Output: 0

print(fibonacci(5))  # Output: 5
print(fibonacci(0))  # Output: 0

# reverse string using recursion


# iterative
def reverse_string_iterative(s):
    result = ""
    for char in s:
        result = char + result
    return result


# recursion
def reverse_string(s):
    if len(s) == 0:
        return s
    else:
        reverse_rest = reverse_string(s[1:])
        return reverse_rest + s[0]


print(reverse_string_iterative("hello"))  # Output: "olleh"
print(reverse_string("hello"))  # Output: "olleh"


# sum of  list


# iterative
def sum_list_iterative(lst):
    total = 0
    for num in lst:
        total += num
    return total


# recursion
def sum_list(lst):
    if len(lst) == 0:
        return 0
    else:
        sum_rest = lst[0] + sum_list(lst[1:])
        return sum_rest


print(sum_list_iterative([1, 2, 3, 4, 5]))  # Output: 15
print(sum_list([1, 2, 3, 4, 5]))  # Output: 15


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Every recursive function = base case + a smaller call.
#   base case: the smallest input, answered directly (stops the recursion)
#   recursive case: answer = combine(this step, f(smaller input))
# No base case -> RecursionError (Python's limit is about 1000 calls deep).
#
# factorial(x) = x * factorial(x - 1), base 0 or 1 -> 1
#   factorial(3) = 3 * factorial(2) = 3 * 2 * factorial(1) = 3 * 2 * 1 = 6
#
# fibonacci(n) = fib(n-1) + fib(n-2), base 0 -> 0, 1 -> 1
#   two calls per level -> about O(2^n); the loop version is O(n).
#   loop: a, b = b, a + b (both update at once; a = b then b = a + b would be wrong)
#
# reverse_string(s) = reverse(s[1:]) + s[0], base "" -> ""
#   "abc" -> reverse("bc") + "a" -> (reverse("c") + "b") + "a" -> "cba"
#
# sum_list(lst) = lst[0] + sum_list(lst[1:]), base [] -> 0
#
# Cost of slicing: s[1:] / lst[1:] copies the rest every call,
# so these two are O(n^2) time. Pass an index instead to make them O(n).
# Recursion also uses O(n) stack space; the loops use O(1).
