// Magnet Countersunk 10x3x3mm
$fn = 360;

thickness=5.0;
thread_diameter=3.0;     // Sample1 @ 2.6 - measured 2.0-ish
thread_distance=40;
magnet_diameter=10.3;    // Sample1 @ 10.2 too tight - measured 9.88
magnet_every=3;

module corner_frame(height=150, width=150) {
    difference() {
        union() {
            cube([height, 16, thickness]);
            rotate([0,0,90])
                cube([width, 16, thickness]);
                
            translate([height,0,2])
                male_joint();
                
            translate([0,width,2]) 
                rotate([0,0,90])
                    male_joint();
        }
        // Corner magnet mount
        translate([-6,10,0.8])
            cylinder(h=5, d=magnet_diameter);
        translate([-6,10,-1])
            cylinder(h=5, d=thread_diameter);
            
        // Height side Thread Holes
        for ( x = [thread_distance:thread_distance:height-magnet_diameter]) {
            translate([x,8,-1])
                cylinder(h=15, d=thread_diameter);
            if ( x % (thread_distance * magnet_every) == 0 ) {
                // Magnet mount
                translate([x,8,1.8])
                    cylinder(h=15, d=magnet_diameter);
            }
        }
        
        // Width side Thread Holes
        for ( x = [thread_distance:thread_distance:width-magnet_diameter]) {
            translate([-8,x,-1])
                cylinder(h=15, d=thread_diameter);
            if ( x % (thread_distance * magnet_every) == 0 ) {
                // Magnet mount
                translate([-8,x,1.8])
                    cylinder(h=15, d=magnet_diameter);
            }
        }
        
        // Join Thread Holes
        offset=magnet_diameter/2;
        translate([height-offset,8,-1])
            cylinder(h=15, d=thread_diameter);
        translate([-8,width-offset,-1])
            cylinder(h=15, d=thread_diameter);
        
    }
}

module side_frame(length, hole_offset=0) {
    difference() {
        cube([length,16,thickness]);
        for ( x = [thread_distance+hole_offset:thread_distance:length-15]) {
            translate([x,8,-1])
                cylinder(h=15, d=thread_diameter);
            if ( (x - hole_offset) % (thread_distance * magnet_every) == 0 ) {
                // Magnet mount
                translate([x,8,1.8])
                    cylinder(h=15, d=magnet_diameter);
            }
        }
    }
}

module connecting_frame_ff(length) {
    hole_offset = 12;
    difference() {
        side_frame(length, hole_offset);
        translate([-0.1,0,1.8])
            female_joint();
        translate([length+0.1,0,16.8])
            rotate([0,180,0])
                female_joint();
        // Join Thread Holes
        translate([hole_offset,8,-1])
            cylinder(h=15, d=thread_diameter);
        translate([length-hole_offset,8,-1])
            cylinder(h=15, d=thread_diameter);
    }
}

module connecting_frame_fm(length) {
    hole_offset = 12;
    difference() {
        side_frame(length, hole_offset);
        translate([-0.1,0,1.8])
            female_joint();
        // Join Thread Holes
        translate([12,8,-1])
            cylinder(h=15, d=thread_diameter);
        translate([length-5,8,-1])
            cylinder(h=15, d=thread_diameter);
    }
    translate([length,0,2])
        male_joint();
}

module male_joint() {
    linear_extrude(3)
        polygon(points=[[0,5],[8,3],[8,13],[0,11]]);
}

module female_joint() {
    linear_extrude(15)
        polygon(points=[[0,4.8],[8.1,2.8],[8.1,13.2],[0,11.2]]);
}

// corner_frame(170, 170);
// translate([99,0,0])
   connecting_frame_ff(215);