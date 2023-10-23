from random import shuffle
from time import sleep
from os import system

WIDTH = 40
HEIGHT = 40
ACTUAL_WIDTH = WIDTH + 2
ACTUAL_HEIGHT = HEIGHT + 2
INITIAL_LIVES = 500
UNIVERSE = [0 for i in range(ACTUAL_HEIGHT * ACTUAL_WIDTH)]


def is_edge(i):
    return (i < ACTUAL_WIDTH) or \
        (i > (ACTUAL_WIDTH * ACTUAL_HEIGHT) - ACTUAL_WIDTH) or \
        (i % ACTUAL_WIDTH == 0) or \
        ((i + 1) % ACTUAL_WIDTH == 0)

def initial_generation():
    indexes = []
    for i in range(len(UNIVERSE)):
        if is_edge(i):
            continue
        indexes.append(i)
    shuffle(indexes)
    for i in indexes[:INITIAL_LIVES]:
        UNIVERSE[i] = 1

def print_universe():
    print_str = ""
    counter = 0
    for i in range(len(UNIVERSE)):
        if is_edge(i):
            continue
        colored_cell = "\033[92mX\033[0m"
        print_str += F"| {'0' if UNIVERSE[i] == 0 else colored_cell} "
        counter += 1
        if counter % HEIGHT == 0:
            print_str += "| \n"
            print(print_str)
            print_str = ""

def new_generation():
    births = []

    for i in range(len(UNIVERSE)):
        if is_edge(i):
            continue
        living_neighbors = UNIVERSE[i - 1] + \
            UNIVERSE[i + 1] + \
            UNIVERSE[i + ACTUAL_WIDTH] + \
            UNIVERSE[i - ACTUAL_WIDTH] + \
            UNIVERSE[i + ACTUAL_WIDTH + 1] + \
            UNIVERSE[i + ACTUAL_WIDTH - 1] + \
            UNIVERSE[i - ACTUAL_WIDTH - 1] + \
            UNIVERSE[i - ACTUAL_WIDTH + 1]
        if living_neighbors == 2 or living_neighbors == 3:
            births.append(i)

    for c in range(0, len(UNIVERSE)):
        if is_edge(c):
            continue
        if c in births:
            UNIVERSE[c] = 1
        else:
            UNIVERSE[c] = 0

if __name__=="__main__":
    initial_generation()
    print_universe()
    for i in range(50):
        system("clear")
        new_generation()
        print_universe()
        sleep(1)