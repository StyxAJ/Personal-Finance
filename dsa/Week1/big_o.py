# Constant time complexity O(c)


def constant_algo(items):
    result = items[0] * items[0]
    print(result)


constant_algo([4, 5, 6, 8])


# Linear time complexity O(n)


def linear_algo(items):
    for item in items:
        print(item)

    for item in items:
        print(item)


linear_algo([4, 5, 6, 8])

# Quadratic time complexity O(n^2)


def quadratic_algo(items):
    for item in items:
        for item2 in items:
            print(item, " ", item2)


quadratic_algo([4, 5, 6, 8])
