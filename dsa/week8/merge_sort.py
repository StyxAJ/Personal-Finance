def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:      # tie → take from left (stable)
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])                # what's left of left, from i on
    result.extend(right[j:])                # what's left of right, from j on
    return result


def merge_sort(arr):

    if  len(arr) <= 1:
        return arr
    mid  = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

print(merge_sort([5, 2, 4, 6, 1, 3]))
print(merge_sort([]))
print(merge_sort([1]))
print(merge_sort([3, 1, 3, 1]))


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: divide and conquer.
#
# Idea: a list of 0 or 1 items is already sorted. Split in half, sort each
# half (recursion), then MERGE two sorted lists into one.
#
# merge(left, right): two fingers i and j
#   take the smaller of left[i] / right[j], move that finger
#   one side runs out -> extend with the rest of both (one of them is empty)
#
# merge_sort(arr):
#   len <= 1 -> return arr (base case)
#   mid = len // 2
#   left = merge_sort(arr[:mid]); right = merge_sort(arr[mid:])   (keep the returns)
#   return merge(left, right)
#
# Trace: [5, 2, 4, 6]
#   split [5, 2] [4, 6] -> [5] [2] -> merge [2, 5]; [4] [6] -> merge [4, 6]
#   merge [2, 5] + [4, 6] -> [2, 4, 5, 6]
#
# Big-O: O(n log n) time always (log n levels of splitting, O(n) merging per level).
# O(n) extra space; returns a NEW list. Stable because of `<=`.
