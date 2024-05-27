
// Work in progress

length = 250;
thickness = 1.5;
height = 200;


cube([length,thickness,height]);

translate([length/2,-length/2,0]) rotate([0,0,90]) cube([length,thickness,height]);