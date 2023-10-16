#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/random.h>
#define WIDTH 40
#define HEIGHT 40
#define ACTUAL_WIDTH 42
#define ACTUAL_HEIGHT 42
#define INITIAL_LIVING 100

int universe[ACTUAL_HEIGHT * ACTUAL_WIDTH];
int initial_indexes[INITIAL_LIVING];

int is_edge(int index){
    return ((index < ACTUAL_WIDTH) ||
    (index > (ACTUAL_WIDTH * ACTUAL_HEIGHT) - ACTUAL_WIDTH) ||
    (index % ACTUAL_WIDTH == 0) ||
    ((index + 1) % ACTUAL_WIDTH == 0));
}

void shuffle(int array[], size_t n) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    int usec = tv.tv_usec;
    srand48(usec);


    if (n > 1) {
        size_t i;
        for (i = n - 1; i > 0; i--) {
            size_t j = (unsigned int) (drand48()*(i+1));
            int t = array[j];
            array[j] = array[i];
            array[i] = t;
        }
    }
}

void initial_generation(){
    int inner_indexes[WIDTH * HEIGHT];
    int current_index = 0;
    for(int i = 0; i < (ACTUAL_HEIGHT * ACTUAL_WIDTH); i++){
        if(is_edge(i)) continue;
        inner_indexes[current_index] = i;
        if(++current_index == (WIDTH * HEIGHT)) break;
    }
    shuffle(inner_indexes, WIDTH * HEIGHT);
    for(int i = 0; i < INITIAL_LIVING; i++){
        universe[inner_indexes[i]] = 1;
    }
}

void print_universe(){
    int counter = 0;
    for(int i = 0; i < (ACTUAL_HEIGHT * ACTUAL_WIDTH); i++){
        if(is_edge(i)) continue;
        printf("| %s ", universe[i] ? "\033[92mX\033[0m": "0");
        if(++counter % HEIGHT == 0){
            puts("| \n");
        }
    }
}

void new_generation(){
    int *births = (int *)calloc(1, sizeof(int));
    int *deaths = (int *)calloc(1, sizeof(int));
    int births_size = 0;
    int deaths_size = 0;
    for(int i = 0; i < (ACTUAL_HEIGHT * ACTUAL_WIDTH); i++){
        if(is_edge(i)) continue;
        int living_neighbors = (universe[i + 1] +
            universe[i - 1] +
            universe[i + ACTUAL_WIDTH] +
            universe[i - ACTUAL_WIDTH] +
            universe[i + ACTUAL_WIDTH + 1] +
            universe[i + ACTUAL_WIDTH - 1] +
            universe[i - ACTUAL_WIDTH - 1] +
            universe[i - ACTUAL_WIDTH + 1]);
        if(universe[i] && (living_neighbors < 2 || living_neighbors > 3)){
            deaths[deaths_size] = i;
            deaths_size++;
            deaths = reallocarray(deaths, (size_t) deaths_size + 1, sizeof(int));
        }
        else if(!universe[i] && (living_neighbors == 2 || living_neighbors == 3)){
            births[births_size] = i;
            births_size++;
            births = reallocarray(births, (size_t) births_size + 1, sizeof(int));
        }
    }
    for(int b = 0; b < births_size; b++){
        universe[births[b]] = 1;
    }
    for(int d = 0; d < deaths_size; d++){
        universe[deaths[d]] = 0;
    }
    free(births);
    free(deaths);
}

int main(){
    initial_generation();
    print_universe();
    for(int t = 0; t < 50; t++){
        system("clear");
        new_generation();
        print_universe();
        sleep(1);
    }
    return 0;
}