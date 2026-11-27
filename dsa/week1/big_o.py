# O(1) - Constant Time
def get_first_item(lst):
    if not lst:
        return None
    return lst[0]


# O(n) - Linear Time
def sum_list(lst):
    total = 0
    for item in lst:
        total += item  # This operation runs 'n' times
    return total


# O(n²) - Quadratic Time
def print_all_pairs(lst):
    for i in lst:
        for j in lst:
            print(f"({i}, {j})")  # This operation runs 'n * n' times


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# What this file shows: how the NUMBER OF STEPS grows as the input grows.
#
#   get_first_item  O(1)   one step no matter how long the list is
#   sum_list        O(n)   one loop -> the body runs n times
#   print_all_pairs O(n^2) loop inside a loop -> n * n prints
#
# Rules of thumb:
#   - loop over n            -> O(n)
#   - loop inside loop over n -> O(n^2)
#   - drop constants: 2n -> O(n), n + 5 -> O(n)
#   - keep only the biggest term: n^2 + n -> O(n^2)
#
# For n = 1000: O(1) = 1 step, O(n) = 1,000, O(n^2) = 1,000,000.
