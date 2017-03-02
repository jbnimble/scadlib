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

draw_sierpinski_curve(50, 50, 100, 2);

/**
 * Draw a Sierpiński curve centered at point(x,y) with size n
 * generation = 0..4, greater than 4 will crash OpenSCAD
 * Created using OpenSCAD version 2015.03-1 
 */
module draw_sierpinski_curve(x=0,y=0, n=100, generation=1) {
    points = sierpenski_curve([[x,y,n]], generation);
    for(i=[0:len(points)-1]) {
        px = points[i][0];
        py = points[i][1];
        pn = points[i][2];
        lg_sq = pn/2;
        sm_sq = pn*(2-sqrt(2))/4; // inradius of isosceles right triangle where a=n/2
        translate([px,py]) square(lg_sq, true);
        for (xs=[1,-1], ys=[1,-1]) // x_sign and y_sign 
            translate([px+(xs*lg_sq/2),py+(ys*lg_sq/2)]) rotate(45) square(sm_sq, true);
    }
}

/**
 * Given a list of points and a number of iterations
 * recursively call to create a list of sierpenski points
 * only finally returning the last calculated list 
 */
function sierpenski_curve(points, i) = i==0 ? sierpinski_calculate_list(points) : sierpenski_curve(sierpinski_calculate_list(points), i-1);

/**
 * Dimensions (d) are [x,y,n]
 * Converts x,y,n to 5 smaller curves
 * point(x,y) are cartesian points
 * n is the size of the sierpenski square
 * divide into 9 sections, and only build the corners and center
 */
function sierpinski_calculate(d)= 
    let(x=d[0], y=d[1], n=d[2], size=n/2, offset=n/4)
    [for (xs=[1,0,-1], ys=[1,0,-1]) 
        if (abs(xs)+abs(ys) != 1) 
            [x+xs*offset,y+ys*offset,size]];

/**
 * Given a list of points [a,b,c,...] where a[x1,y1,n1] b[x2,y2,n2] ...
 * Return a list of sierpinski points [a1,a2,a3,a4,a5,b1,b2,b3,b4,b5,...]
 * loop points and calculate 5 sierpinski points for each given point then flatten list
 */
function sierpinski_calculate_list(points) = 
        flatten_list([for (p=[0:len(points)-1]) sierpinski_calculate(points[p])]);

/**
 * Flatten a list of vectors a single level
 * for example: [[[a,b],[c,d],[e,f]],[[g,h],[i,j],[k,l]]] to [[a,b],[c,d],[e,f],[g,h],[i,j],[k,l]]
 */
function flatten_list(list) = [for(a=list) for(b=a) b];
