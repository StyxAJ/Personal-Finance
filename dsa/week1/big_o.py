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
