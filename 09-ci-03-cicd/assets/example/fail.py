def increment(index):
    return index+1

def get_square(numb):
    return numb*numb

def print_numb(numb):
    print("Number is {}".format(numb))

index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))