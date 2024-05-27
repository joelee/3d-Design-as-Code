
// Work in progress

$fn=150;
length = 250;
thickness = 1.5;
height = 200;


module duct_tube(h=100, d=100) {
    difference() {
        cylinder(h=h, d=d);
        translate([0,0,-1])
            cylinder(h=h+2, d=d-2);
    }
}

duct_tube();