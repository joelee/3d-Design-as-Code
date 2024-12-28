
$fn = 360;

//cube([120,50,3], center=true);
translate([0,0,1.5])
    round_cube(120,50,3,6);
//    
translate([0,0,3])
    cylinder(h=25, d1=33.2, d2=30);

difference() {    
    translate([0,0,3])
        cylinder(h=2,d=50);
    translate([0,0,2.8])
        cylinder(h=5,d=48);
}

module round_cube(w, d, h, mr) {
    pad = mr * 2;
    minkowski() {
        cube([w-pad,d-pad,h], center=true);
        cylinder(r=mr,h=0.1);
   }
}