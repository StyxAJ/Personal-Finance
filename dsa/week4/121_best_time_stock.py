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
