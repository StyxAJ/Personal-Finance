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
