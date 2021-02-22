# convex-hull
The convex hull of the set is the smallest convex polygon that contains all the points of it
Analogue of sorting-problem in computational geometry.  

`ConvexHull(A) = boundary of smallest convex set containing A`

Run Project using Julia and [Pluto](https://github.com/fonsp/Pluto.jl)
Resources: [Plots](https://github.com/goropikari/PlotsGallery.jl)

## Jarvis march (Chand & Kapur, 1970)
This algorithm takes `O(nh)` where `h` is the number of vertices in the convex hull

```
Find the extreme points (x_a, x_b)
Divide points by a line conjoining them
Add point with least angle below x_a from the y-axis until x_b
Repeat above
```

## Graham's scan (Ronald Graham , 1972)
This algorithm has `O(n log n)` time complexity

```
1. Find min(y) = p_0
2. sort according to polar angle from p_0
3. Initialize a Stack, `S`
4. push (S, p_0)
5. push (S, p_1)
6. push (S, p_2)
7. for point in points:
    # pop the last point from the stack if we turn clockwise to reach this point
    while count stack > 1 and ccw(next_to_top(S), top(S), point) <= 0:
        pop stack
    push point to stack
end
```
