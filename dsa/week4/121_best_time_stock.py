class Solution:
    def maxProfit(self, prices: list[int]) -> int:
        diff = 0
        Heads = 0
        Tails = 1
        best = 0
        while Tails < len(prices):
            if prices[Heads] > prices[Tails]:
                Heads = Tails
                Tails = Heads + 1

            else:
                diff = prices[Tails] - prices[Heads]
                if diff > best:
                    best = diff

                Tails += 1

        return best


# ---------------------------------------------------------------
# Logic (for future reference)
# ---------------------------------------------------------------
# Pattern: sliding window / two pointers same direction.
# Heads = buy day (left), Tails = sell day (right).
#
# Idea: you must buy before you sell. Keep the cheapest buy day seen so far;
# for each later day, check the profit of selling then.
#
# Steps:
#   Heads = 0, Tails = 1, best = 0
#   while Tails < len(prices):
#     price at Tails is lower than at Heads -> cheaper buy day: Heads = Tails, Tails = Heads + 1
#     else -> profit = prices[Tails] - prices[Heads]; keep the max; Tails += 1
#   return best (0 if prices only go down)
#
# Trace: [7, 1, 5, 3, 6, 4]
#   buy 7, day 1 is 1 -> move buy to 1
#   1->5 profit 4, 1->3 profit 2, 1->6 profit 5 (best), 1->4 profit 3
#   -> 5
#
# Big-O: O(n) time (each day visited once), O(1) space. Checking every pair is O(n^2).
