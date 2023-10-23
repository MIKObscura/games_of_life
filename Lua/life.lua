width = 40
height = 40
actual_width = width + 2
actual_height = height + 2
initial_lives = 500
universe = {}
clock = os.clock()
for i = 1,(actual_width * actual_height)+1 do
    universe[i] = 0
end

function is_edge(i)
    return (i < actual_width + 1) or
            (i > (((actual_height) * (actual_width)) - (actual_width+1))) or
            (i % (actual_width+1) == 0) or
            ((i + 1) % (actual_width+1) == 0)
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
      local j = math.random(i)
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function initial_generation()
    local indexes = {}
    for i = 1, #(universe) do
        if not is_edge(i) then
            table.insert(indexes, i)
        end
    end
    local shuffled_indexes = shuffle(indexes)
    for j = 1, initial_lives do
        universe[shuffled_indexes[j]] = 1
    end
end

function print_universe()
end

function array_contains(a, elem)
    for i = 1, #(a) do
        if a[i] == elem then return true end
    end
    return false
end

function new_generation()
    births = {}
    for i = 1, #(universe) do
        if is_edge(i) then
            goto continue
        end
        local living_neighbors = universe[i - 1] +
            universe[i + 1] +
            universe[i + actual_width] +
            universe[i - actual_width] +
            universe[i + actual_width + 1] +
            universe[i + actual_width - 1] +
            universe[i - actual_width - 1] +
            universe[i - actual_width + 1]
        if living_neighbors == 2 or living_neighbors == 3 then
            table.insert(births, i)
        end
        ::continue::
    end

    for i = 1, #(universe) do
        if array_contains(births, i) then
            universe[i] = 1
        else
            universe[i] = 0
        end
    end
end

initial_generation()
print(table.concat(universe, ", "))
while true do
    os.execute("sleep 1")
    os.execute("clear")
    new_generation()
    print(table.concat(universe, ", "))
end