$fn = 360;

roller_width = 69;      // 69 for 1kg roll, 110 for 3kg roll
roller_diameter = 45;
bearing_outer_diameter = 22;
bearing_inner_diameter = 8.22;
bearing_height = 7;
bearing_notch = 1.5;

thread_size = 27;
thread_pitch = 0;

join_variance = 0.2;


notch_height = 2;
barrier_height = 2.6;
barrier_width = 1;

rail_length = bearing_height;
tilt_height = 60deg_height(bearing_outer_diameter/2);

h_unit = roller_width / 6;  // height unit
d1 = bearing_outer_diameter;
d2 = bearing_inner_diameter+bearing_notch*2;
mount_height = 60deg_height((d1 - d2)/2); 
force_height = 0; // 6.5;  // 0 to use calculated mount_height

screw_size = 2;
screw_length = 4;
self_tapping = false;
base_stand_height = 0;  // For container mount template


function 30deg_height(base) = base / sqrt(3);
function 60deg_height(base) = (base * 2) / sqrt(3);

// Using ISO screw thread modules by RevK @TheRealRevK
// https://www.thingiverse.com/thing:2158656
// Licensed under the Creative Commons - Attribution license.
include <ISOThread.scad>


module main_block_21() {
    difference() {
        union() {
            cylinder(h=barrier_width,d=roller_diameter+barrier_height*2);
            cylinder(h=h_unit*2, d=roller_diameter);
            translate([0,0,h_unit*2]) {
                // cylinder(h=h_unit*3, d=roller_diameter*0.75);
                iso_thread(l=h_unit*3, m=thread_size, p=thread_pitch, cap=1);
            }
        }
        cylinder(h=bearing_height, d=bearing_outer_diameter);
        translate([0,0,bearing_height])
            cylinder(h=tilt_height,d1=bearing_outer_diameter, d2=0);
    }
}

module main_block_22() {
    p=(thread_pitch?thread_pitch:iso_pitch_course(thread_size)); // standard pitch
    difference() {
        union() {
            cylinder(h=barrier_width,d=roller_diameter+barrier_height*2);
            cylinder(h=h_unit*4, d=roller_diameter);
        }
        translate([0,0,h_unit-p]) {
            // cylinder(h=h_unit*3+1, d=roller_diameter*0.75);
            //iso_thread(l=h_unit*3+5, m=roller_diameter*0.75, t=join_variance,cap=0);
            iso_thread(l=h_unit*3+(p*2), m=thread_size, p=p, t=join_variance,cap=0);
        }
        cylinder(h=bearing_height+join_variance, d=bearing_outer_diameter);
        translate([0,0,bearing_height+join_variance])
            cylinder(h=tilt_height,d1=bearing_outer_diameter, d2=0);
    }
}

module main_block_1() {
    bw = 60deg_height(barrier_height);
    difference() {
        union() {
            cylinder(h=bw,d1=roller_diameter+barrier_height*2, d2=roller_diameter);
            cylinder(h=roller_width, d=roller_diameter);
            translate([0,0,roller_width - bw])
                cylinder(h=bw,d1=roller_diameter, d2=roller_diameter+barrier_height*2);
        }
        cylinder(h=bearing_height, d=bearing_outer_diameter);
        translate([0,0,bearing_height])
            cylinder(h=tilt_height,d1=bearing_outer_diameter, d2=0);
        translate([0,0,roller_width - bearing_height])
            cylinder(h=bearing_height, d=bearing_outer_diameter);
        translate([0,0,roller_width - bearing_height - tilt_height])
            cylinder(h=tilt_height,d1=0, d2=bearing_outer_diameter);
    }
}

module bearing_mount() {
    h = force_height > 0 ? force_height : mount_height;
    cylinder(h=h,d1=d1,d2=d2);
    translate([0,0,h])
        cylinder(h=bearing_notch,d=d2);
    translate([0,0,h])
        cylinder(h=bearing_height+(bearing_notch*2),d=bearing_inner_diameter);
}

module container_mount() {
    h = force_height > 0 ? force_height : mount_height;
    d = bearing_outer_diameter+join_variance;
    difference() {
        union() {
            translate([-roller_diameter/2,-d,0])
                cube([d+bearing_notch*2,d*2,1]);
            if (base_stand_height) {
                container_mount_stand();
            } else {
                cylinder(h=h-join_variance,d1=bearing_outer_diameter+(bearing_notch*4),d2=bearing_outer_diameter);
            }
            if (self_tapping) {
                translate([-1,d-5,1])
                    cylinder(h=screw_length,d=screw_size*2.5);
                translate([-1,5-d,1])
                    cylinder(h=screw_length,d=screw_size*2.5);
                translate([5-d+bearing_notch,0,1])
                    cylinder(h=screw_length,d=screw_size*2.5);
            }
        }
        translate([0,-d/2,-1])
            cube([roller_diameter,d,12+bearing_height]);
        bearing_mount();
        if (self_tapping) {
            translate([-1,d-5,-1])
                cylinder(h=screw_length+1,d=screw_size*0.9);
            translate([-1,5-d,-1])
                cylinder(h=screw_length+1,d=screw_size*0.9);
            translate([5-d+bearing_notch,0,-1])
                cylinder(h=screw_length+1,d=screw_size*0.9);
        } else {
            translate([-1,d-5,-1])
                cylinder(h=2,d=screw_size);
            translate([-1,5-d,-1])
                cylinder(h=2,d=screw_size);
            translate([5-d+bearing_notch,0,-1])
                cylinder(h=2,d=screw_size);
        }
    }

}

module container_mount_stand() {
    h = force_height > 0 ? force_height : mount_height;
    d = 5;
    translate([-base_stand_height,-(d/2),0])
        cube([base_stand_height,d,1]);
    translate([-base_stand_height,-(d/2),0])
        cube([1,d,15]);
}

module standalone_mount() {
    t = 2;                       // Thickness
    h = 120;                       // Height from base
    ah = 60deg_height(h);          // Angled height
    bl = 30deg_height(h) * 2 + (t*2);  // Base Length
    
    m_screw = 2;
    
    mh = force_height > 0 ? force_height : mount_height;
    d = bearing_outer_diameter + (notch_height * 2);
    
    difference() { 
        union() {
            cylinder(h=10,d=d);
            // STILTS
            // Main Vertical
            translate([0,-t/2,0])
                cube([h, t, 10]);
            // Right 
            translate([0,-t/2,0])
                rotate([0, 0, 30])
                    cube([ah, t, 10]);
            // Left
            translate([0,-t/2,0])
                rotate([0, 0, -30])
                    cube([ah, t, 10]);
            
            // Bottom Base
            translate([h-(t/2),-(bl/2),0])
                cube([t, bl, 20]);
            // Bottom Board    
            translate([h-(t/2)-10,-(bl/2),0])
                cube([10, bl, t]);
                
            // Lower Left Support
            translate([(h/2),-(bl/4)+t,0]) rotate([0,0,-60])
                cube([t, bl/2-t, 10]);
            // Lower Right Support
            translate([h,-(t/2),0]) rotate([0,0,60])
                cube([t, bl/2-t, 10]);
                
            // Upper Right Main Support 
            translate([bl/3,-t/2,0])
                rotate([0, 0, 69])
                    cube([ah*0.27, t, 10]);
            // Upper Left Main Support
            translate([bl/3,-t/2,0])
                rotate([0, 0, -69])
                    cube([ah*0.27, t, 10]);
                    
            translate([h-4,-(bl/3),5])
                cube([10,10,10], center=true);
            translate([h-4,bl/3,5])
                cube([10,10,10], center=true);
            
        }
        translate([-d2-notch_height,-roller_diameter/2,10-mh+t])
            cube([d2+notch_height,roller_diameter,12+bearing_height]);
        translate([0,0,10-mh+t])
            bearing_mount();
        translate([h-(t/2)+t,-(bl/2),0])
                cube([t*2, bl, 20]);
        translate([bl/4,bl/4,0])
                rotate([0, 0, 30])
                    cube([ah, t*5, 10]);
                    
        // Screw holes and connector block            
        translate([h-4,-(bl/3),0])
            cylinder(h=20, d=m_screw);
        translate([h-4,bl/3,0])
            cylinder(h=20, d=m_screw);
        translate([h-(t/2),-(bl/3),15])
            cube([10,10,10], center=true);
        translate([h-(t/2),bl/3,15])
            cube([10,10,10], center=true);
    }
}

module standalone_connector() {
    length = 73;
    h = 10;
    t = 2;
    m_screw = 2;
    
    difference() {
        translate([0,0,length/2])
            cube([h,h,length], center=true);
        translate([0,0,0])
            cylinder(h=h, d=m_screw-join_variance);
        translate([0,0,length-h])
            cylinder(h=h, d=m_screw-join_variance);
    }
}


spacing = roller_diameter*1.2;

// standalone_mount();
//translate([- spacing,0,0])
    // standalone_connector();

// main_block_1();

//main_block_21();
//translate([spacing,0,0])
 //   main_block_22();
// translate([0,spacing,0])
    bearing_mount();
// container_mount_stand();

//translate([spacing,spacing,0])
//    container_mount();