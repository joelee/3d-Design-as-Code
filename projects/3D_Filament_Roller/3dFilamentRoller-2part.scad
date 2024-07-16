$fn = 360;

roller_width = 68;
bearing_outer_diameter = 22;
bearing_inner_diameter = 8;
bearing_height = 7;
join_variance = 0.2;


notch_height = 2;
barrier_height = 2.6;
barrier_width = 1;

d1 = bearing_outer_diameter + notch_height;
rail_length = bearing_height;
tilt_height = bearing_outer_diameter * 1.73205081; // 30 degs tilt

h_unit = roller_width / 4;  // height unit


module main_block_1() {
    difference() {
        union() {
            cylinder(h=barrier_width,d=d1+barrier_height*2);
            cylinder(h=h_unit*2, d=d1);
            translate([0,0,h_unit*2])
                cylinder(h=h_unit, d=d1/2);
        }
        cylinder(h=bearing_height, d=bearing_outer_diameter);
        translate([0,0,bearing_height])
            cylinder(h=tilt_height,d1=bearing_outer_diameter, d2=0);
    }
}

module main_block_2() {
    difference() {
        union() {
            cylinder(h=barrier_width,d=d1+barrier_height*2);
            cylinder(h=h_unit*2, d=d1);
        }
        cylinder(h=h_unit*2, d=d1/2+join_variance);
        cylinder(h=bearing_height+join_variance, d=bearing_outer_diameter);
        translate([0,0,bearing_height+join_variance])
            cylinder(h=tilt_height,d1=bearing_outer_diameter, d2=0);
    }
}


main_block_1();
translate([d1*2,0,0])
    main_block_2();
