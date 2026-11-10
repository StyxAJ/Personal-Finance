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

LC #217 Contains Duplicate | hash set | "have I seen this before?" → loop: if x in seen → return True, else seen.add(x); return False after the loop (set lookup O(1), list lookup O(n)) | solved alone.

LC #1 Two Sum | hash map (dict) | find two numbers that add to target, return indices → for i, x in enumerate(nums): need = target - x; if need in seen → return [seen[need], i]; else seen[x] = i (key = number, value = index; check before store) | needed hint

LC #383 Ransom Note | hash map (counting) | "can I build A from the letters of B?" → count B with counts[ch] = counts.get(ch, 0) + 1; for each ch in A: if counts.get(ch, 0) == 0 → False, else counts[ch] -= 1; end → True | solved alone

LC #242 Valid Anagram | hash map (counting) | same letters, same amounts? → if lengths differ → False; count s (+1), spend t (−1), False if a count is already 0; end → True (same as #383 + a length check) | needed help (googled)

LC #121 Best Time to Buy and Sell Stock | sliding window (two pointers, same direction) | max profit, buy before sell → L = buy day, R = sell day; if prices[R] < prices[L]: L = R (cheaper buy), else best = max(best, prices[R] - prices[L]); R moves every step | needed hint

LC #643 Maximum Average Subarray I | sliding window (fixed size k) | best sum/average of k neighbours → sum the first k once; slide: window_sum += nums[i] - nums[i - k]; track max; divide by k once at the end (O(n), not O(n·k)) | solved alone / needed hint

LC #724 Find Pivot Index | prefix sum | "equal sums on both sides of an index" → compute total once, walk once: R -= x, compare, L += x | needed hints (guided paper step)

Stack (built) | stack = LIFO | top = end of list, so push/pop/peek are O(1) (nothing shifts); pop/peek on empty → raise IndexError; reuse is_empty() for the check | solved alone (paper step first)

LC #20 Valid Parentheses | stack + dict | "brackets must close in the right ORDER" → push openers, on a closer check the top against dict[closer]; check empty before popping; valid only if the stack is empty at the end | counting fails on "([)]" | solved alone / needed hint

#20 redo (Design B) | stack + dict opener→closer | push the closer you EXPECT (pairs[ch]); on a closer: empty → False, popped top ≠ ch → False; key the dict by what you're holding | blank redo needed level 3 (vocabulary table)

LC #155 Min Stack | two stacks | "O(1) min after pops" → keep a 2nd stack of mins: push when value ≤ current min, pop when the leaving value == its top | one variable loses the old min when overwritten | level 1 (trace showed the bug; the idea was mine)

LC #1 Two Sum redo | hash map value → index | check (target − n) in seen FIRST, then store n → one pass O(n), [3,3] works | redo from blank: level 0 ✅ (was ⭕ since W3)

LC #155 Min Stack redo | two stacks | push to min stack when value ≤ its top, pop it when the leaving value == its top; helpers take the stack as a parameter | redo from blank: level 0 ✅ (~15 min); runtime % is noise, Big-O is the measure

Linked list (built) | head + Node(value, next) | prepend O(1): new.next = head THEN head = new (never drop the only pointer); append O(n): walk until current.next is None; visit all: until current is None | opposite of a Python list (insert(0) O(n), append O(1)) | used a site for syntax

LC LC #206 Reverse Linked List | pointer reversal (prev / current / saved) | "reverse in place" → loop while current: saved = current.next, current.next = prev, prev = current, current = saved; return prev | each step peels one box off the front and prepends it to the reversed list | idea mine (prepend onto a new list), needed the trace for the flip column