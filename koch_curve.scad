/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
*/

//draw_koch_curve([1,1],[50,45], 2, 0.1);

/**
 * Draw a Koch curve from point a to b
 * a = [x1,y1] and b = [x2,y2] on a 2D cartesian plane
 * generation = 0..4, greater than 4 will crash OpenSCAD
 * width = should be made smaller the greater the generation, to see line detail
 * Created using OpenSCAD version 2015.03-1 
 */
module draw_koch_curve(a=[0,0], b=[0,0], generation=1, width=1) {
    points = koch_recurse([a,b],generation);
    for(i=[0:len(points)-1]) { 
        if(i+1<len(points)) {
            hull() {
                translate([points[i][0],points[i][1],0]) circle(d=width, $fn=100);
                translate([points[i+1][0],points[i+1][1],0]) circle(d=width, $fn=100);
            }
        }
    }
}

/**
 * Given a list of points and a number of iterations
 * recursively call to create a list of koch points
 * only finally returning the last calculated list 
 */
function koch_recurse(points, i) = i==0 ? koch_calculate_list(points) : koch_recurse(koch_calculate_list(points), i-1);

/**
 * Find 5 koch points _/\_ between the line given by points k1(x1,y1) and k5(x2,y2)
 * on a cartesian plane
 */
function koch_calculate(k1, k5) = 
    let(k2 = section_formula(k1,k5,1,2)) // 1:2 ratio between A and B
    let(k4 = section_formula(k1,k5,2,1)) // 2:1 ratio between A and B
    let(k3 = point_rotation(k2,k4,60)) // equilateral triangle between k2 and k4
    [k1,k2,k3,k4,k5]; // k1,k2,k3,k4,k5 for points creating lines _/\_

/**
 * Given a list of points [a,b,c,...] where a[x1,y1] b[x2,y2] ...
 * Return a list of koch points [a1,a2,a3,a4,a5,b1,b2,b3,b4,b5,...]
 * loop points and calculate 5 koch points for each a-b, b-c, c-d, ... then flatten list
 */
function koch_calculate_list(points) = flatten_list([for (p=[0:len(points)-1]) if (p+1<len(points)) koch_calculate(points[p],points[p+1])]);

/**
 * Flatten a list of vectors a single level
 * for example: [[[a,b],[c,d],[e,f]],[[g,h],[i,j],[k,l]]] to [[a,b],[c,d],[e,f],[g,h],[i,j],[k,l]]
 */
function flatten_list(list) = [for(a=list) for(b=a) b];

/**
 * Section Formula, find the point (P) along the line a(x1,y1) and b(x2,y2) with ratio m:n
 * a(x1,y1)----m----P(x,y)-----n-----b(x2,y2)
 * Px = (m*x2 + n*x1)/m+n , Py = (m*y2 + n*y1)/m+n
 */
function section_formula(a, b, m, n) = [((m*b[0])+(n*a[0]))/(m+n),((m*b[1])+(n*a[1]))/(m+n)];

/**
 * Rotate point p2 around degrees (d) using the origin of point p1
 * x' = x*cos(d)-y*sin(d)
 * y' = x*sig(d)+y*cos(d)
 * First reset to origin (p2-p1), perform the equation to get x' and y', then add back p1
 */
function point_rotation(p1, p2, d) = [(((p2[0]-p1[0])*cos(d)) - (p2[1]-p1[1])*sin(d))+p1[0], (((p2[0]-p1[0])*sin(d)) + ((p2[1]-p1[1])*cos(d))) +p1[1]];