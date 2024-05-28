/**
* Customisable Stackable Tray/Box with Text Label
* Designed to be printed without support.
* Version 1.0 
*
* See "Customisable parameters" section below to custom the organiser to your needs
*
* Source: https://github.com/joelee/3d-Design-as-Code/tree/master/projects/StackableTrays
*
* Recommended 3D-Printer Settings:
*            Layer Height: 0.2mm
*              Perimeters: 3
*      Top & Bottom Layer: 3
*                  Infill: 20%
*
* Author: Joseph Lee
*         https://github.com/joelee
*         https://www.linkedin.com/in/joeworks
*/

/**
* Customisable parameters
* [!] To be stackable the width, depth, corner_curve and wall thickness need to match.
*/

// Main block size
block_width = 100;
block_depth = 100;
block_height = 50;            // Set height to 0 to make a lid.
block_wall_thickness = 3;
corner_curve = 16.8;
stack_base_height = 1.5;

label_text = "Odd Bits";      // Set to "" will disable text rendering.
label_size = 12;
label_font = "Marker Felt:style=bold";
label_spacing = 1.0;

/**
* End of Customisable parameters
*
* You shouldn't need to modify anything pass here...
*/


$fn = 360;


// Round edge block - support 2 different widths (round-edge rectangle)
module round_edge_block(d, w1=0, w2=0, h=50, mr=2, drain=false) {
    w1 = w1==0 ? d : w1;
    w2 = w2==0 ? w1 : w2;
    of = drain ? (h/2)+2 : h/2;
    
    if (w1 == w2) {
        translate([0, 0, of])
            if (mr>0) {
                minkowski() {
                   cube([w1-(mr*2), d-(mr*2), h-2], center=true);
                   cylinder(r=mr,h=1);
                }
            } else {
                cube([w, d, h], center=true);
            }
    } else {
        translate([-d/2, 0, 27])
            minkowski() {
                hull() {
                    translate([d,0,0]) cube([1, w1, h], center=true);
                    cube([1, w2, h], center=true);
                }
                cylinder(r=mr,h=h);
            }
    }
    if (drain) drain_block(min(w1, w2, d));
}

// Render a block
module make_block(w, d, h) {
    round_edge_block(d=d, w1=w, h=h, mr=corner_curve);
}

module main_block() {
    layer_height = 0.2;
    iter_count = ((block_wall_thickness / 3) * 2) / layer_height;
    w_increment = layer_height * (3/2); 
    
    // Main Cube
    translate([0,0,0])
        make_block(block_width, block_depth, block_height);
    
    // Bottom curve @ 30deg so it can be printed without support    
    for ( i = [0:iter_count] ) {
        translate([0,0,(i*layer_height*-1)])
            make_block(
                block_width-(i*0.3), 
                block_depth-(i*0.3), 
                3
            );
    }
    
    // Base sized to be stackable
    translate([0,0,(iter_count*layer_height*-1)-stack_base_height])
        make_block(
            block_width-(block_wall_thickness*1.1), 
            block_depth-(block_wall_thickness*1.1), 
            5 + stack_base_height
        );
}

module render_text() {
    translate([0, (block_depth/2)-0.3, (block_height/2)]) rotate([90,0,180])
        linear_extrude(8)
            text(
                label_text, size=label_size, font=label_font, 
                spacing = label_spacing, valign="center", halign="center"
            );
}

module main() {
    difference() {
        main_block();
        // Block to carve the storage space in the cube
        translate([0,0,-1.0])
            make_block(
                block_width-block_wall_thickness, 
                block_depth-block_wall_thickness, 
                block_height+2
            );
        if (label_text) 
            render_text();
    }
}

main();
