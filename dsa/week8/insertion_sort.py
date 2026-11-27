def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while j >= 0 and key < arr[j]:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key

nums = [5, 2, 4, 6, 1, 3]
print(nums)
insertion_sort(nums)
print(nums)

nums = []
print(nums)
insertion_sort(nums)
print(nums)

nums = [1]
print(nums)
insertion_sort(nums)
print(nums)

nums = [1, 2, 3]
print(nums)
insertion_sort(nums)
print(nums)


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Idea: like sorting cards in your hand. Everything left of i is already sorted;
# take arr[i] (the key) and slide it left into its place.
#
# Steps:
#   for i from 1 to the end:
#     key = arr[i]; j = i - 1
#     while j >= 0 and arr[j] > key:
#       arr[j + 1] = arr[j]   (shift the bigger item right)
#       j -= 1
#     arr[j + 1] = key        (j stopped one spot too far left, so +1)
#
# Trace: [5, 2, 4, 6, 1, 3]
#   key 2 -> [2, 5, 4, 6, 1, 3]
#   key 4 -> [2, 4, 5, 6, 1, 3]
#   key 6 -> no shift
#   key 1 -> [1, 2, 4, 5, 6, 3]
#   key 3 -> [1, 2, 3, 4, 5, 6]
#
# Big-O: O(n^2) worst/average, O(n) if already sorted (inner loop never runs).
# In place (O(1) space), stable (`>` not `>=`, so equal items keep their order).
# Good for small or nearly sorted lists.
