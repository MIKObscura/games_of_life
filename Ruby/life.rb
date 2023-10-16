require 'colorize'

WIDTH = 40
HEIGHT = 40
ACTUAL_WIDTH = WIDTH + 2
ACTUAL_HEIGHT = HEIGHT + 2
INITIAL_LIVES = 500
UNIVERSE = Array.new((ACTUAL_HEIGHT) * (ACTUAL_HEIGHT), 0)

# to avoid using too many conditionals when computing the generations, there's a row of 0s all around the universe
# this is to check whether we are at the edge or not, if so we skip to the next cell
def is_edge?(i)
    (i < ACTUAL_WIDTH) || # top row
    (i > (ACTUAL_WIDTH * ACTUAL_HEIGHT) - ACTUAL_WIDTH) || # bottom row
    (i % ACTUAL_WIDTH == 0) || # first column
    ((i + 1) % ACTUAL_WIDTH == 0) # last column
end

def initial_generation
    indexes = []
    UNIVERSE.each_with_index do |x, i|
        if is_edge?(i)
            next
        end
        indexes += [i]
    end
    indexes = indexes.shuffle.take(INITIAL_LIVES)
    indexes.each do |i|
        UNIVERSE[i] = 1
    end
end

def print_universe
    str = ""
    counter = 0
    UNIVERSE.each_with_index do |x, i|
        if is_edge?(i)
            next
        end
        str += "| #{x == 0 ? x : 'X'.green} "
        counter += 1
        if counter % HEIGHT == 0
            str += "| \n"
            puts str
            str = ""
        end
    end
end

def new_generation
    deaths = []
    births = []
    UNIVERSE.each_with_index do |x, i|
        if is_edge?(i)
            next
        end
        living_neighbors = UNIVERSE[i - 1] + # left & right
            UNIVERSE[i + 1] +
            UNIVERSE[i + ACTUAL_WIDTH] + # over & under
            UNIVERSE[i - ACTUAL_WIDTH] +
            UNIVERSE[i + ACTUAL_WIDTH + 1] + # diagonals
            UNIVERSE[i + ACTUAL_WIDTH - 1] +
            UNIVERSE[i - ACTUAL_WIDTH - 1] +
            UNIVERSE[i - ACTUAL_WIDTH + 1]

        if x && (living_neighbors < 2 || living_neighbors > 3)
            deaths += [i]
        elsif !x && (living_neighbors == 2 || living_neighbors == 3)
            births += [i]
        end
    end
    deaths.each do |d|
        UNIVERSE[d] = 0
    end
    births.each do |b|
        UNIVERSE[b] = 1
    end
end

initial_generation
print_universe
50.times do
    system("clear")
    new_generation
    print_universe
    sleep(1)
end
