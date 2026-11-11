class Account:
    def __init__(self, owner, balance=0):
        # shared setup: every kind of account has these
        self.owner = owner
        self.balance = balance
        self.transactions = []  # composition: an account HAS transactions

    def deposit(self, amount):
        self.balance += amount
        self.transactions.append(amount)

    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError("insufficient funds")
        self.balance -= amount
        self.transactions.append(-amount)

    def describe(self):
        return f"{type(self).__name__:<15} | {self.owner:<6} | {self.balance:>10.2f} AED"


class SavingsAccount(Account):  # a savings account IS an account
    def __init__(self, owner, balance=0, interest_rate=0.03):
        super().__init__(owner, balance)  # parent sets owner, balance, transactions
        self.interest_rate = interest_rate  # the one thing savings adds

    def add_interest(self):
        # interest = balance x rate (600 x 0.03 = 18), then reuse Account's deposit()
        # so the interest is added to balance AND recorded in transactions
        self.deposit(self.balance * self.interest_rate)


class CurrentAccount(Account):
    def __init__(self, owner, balance=0, overdraft=1000):
        super().__init__(owner, balance)
        self.overdraft = overdraft

    def withdraw(self, amount):
        # override: current accounts may go below 0, down to -overdraft
        if amount > self.balance + self.overdraft:
            raise ValueError("over overdraft limit")
        self.balance -= amount
        self.transactions.append(-amount)


# Creating the objects:
# SavingsAccount("Arsh", 500) -> SavingsAccount.__init__ runs
#   -> super().__init__("Arsh", 500) runs Account.__init__: owner, balance=500, transactions=[]
#   -> back in SavingsAccount.__init__: interest_rate=0.03
# CurrentAccount does the same, but adds overdraft=1000 instead
my_savings = SavingsAccount("Arsh", 500)
my_current = CurrentAccount("Arsh", 500)

# 1. subclasses use Account's deposit() without defining it
# Python looks for deposit() in SavingsAccount, doesn't find it, so uses Account's
# both balances: 500 -> 600, both transactions: [100]
my_savings.deposit(100)
my_current.deposit(100)
print(my_savings.describe())  # describe() is also inherited from Account
print(my_current.describe())

# 2. savings adds interest
# add_interest() only exists on SavingsAccount (my_current.add_interest() would be an AttributeError)
# 600 x 0.03 = 18 is deposited -> balance 618, transactions [100, 18]
my_savings.add_interest()
print("after interest:", my_savings.describe())

# 3. same call, different behaviour (polymorphism)
# the loop doesn't know or care which class acc is; it just calls withdraw(1000)
# - my_savings: no withdraw() of its own -> Account.withdraw: 1000 > 618 -> ValueError
# - my_current: its own withdraw() (override): 1000 <= 600 + 1000 -> balance becomes -400
for acc in [my_savings, my_current]:
    try:
        acc.withdraw(1000)
        print("withdrew 1000:", acc.describe())
    except ValueError as e:
        print(f"{type(acc).__name__} refused: {e}")

# 4. a savings account is an Account, but not a CurrentAccount
# isinstance checks the class AND its parents: SavingsAccount -> Account -> True
# SavingsAccount and CurrentAccount are siblings, not parent/child -> False
print("isinstance(my_savings, Account):", isinstance(my_savings, Account))
print("isinstance(my_savings, CurrentAccount):", isinstance(my_savings, CurrentAccount))
# current's history: +100 deposit, -1000 withdrawal (the refused savings withdrawal was never recorded)
print("transactions:", my_current.transactions)
