
// cube([110, 230, 2]);

length = 380;
width = 230;
height = 220;
mid_len = 110;
thickness = 2;


side_len = (length - mid_len) / 2;
half_width = width / 2;


module base_piece() {
    linear_extrude(height = thickness) polygon(points=[
        [0,0], 
        [0, mid_len], 
        [half_width, length-side_len], 
        [width, mid_len], 
        [width, 0], 
        [half_width, -side_len]
    ]);
}

module full_set() {
    base_piece();
    translate([0, 0, height-thickness]) base_piece();


    ht = thickness / 2;
    translate([half_width - ht, -side_len+ht, ht])
        cube([thickness, side_len+ht, height - ht]);
    translate([half_width - ht, mid_len, ht])
        cube([thickness, side_len+ht, height - ht]);

    translate([0, 0, height/2-ht])
        cube([width, mid_len, thickness]);

    cube([half_width, thickness, height/2]);
    translate([half_width, 0, height/2])
        cube([half_width, thickness, height/2]);
    translate([0, mid_len, height/2])
        cube([half_width, thickness, height/2]);
    translate([half_width, mid_len, 0])
        cube([half_width, thickness, height/2]);
        
    cube([thickness, mid_len, height]);
    translate([width-thickness, 0, 0])
        cube([thickness, mid_len, height]);
}


//p_len = sqrt(height ^ 2 + mid_len ^ 2);
//angle = atan(height / mid_len);
//translate([half_width-ht, 0, ht]) rotate([angle-90, 0, 0])
//    cube([width/2+ht, thickness, p_len]);
//
//translate([0, mid_len, ht]) rotate([90-angle, 0, 0])
//    cube([width/2+ht, thickness, p_len]);
//    
//    


// Part 1
module part1() {
    difference() {
        full_set();
        translate([-1, thickness, -1])
            cube([width+2,length,height+2]);
        translate([-1, -side_len-1, -1])
            cube([width/2,length,height+2]);
        
    }
}

module part2() {
    difference() {
        full_set();
        translate([-1, -side_len-1, -1])
            cube([width+2,side_len+1+thickness,height+2]);
        translate([-1, mid_len, -1])
            cube([width+2,side_len+1+thickness,height+2]);
        translate([half_width, -1, -1])
            cube([width+2,length,height+2]);
    }
}

part2();