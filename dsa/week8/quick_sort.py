def partition(array, low, high):
    pivot = array[high]
    i = low - 1

    for j in range(low, high):
        if array[j] <= pivot:
            i += 1
            array[i], array[j] = array[j], array[i]

    array[i+1], array[high] = array[high], array[i+1]
    return i+1

def quicksort(array, low=0, high=None):
    if high is None:
        high = len(array) - 1

    if low < high:
        pivot_index = partition(array, low, high)
        quicksort(array, low, pivot_index-1)
        quicksort(array, pivot_index+1, high)


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: divide and conquer, sorts IN PLACE.
#
# Idea: pick a pivot (here the last item). Partition = move everything <= pivot
# to its left and everything > pivot to its right. The pivot is now in its
# final spot. Then quicksort the left part and the right part.
#
# partition(array, low, high), Lomuto scheme:
#   pivot = array[high]
#   i = low - 1         -> i = end of the "<= pivot" zone (empty at the start)
#   for j from low to high - 1:
#     array[j] <= pivot -> i += 1, swap array[i] and array[j] (grow the zone)
#   swap the pivot into i + 1, return i + 1
#
# quicksort(array, low, high):
#   low < high (2+ items) -> p = partition(...); sort low..p-1 and p+1..high
#
# Trace: partition [3, 7, 1, 5, 4], pivot 4
#   j=0 3 <= 4 -> i=0 swap -> [3, 7, 1, 5, 4]
#   j=1 7 > 4
#   j=2 1 <= 4 -> i=1 swap 7 and 1 -> [3, 1, 7, 5, 4]
#   j=3 5 > 4
#   pivot to i+1=2 -> [3, 1, 4, 5, 7], return 2
#
# Big-O: O(n log n) average, O(n^2) worst (already sorted + last-item pivot:
# every split is n-1 and 0). O(log n) stack space on average. Not stable.
# Merge sort vs quick sort: merge = always n log n but needs O(n) extra;
# quick = in place, usually faster, but has a bad worst case.
