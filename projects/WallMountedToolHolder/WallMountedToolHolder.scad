$fn = 180;


difference() {
    union() {
        cube([100,45,30]);
        translate([0,39.8,25])
            rotate([18,0,0])
            cube([100,8,5]);
    }
    translate([-1,45,-1])
        cube([102,45,50]);
    translate([-10,90,-65])
        rotate([0,90,0])
            cylinder(h=150, d=200);
    translate([6.8,18,-1])
        cylinder(h=50,d=10);
    translate([1.8,1.8,1])
        cube([10, 10, 50]);
    translate([13.8,1.8,25])
        cube([72, 30, 50]);
        
    translate([13.8,2.8,1])
        cube([25, 10, 50]);
    translate([60.8,2.8,1])
        cube([25, 10, 50]);
    translate([39.8,2.8,1])
        cube([20, 10, 50]);
        
    translate([88,1.8,1])
        cube([10, 10, 50]);
    translate([88,15,-1])
        cube([10, 50, 50]);
    translate([2,25,-1])
        cube([9, 50, 50]);
    translate([13.8,33.8,-1])
        cube([72, 30, 50]);
}

