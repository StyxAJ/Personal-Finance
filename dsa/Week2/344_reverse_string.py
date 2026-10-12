class Solution:
    def reverseString(self, s: list[str]) -> None:
        """
        Do not return anything, modify s in-place instead.
        """
        i, j = 0, len(s) - 1
        while i < j:
            temp = s[j]
            s[j] = s[i]
            s[i] = temp
            i += 1
            j -= 1


# Write a function that reverses a string. The input string is given as an array of characters s.
