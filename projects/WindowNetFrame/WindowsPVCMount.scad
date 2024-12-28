$fn = 360;

thickness = 2;
length = 120;
inner_height = 20;
outer_height = 20;
space = 3;

module test() {
    cube([length, thickness, inner_height]);
    cube([length, thickness * 3, thickness]);
    translate([0, thickness * 2, 0])
        cube([length, thickness, outer_height]);
}
    
module tri_cube(l, d, h) {
    linear_extrude(height = l)
        polygon([[0,0], [h,0], [0,d], [0,0]]);
}

tri_cube(130,10,15);