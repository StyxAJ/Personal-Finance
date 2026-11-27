class Solution:
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        return b


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# LC 509 Fibonacci Number, loop version (not recursion).
#
# Idea: each number = the two before it. Only the last two matter,
# so keep two variables instead of a list or recursive calls.
#
# Steps:
#   n <= 1 -> return n (fib(0) = 0, fib(1) = 1)
#   a, b = 0, 1        (fib 0, fib 1)
#   repeat for 2..n: a, b = b, a + b
#   return b
#
# Trace: n = 5
#   start a=0 b=1
#   i=2 a=1 b=1
#   i=3 a=1 b=2
#   i=4 a=2 b=3
#   i=5 a=3 b=5 -> 5
#
# Big-O: O(n) time, O(1) space.
# Plain recursion is about O(2^n) (recomputes the same values);
# recursion + a dict (memoisation) is O(n) = the idea behind DP.
