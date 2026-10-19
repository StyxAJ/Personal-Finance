<!-- Format: #number Name | pattern | when I see ___ → I do ___ | solved alone / needed hint / saw solution -->

<!-- Week 1 -->
Big-O | concept | loop inside a loop over n = O(n²); constants are dropped | -
List costs | concept | insert(0) shifts every item = O(n); append adds to the end = O(1) | -

LC #1480 Running Sum of 1d Array | prefix sum | each answer = previous answer + current number → keep a running total | solved alone (logic), hint on syntax

LC #1929 Concatenation of Array | concatenation array | doubling the array length by adding the an integer array to itself | solved alone

<!-- Week 2 -->

LC #344 Reverse String | two pointers | reverse a list in place → pointers at both ends, swap, move inward while left < right | needed hint

LC #125 Valid Palindrome | two pointers | ignore junk while comparing ends → skip non-alnum on each side (with i < j guard), compare lowercase, move inward | needed hint

LC #26 Remove Duplicates from Sorted Array | two pointers (slow/fast, same direction) | remove duplicates in place from a sorted array → read pointer scans pairs, write pointer marks last unique; on a new value: write += 1, copy it to nums[write]; return write + 1 | needed hint

LC #977 Squares of a Sorted Array | two pointers (opposite ends) + fill from the back | sorted array with negatives → biggest squares sit at the ENDS; compare both ends, put the bigger square in the last empty slot, move that pointer in; loop while left <= right (middle element still needs a slot) | needed hint

LC #167 Two Sum II | two pointers (opposite ends) | sorted array + find a pair with a target sum → L at start, R at end; sum too big → R moves left, too small → L moves right, equal → return (1-based) | solved alone

<!-- Week 3 -->

LC #217 Contains Duplicate | hash set | "have I seen this before?" → loop: if x in seen → return True, else seen.add(x); return False after the loop (set lookup O(1), list lookup O(n)) | solved alone