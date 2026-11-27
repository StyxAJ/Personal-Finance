# Quicksort Partition Trace — `[5, 2, 4, 6, 1, 3]` (Pivot = `3`)

## How Quicksort Partitioning Works

Quicksort splits an array into smaller parts around a pivot element, then recursively sorts each side:

- **Pivot & pointers:** With `3` (at the end) as the pivot, `j` scans left to right (`0` to `4`) and `i` marks the right boundary of elements smaller than `3` (starting at `-1`).
- **Swap rule:** When `arr[j] < 3`, increment `i` by `1` and swap `arr[i]` with `arr[j]`.
- **Final pivot placement:** Swap `arr[i + 1]` with the pivot (`3`). Everything to the left of `3` is smaller (`[2, 1]`), and everything to the right is larger (`[6, 5, 4]`).
- **Time complexity:** Average and best case are `O(n log n)`; worst case is `O(n^2)`.

## Partition Trace Table

| step | j   | arr[j] | arr[j] < 3? | action                               | i   | list after           |
| :--- | :-- | :----- | :---------- | :----------------------------------- | :-- | :------------------- |
| 1    | 0   | 5      | no          | nothing                              | -1  | `[5, 2, 4, 6, 1, 3]` |
| 2    | 1   | 2      | yes         | `i += 1`, swap `arr[0]` and `arr[1]` | 0   | `[2, 5, 4, 6, 1, 3]` |
| 3    | 2   | 4      | no          | nothing                              | 0   | `[2, 5, 4, 6, 1, 3]` |
| 4    | 3   | 6      | no          | nothing                              | 0   | `[2, 5, 4, 6, 1, 3]` |
| 5    | 4   | 1      | yes         | `i += 1`, swap `arr[1]` and `arr[4]` | 1   | `[2, 1, 4, 6, 5, 3]` |
| end  | -   | -      | -           | swap pivot (`arr[5]`) with `arr[2]`  | 1   | `[2, 1, 3, 6, 5, 4]` |

- **Result check:** Pivot `3` is placed at index `2` in `[2, 1, 3, 6, 5, 4]`.

## Notes for Saturday Code Redo

- Recurse on `low` to `pivot_index - 1` and `pivot_index + 1` to `high` so the already-placed pivot is excluded from both halves.
- Keep `swap` and `return` inside `Partition` at the end of the scan loop.
