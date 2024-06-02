/**
* Customisable Stackable Tray/Box with Text Label
* Designed to be printed without support.
* Version 1.0 
*
* This is a Base Module to be included by another SCAD file.
* See the StackableTrayExample.scad for usage example.
*
* Source: https://github.com/joelee/3d-Design-as-Code/tree/master/projects/StackableTrays
*
* Recommended 3D-Printer Settings:
*            Layer Height: 0.2mm (Change layer_height below to match your setting)
*              Perimeters: 3
*      Top & Bottom Layer: 3
*                  Infill: 20%
*
* Author: Joseph Lee
*         https://github.com/joelee
*         https://www.joeworks.com
*/

/**
* Customisable parameters
* [!] To be stackable the width, depth, corner_curve and wall thickness need to match.
*/

// Main block size
//block_width = 160;
//block_depth = 130;
//block_height = 50;            // Set height to < 6 to make a lid.
//block_wall_thickness = 3;
//corner_curve = 3.8;  // 16.8;
//stack_base_height = 1.5;
//
//label_text = "Custom Box";      // Set to "" will disable text rendering.
//label_size = 12;
//label_font = "Marker Felt:style=bold";
//label_spacing = 1.0;

/**
* separators
*/
//separator_thickness = 1.5;    // Set to 0 to disable separators
//separators = [
    // 4 element array:
    //   1. "w" or "d" for Width or Depth
    //   2. Location offset (percentage: 0 to 100). 50 (default) is in the centre.
    //   3. Starting offset (percentage). Default to 0.
    //   4. Ending offset (percentage). Default to 100. 
    // ["w", 50],
    // ["d", 25, 0, 50],
    // ["d", 75]
    // Above example will print:
    //            d            d
    //   |------------------------------| 0
    //   |        |            |        |
    // w |----------------------        | 50
    //   |                     |        |
    //   |------------------------------| 100
    //           25           75
//];

/**
* End of Customisable parameters
*
* You shouldn't need to modify anything pass here...
*/
//layer_height = 0.2;
//$fn = 360;

// Round edge block - support 2 different widths (round-edge rectangle)
module round_edge_block(d, w1=0, w2=0, h=50, mr=2, drain=false) {
    w1 = w1==0 ? d : w1;
    w2 = w2==0 ? w1 : w2;
    of = drain ? (h/2)+2 : h/2;
    
    if (w1 == w2) {
        translate([0, 0, of])
            if (mr>0 && h > 0) {
                minkowski() {
                   cube([w1-(mr*2), d-(mr*2), h], center=true);
                   cylinder(r=mr,h=1);
                }
            } else {
                cube([w1, d, h], center=true);
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
}

// Render a block
module make_block(w, d, h) {
    round_edge_block(d=d, w1=w, h=h, mr=corner_curve);
}

module main_block() {
    if ( ! layer_height ) {
        layer_height = 0.2;
    }
    iter_count = ((block_wall_thickness / 3) * 2) / layer_height;
    w_increment = layer_height * (3/2); 
    
    // Main Cube
    translate([0,0,0])
        make_block(block_width, block_depth, block_height);
    
    // Make a lid
    if (block_height < 6) {
        translate([0,0,block_height])
            make_block(
                block_width-block_wall_thickness-layer_height, 
                block_depth-block_wall_thickness-layer_height, 
                1 + stack_base_height
            );
    } else {    
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
}

module render_text() {
    translate([0, (block_depth/2)-0.3, (block_height/2)]) rotate([90,0,180])
        linear_extrude(8)
            text(
                label_text, size=label_size, font=label_font, 
                spacing = label_spacing, valign="center", halign="center"
            );
}

module render_width_separator(location=50, from=0, to=100, height=100) {
    length = block_width * ((to-from)/100) - (block_wall_thickness * 2);
    
    base_depth_offset = -(block_depth/2);
    base_width_offset = -(block_width/2) + (length/2);
    
    location_offset = base_depth_offset + (block_depth * (location/100));
    offset = base_width_offset + (block_width * (from/100)) + (block_wall_thickness);
    
    height_offset = (block_wall_thickness / 3 * 2) + stack_base_height;
    separator_height = (block_height-height_offset) * (height/100);
    
    translate([offset,location_offset, (separator_height/2)-height_offset])
        cube([length, separator_thickness, separator_height], center=true);
}

module render_depth_separator(location=50, from=0, to=100, height=100) {
    length = block_depth * ((to-from)/100) - (block_wall_thickness * 2);
    
    base_depth_offset = -(block_depth/2) + (length/2);
    base_width_offset = -(block_width/2);
    
    location_offset = base_width_offset + (block_width * (location/100));
    offset = base_depth_offset + (block_depth * (from/100)) + (block_wall_thickness);
    
    height_offset = (block_wall_thickness / 3 * 2) + stack_base_height;
    separator_height = (block_height-height_offset) * (height/100);
    
    translate([ location_offset, offset, (separator_height/2)-height_offset])
        cube([separator_thickness, length, separator_height], center=true);
}

module box_block() {
    difference() {
        main_block();
        // Block to carve the storage space in the cube
        if (block_height > 5)
            translate([0,0,-1.0])
                make_block(
                    block_width-(block_wall_thickness*2), 
                    block_depth-(block_wall_thickness*2), 
                    block_height+stack_base_height
                );
    }
    // Render separator
    if ( separator_thickness > 0 ) {
        for ( s = separators ) {
            c = len(s);
            location = c > 1 ? s[1] : 50;
            from = c > 2 ? s[2] : 0;
            to = c > 3 ? s[3] : 100;
            height = c > 4 ? s[4] : 100;
            if ( s[0] == "w" ) {
                render_width_separator(location, from, to, height);
            } else if ( s[0] == "d" ) {
                render_depth_separator(location, from, to, height);
            }
        }
    }
}

module main() {
    if ( ! layer_height ) {
        layer_height = 0.2;
    }
    if (block_height <= 0) {
        block_height = layer_height * 3;
    }
    difference() {
        box_block();
        if (label_text && block_height > 10) 
            render_text();
    }
}
