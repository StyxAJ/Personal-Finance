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