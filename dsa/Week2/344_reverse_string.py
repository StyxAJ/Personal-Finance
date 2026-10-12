class Solution:
    def reverseString(self, s: list[str]) -> None:
        """
        Do not return anything, modify s in-place instead.
        """
        s.reverse()


# Write a function that reverses a string. The input string is given as an array of characters s.


while True:
    i, j = 0, len(s) - 1
    a = s[i]
    b = s[j]

    if i == j:
        break
    elif i < j:
        a = a + b
        b = a - b
        a = a - b
    elif i > j:
        break

    i += 1
    j -= 1
