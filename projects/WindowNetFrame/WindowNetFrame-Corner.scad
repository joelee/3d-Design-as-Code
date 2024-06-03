// Magnet Countersunk 10x3x3mm
$fn = 360;

module corner_frame() {
    cube([200, 16, 3.2]);
    rotate([0,0,90])
        cube([115, 16, 3.2]);
        
    translate([200,0,0])
        male_joint();
        
    translate([250,0,0])
        female_joint();
 
    translate([0,115,0]) 
        rotate([0,0,90])
            male_joint();
}

module male_joint() {
    linear_extrude(3.2)
        polygon(points=[[0,5],[8,3],[8,13],[0,11]]);
}

module female_joint() {
    difference() {
        cube([15.8,15.8,3.2]);
        translate([-0.1,0,-0.2])
            linear_extrude(4)
                polygon(points=[[0,4.8],[8.2,2.8],[8.2,13.2],[0,11.2]]);
    }
}

difference() {
    corner_frame();
    translate([-6,10,0.2])
        cylinder(h=5, d=10);
    translate([160,8,0.2])
        cylinder(h=5, d=10);
    translate([-6,10,-1])
        cylinder(h=5, d=8);
    translate([160,8,-1])
        cylinder(h=5, d=8);
}
//
//translate([25,25,0]) 
//    difference() {
//    corner_frame();
//    translate([-6,10,-1])
//        cylinder(h=5, d=1);
//    translate([160,8,-1])
//        cylinder(h=5, d=1);
////    translate([-8,170,-1])
////        cylinder(h=5, d=1);
//    }

//female_joint();
//translate([15,0,0])
//    male_joint();