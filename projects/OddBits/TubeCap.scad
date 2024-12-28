$fn = 360;

difference() {
    union() {
        cylinder(h=1,d=12.5);
        cylinder(h=7,d=10.5);
        translate([0,0,7])
            cylinder(h=52, d1=10.5, d2=3);
    }
    translate([0,0,-0.2])
        cylinder(h=7.2,d=9.5);
    translate([0,0,7])
        cylinder(h=52, d1=9.5, d2=2);
}