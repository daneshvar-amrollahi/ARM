for i in range(28, 188, 4):
    print("{{data[{0}], data[{1}], data[{2}], data[{3}]}} <= `INSTRUCTION_LEN'b".format(i, i + 1, i + 2, i + 3))