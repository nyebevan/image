class Parity:
    def __init__(self, num):
        self.num = num
    def check_parity(self):
        if self.num % 2 == 0:
            print("{} is even.".format(self.num))
        else:
            print("{} is odd.".format(self.num))

x = Parity(12345)
x.check_parity()
x.num = 42
x.check_parity()