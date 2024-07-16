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
*            Layer Height: 0.2mm 
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
block_width = 160;
block_depth = 130;
block_height = 50;            // Set height to < 6 to make a lid.
block_wall_thickness = 1.5;
corner_curve = 3.8;
stack_base_height = 1.5;
join_variance = 0.2; 

// Side Label
label_text = "Custom Box";      // Set to "" will disable text rendering.
label_size = 12;
label_font = "Marker Felt:style=bold";
label_spacing = 1.0;

// Stackable setting
// 0 - Not stackable, 1 - Stackable with Support, 2 - Stackable without support
stackable = 2;

/**
* separators
*/
separator_thickness = 1.5;    // Set to 0 to disable separators
separators = [
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
];


/**
* End of Customisable parameters
*
* You shouldn't need to modify anything pass here...
*/
$fn = 360;

function 30deg_height(base) = base / sqrt(3);
function 60deg_height(base) = (base * 2) / sqrt(3);


module render_text() {
    translate([0, (block_depth/2)-0.3, (block_height/2)]) rotate([90,0,180])
        linear_extrude(8)
            text(
                label_text, size=label_size, font=label_font, 
                spacing = label_spacing, valign="center", halign="center"
            );
}

module render_separator(type="w", location=50, from=0, to=100, height=100) {
    target_block = type=="w" ? block_width : block_depth;
    other_block = type=="w" ? block_depth : block_width;
    
    length = target_block * ((to-from)/100) - (block_wall_thickness * 2);
    
    target_offset = -(target_block/2) + (length/2);
    other_offset = -(other_block/2);
    
    location_offset = other_offset + (other_block * (location/100));
    offset = target_offset + (target_block * (from/100)) + (block_wall_thickness);
    
    height_offset = stack_base_height;
    if (stackable == 2) {
        height_offset = height_offset + (block_wall_thickness / 3 * 2);
    }
    separator_height = (block_height-height_offset) * (height/100);
    
    if (type=="w") {
        translate([offset,location_offset, separator_height/2])
            cube([length, separator_thickness, separator_height], center=true);
    } else {
        translate([ location_offset, offset, separator_height/2])
            cube([separator_thickness, length, separator_height], center=true);
    }
}

module round_edge_block(width,depth,height,curve=6,scale=1) {
    linear_extrude(height = height, scale = scale)
        if (curve==0) {
            square([width,depth],center=true);
        } else {
            minkowski() {
                square([width-curve,depth-curve],center=true);
                circle(d=curve);
            }
        }
}

module round_edge_box_std(width,depth,height,curve=6,wall=1.6,base=1,variance=0) {
    difference() {
        round_edge_block(width,depth,height,curve);
        if (wall>0) {
            diff = wall * 2 + variance * 2;
            translate([0,0,base < 0 ? 0 : base])
                round_edge_block(width-diff,depth-diff,height,curve);
        }
    }
}

module round_edge_box_scaled(width,depth,height,curve=6,wall=2,base=1,scale=1.2,variance=0) {
    difference() {
        round_edge_block(width/scale,depth/scale,height,curve,scale);
        if (wall>0) {
            diff = wall * 2 + variance * 2;
            translate([0,0,base])
                round_edge_block(width/scale-diff,depth/scale-diff,height,curve,scale);
        }
    }
}

module round_edge_box_stackable(width,depth,height,curve=6,wall=1.6,base=1,variance=0.2) {
    c_height = 30deg_height(wall);
    c_width = width - variance * 2;
    c_depth = depth - variance * 2;
    
    c_size = (width > depth ? width : depth);
    scale = c_size / (c_size - wall);
    round_edge_box_scaled(width,depth,c_height,curve,wall,0,scale, variance);
    translate([0,0,c_height])
        round_edge_box_std(width,depth,height-c_height,curve,wall,0,variance);
    translate([0,0,-base]) 
        round_edge_block(width/scale,depth/scale,base,curve);
}

module round_edge_box_stackable_with_support(width,depth,height,curve=6,wall=1.6,base=1,variance=0.2) {
    diff = wall * 2;
    round_edge_box_std(width,depth,height,curve,wall,base,variance);
    translate([0,0,-base]) 
        round_edge_block(width-diff,depth-diff,base,curve);
}

/*
* Engrave Text on Container Surface
*/
module engrave_text(text,x,y,size=33, font=label_font) {
    translate([x,y,0]) rotate([180,180,0])
        linear_extrude(1.8)
            text(
                text, size=size, font=font, 
                spacing = label_spacing, valign="center", halign="center"
            );
}

module main() {
    difference() {
        if (stackable == 0) {
            round_edge_box_std(
                block_width,block_depth,block_height,corner_curve,
                wall=block_wall_thickness,base=stack_base_height,
                variance=join_variance
            );
        } else if (stackable == 1) {
            round_edge_box_stackable_with_support(
                block_width,block_depth,block_height,corner_curve,
                wall=block_wall_thickness,base=stack_base_height,
                variance=join_variance
            );
        } else {
            round_edge_box_stackable(
                block_width,block_depth,block_height,corner_curve,
                wall=block_wall_thickness,base=stack_base_height,
                variance=join_variance
            );
        }
        if (label_text && block_height > 10) 
            render_text();
    }
    // Render separator
    if ( separator_thickness > 0 ) {
        for ( s = separators ) {
            c = len(s);
            location = c > 1 ? s[1] : 50;
            from = c > 2 ? s[2] : 0;
            to = c > 3 ? s[3] : 100;
            height = c > 4 ? s[4] : 100;
            render_separator(
                s[0], location, from, to, height
            );
        }
    }
}
