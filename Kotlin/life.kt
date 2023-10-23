fun is_edge(i: Int, actual_width: Int, actual_height: Int): Boolean{
    return (i < actual_width) ||
    (i > (actual_width * actual_height) - actual_width) ||
    (i % actual_width == 0) ||
    ((i + 1) % actual_width == 0)
}

fun initial_generation(universe: Array<Int>, initial_lives: Int, width: Int, height: Int){
    var indexes: MutableList<Int> = mutableListOf()
    var current_i = 0
    for(i in universe.indices){
        if(is_edge(i, width + 2, height + 2)) continue
        indexes.add(i)
        current_i++
    }
    indexes.shuffle()
    val generation = indexes.slice(0..initial_lives)
    for(c in generation){
        universe[c] = 1
    }
}

fun new_generation(universe: Array<Int>, width: Int, height: Int){
    var births: MutableList<Int> = mutableListOf()

    for(i in universe.indices){
        if(is_edge(i, width + 2, height + 2)) continue
        val living_neighbors = universe[i + 1] +
            universe[i - 1] +
            universe[i + (width + 2)] +
            universe[i - (width + 2)] +
            universe[i + (width + 3)] +
            universe[i + (width + 1)] +
            universe[i - (width + 3)] +
            universe[i - (width + 1)]
        if(living_neighbors == 2 || living_neighbors == 3){
            births.add(i)
        }

    }
    for(c in universe.indices){
        if(is_edge(c, width + 2, height + 2)) continue
        if(births.contains(c)) universe[c] = 1
        else universe[c] = 0
    }
}

fun print_universe(universe: Array<Int>, width: Int, height: Int){
    var counter = 0
    for(c in universe.indices){
        if(is_edge(c, width + 2, height + 2)) continue
        print("| ${universe[c]} ")
        counter++
        if(counter % height == 0){
            print("| \n")
        }
    }
}

fun main(){
    val width = 40
    val height = 40
    val initial_lives = 500

    var universe = Array((width + 2) * (height + 2)) { 0 * it}

    initial_generation(universe, initial_lives, width, height)
    print_universe(universe, width, height)
    while(true){
        print("\u001b[H\u001b[2J")
        new_generation(universe, width, height)
        print_universe(universe, width, height)
        Thread.sleep(1000)
    }
}