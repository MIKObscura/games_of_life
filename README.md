This is a small project where I make Conway's Game of Life in as many languages as possible  
Languages done for now:  
* Python
* Ruby
* C
* Kotlin
* Haskell (kinda)

Due to laziness, the display is only done through text output in console and has a 0 to represent a dead cell and a green X to represent a living cell.  
# Algorithm
The algorithm behind all of these different programs is the same and works as follows:  
The universe is represented as a one-dimensional array of 0s and 1s, to avoid using lots of conditionals to find if the cell we are computing is on the edge of the universe, a boundary of 0s is used around the universe so that each cell always has 8 neighbors, the 'cells' in these boundaries are just skipped when computing.

Of course we do have to use conditionals to determine if we are in the boundary or not but I believe this is better since here we just test if the cell is in the boundary, and skip it if so. However, finding which cell is at the edge is a little more complex here due to the use of a one-dimensional array but I think my solution to this is pretty simple and efficient.

For a universe of width W and height H, we need to add 2 to both of these to get the actual height and width with boundary included, we can then find which cell are in the boundray, it's easier to understand when laying down the universe as a table:

* the first row is the upper boundary and goes from index 0 to the actual width - 1
* the last row is the lower boundary and goes from index (actual width * actual height) - actual width to the end of the array
* the first column is the left boundary and contains all cells whose index % actual width = 0
* the last column is the right boundary and contais all cells whose index + 1 % actual width = 0

For example, for a universe of width and height of 50:  
        &emsp;&emsp;&emsp;&emsp;left&emsp;&emsp;&emsp;right  
        &emsp;&emsp;&emsp;&emsp;↓&emsp;&emsp;&emsp;&emsp;&ensp;↓  
upper → 0  1  2  3  4...  51  
&emsp;&emsp;&emsp;&emsp;52 53 54... 103  
&emsp;&emsp;&emsp;&emsp;.  
&emsp;&emsp;&emsp;&emsp;.  
&emsp;&emsp;&emsp;&emsp;.  
lower → 2450 2451... 2499  

Then, we compute each cell by adding all its neighbors together. Finding those neighbors is also slightly more complicated due to the use of a one dimensional array but it's not difficult to understand.  
To the cells to the left and right, we subtract and add 1 to the cell's index. Then, to get the cells over and under, we take these 3 cells and subtract or add the actual width to their index.  

c&emsp;d&emsp;e  
a **cell** b  
f&emsp;g&emsp;h  

(i = cell's index)  
* a = i - 1
* b = i + 1
* c = i - actual width - 1
* d = i - actual width
* e = i - actual width + 1
* f = i + actual width - 1
* g = i + actual width
* h = i + actual width + 1


Then, after adding the neighbors together, one of 2 things can happen
* if the cell is alive and has less than 2 or more than 3 neighbors, the cell dies
* if the cell is dead and has 2 or 3 living neighbors, the cell births
* in any other case, nothing happens  
This can be simplified as: if a cell has two or three living neighbors, it lives, otherwise it dies.