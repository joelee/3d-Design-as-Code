$fn = 360;


//fan_base();
air_filter_fan_box_with_controller_box(extension_box=38);
//
//translate([0, 220,0])
    //air_filter_fan_mount(extension_box=38);
//basic_fan_grill();

//air_filter_seal_mount();

fit_variance = 0.8;

// Standard 140mm Case Fan
// Basic Grill
module basic_fan_grill() {
    fan_grill(
        size = 140,
        thickness = 2.5,
        grill_gap = 22,
        edge = 33
    );
}

// Air Filter Mount (Part 1.1)
module air_filter_fan_mount(
    size = 140,
    af_inner_diag = 155,
    af_inner_height = 23,
    af_outer_diag = 188,
    af_outer_height = 12,
    seal_height = 3,
    seal_width_inner = 10,
    seal_width_outer = 2,
    thickness = 2.5,
    extension_box = 0
) {
    difference() {
        union() {
            fan_grill(
                size = size,
                thickness = thickness,
                grill_gap = 0,
                edge = af_outer_diag - 135,
                extension_box = extension_box
            );
            translate([140/2, 140/2, 0])
                cylinder_pipe(d=af_inner_diag, thickness=af_inner_height, width=1.8);
            translate([140/2, 140/2, 0])
                cylinder_pipe(d=af_outer_diag+2.2, thickness=af_outer_height, width=2);
            translate([140/2, 140/2, thickness])
                cylinder_pipe(d=af_inner_diag+seal_width_inner, thickness=seal_height, width=seal_width_inner);
            translate([140/2, 140/2, thickness])
                cylinder_pipe(d=af_outer_diag-seal_width_outer, thickness=seal_height, width=seal_width_outer);
        }
        // Fan 
        drill_screw_holes(size=size, thickness=10);
        // Tap-in screw onto filter: 2mm
        pos = (af_outer_diag - af_inner_diag) / 2;
        translate([-pos, 140/2, -1])
            cylinder(d=2, h=thickness+2);
        translate([size+pos, 140/2, -1])
            cylinder(d=2, h=thickness+2);
        translate([140/2, -pos, -1])
            cylinder(d=2, h=thickness+2);
        translate([140/2, size+pos, -1])
            cylinder(d=2, h=thickness+2);
            
    }
}

// Air Filter Mount (Part 1.2)
module air_filter_seal_mount() {
    af_inner_diag = 154.4;
    af_outer_diag = 188;
    
    union() {
        translate([140/2, 140/2, 0])
            cylinder(d=af_outer_diag+2.2, h=2.5);
        translate([140/2, 140/2, 0])
            cylinder_pipe(d=af_inner_diag, thickness=18, width=1.8);
        translate([140/2, 140/2, 0])
            cylinder_pipe(d=af_outer_diag+2.2, thickness=8, width=2);
    }
}

// Air Filter Fan Box (Part 2)
module air_filter_fan_box(
    size=140.8, 
    thickness=1.5, 
    fan_depth=28.6, 
    screw_from_edge=5.4,
    af_outer_diag = 188,
    extension_box=0
) {
    length = size + (thickness * 2);
    fan_grill(
        size = size,
        thickness = thickness,
        screw_from_edge=screw_from_edge,
        grill_gap = 23,
        edge = 0
    );
    height_pad = thickness;
    if (af_outer_diag > 0) {
        height_pad = thickness * 2;
    } 
    
    difference() {
        union() {
            translate([-thickness, -thickness, 0])
                cube([length, thickness, fan_depth+height_pad]);
            translate([-thickness, -thickness, 0])
                cube([thickness, length, fan_depth+height_pad]);
                
            translate([-thickness, size, 0])
                cube([length, thickness, fan_depth+height_pad]);
            if (extension_box == 0) {
                translate([size, -thickness, 0])
                    cube([thickness, length, fan_depth+height_pad]);
            } else {
                translate([size, -thickness+(length/3), 0])
                    cube([thickness, length/3, (fan_depth/4)+thickness]);
                difference() {
                    translate([size, -thickness, 0])
                        cube([extension_box+thickness, length, fan_depth+height_pad]);
                    translate([size-1, 0, thickness])
                        cube([extension_box+1, size, fan_depth+(thickness*3)]);
                }
            }
        }
        
        if (af_outer_diag > 0) {
            translate([140/2, 140/2, fan_depth])
                cylinder(d=af_outer_diag+2.4, h=fan_depth);
        }
        
    }
    
}

module air_filter_fan_box_with_cable_notch() {
    // Add notch for cable, and 2 screw holes for stand
    difference() {
        air_filter_fan_box();
        translate([16,-2,25])
            cube([6,5,5]);
        translate([20,3,12])
            rotate([90,0,0])
                cylinder(h=20, d=3);
        translate([120,3,12])
            rotate([90,0,0])
                cylinder(h=20, d=3);
        
    }
}


module air_filter_fan_box_with_controller_box(extension_box=38) {
    // Add notch for cable, and 2 screw holes for stand
    difference() {
        air_filter_fan_box(extension_box=extension_box);
        // Power Socket: 11mm
        translate([163,3,15])
            rotate([90,0,0])
                cylinder(h=20, d=11);
        // On/Off Switch: 29 x 13 mm 
        translate([145,65,-1])
            cube([29,13,10]);
        // Speed Knob: 8mm
        translate([160,145,15])
            rotate([90,0,0])
                cylinder(h=20, d=8);
    }
}


module drill_screw_holes(
    size = 140, 
    thickness = 2.5,
    screw_from_edge = 5.3, 
    screw_diag = 4
) {
    screw_centre = screw_from_edge + (screw_diag / 2);
    edges = [screw_centre, size - screw_centre];
    for (x = edges, y = edges)
        translate([x, y, -1])
            cylinder(h=thickness+2, d=screw_diag);
}

module fan_base(
    size = 140, 
    thickness = 2.5, 
    edge = 8,
    diameter = 135,
    screw_from_edge = 5.3,
    screw_diag = 4.3,
    extension_box = 0
) {
    cube([size + extension_box , size, thickness]);
    if (edge > 0) {
        translate([size/2, size/2, 0])
            cylinder(h=thickness, d=diameter + edge);
    }
}

module make_grill_std(d = 135, thickness = 2.5, width=1.2, gap=22) {
    difference() {
        cylinder(h=thickness, d=d);
        if (gap > 0) {
            mid_point = (-d/2);
            translate([-width/2, -d/2, -1])
                cube([width, d, thickness +2]);
            translate([-d/2, -width/2, -1])
                cube([d, width, thickness +2]);
            for (i = [gap:gap+width:d]) {
                translate([0,0,-1])
                    cylinder_pipe(d=i, thickness=thickness+2, width=width);
            }
        }
    }
}

module cylinder_pipe(d,thickness = 2.5, width=1.2) {
    difference() {
        cylinder(h=thickness, d=d);
        translate([0,0,-1])
            cylinder(h=thickness+2, d=d-width);
    }
}

module fan_grill(
    size = 140, 
    thickness = 2.5, 
    edge = 8,
    diameter = 135,
    screw_from_edge = 5.3,
    screw_diag = 4.3,
    grill_gap = 22,
    extension_box = 0
) {
    difference() {
        fan_base(size, thickness, edge, diameter, screw_diag, extension_box=extension_box);
        translate([size/2, size/2, -1])
            make_grill_std(d=diameter, thickness=thickness+2, gap=grill_gap);
        drill_screw_holes(
            size=size, 
            thickness=thickness,
            screw_from_edge = screw_from_edge,
            screw_diag = screw_diag
        );
        
    }
}
