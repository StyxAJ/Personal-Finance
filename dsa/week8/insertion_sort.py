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