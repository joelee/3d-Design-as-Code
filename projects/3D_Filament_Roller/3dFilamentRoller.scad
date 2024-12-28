$fn = 360;

roller_width = 67;
roller_diameter = 20;
bearing_diameter = 22;
bearing_height = 7;


//
notch_height = 2;
notch_len = notch_height * 1.73205081; // 30 degs tilt

d1 = bearing_diameter + notch_height;
d2 = bearing_diameter + (notch_height*3);
d3 = roller_diameter + notch_height;
rail_length = bearing_height;
tilt_height = (d2-d3) * 1.73205081; // 30 degs tilt


module main_block() {
    
    cylinder(h=roller_width, d=d3);
    translate([0,0,0])
        cylinder(h=tilt_height, d1=d2, d2=d3);
    translate([0,0,roller_width-tilt_height])
        cylinder(h=tilt_height, d1=d3, d2=d2);
}

difference() {
    main_block();
    cylinder(h=roller_width, d=bearing_diameter-(notch_height*2));
    translate([0,0,0])
        cylinder(h=bearing_height, d=bearing_diameter);
    translate([0,0,roller_width-bearing_height])
        cylinder(h=bearing_height, d=bearing_diameter);
    translate([0,0,bearing_height-(notch_height/5)])
        cylinder(h=notch_len, d1=bearing_diameter, d2=bearing_diameter-(notch_height*2));
}

module old_main_block() {
    
    cylinder(h=roller_width, d=d3);
    cylinder(h=rail_length, d1=d1, d2=d2);
    translate([0,0,roller_width-rail_length])
        cylinder(h=rail_length, d1=d2, d2=d1);
    translate([0,0,rail_length])
        cylinder(h=tilt_height, d1=d2, d2=d3);
    translate([0,0,roller_width-rail_length-tilt_height])
        cylinder(h=tilt_height, d1=d3, d2=d2);
}