/**
* Customisable Shaver Organiser
* Version 1.0 
*
* See "Customisable parameters" section below to custom the organiser to your needs
*
* Author: Joseph Lee
*         https://github.com/joelee
*         https://www.linkedin.com/in/joeworks
*/


/**
* Customisable parameters
*/

// Main block size
block_width = 150;
block_depth = 80;
block_height = 18;

ext_width = 1;

// Custom slots
// Available shapes:
//     "rect"  - Rectangle
//     "cyl"   - Cylinder, if width provided, a hull (oval like) shape
//     "redge" - Round Edge Rectangle, support 2 widths (width & width2)
// Location is relative to the centre of the main block
// If drain is set to true, it will render a drainage hole on the slot
slots = [ 
//                location
//  [Shape,   [    x,   y,  z], depth, width, width2, drain, extension_height ]
    ["cyl",   [   50,  -18,  0],    33,     0,      0,  true,  10],  // Frother Base
    ["cyl",   [   60, 20,  0],   9.5,     0,      0,  false,  5],  // Frother Tool 1
    ["cyl",   [   36, 20,  0],   9.5,     0,      0,  false,  5],  // Frother Tool 2
    ["cyl",   [    -38,  20,  0],   8.8,     0,      0,  false, 10],  // Thermometer
    ["cyl",   [    -60,  20,  0],   16,     0,      0,  false, 10],  // Tea Strainer
    
    ["rect",  [  12,  20,  0],    2.5,     7,      0,  false, 15],  // Stirrer
    ["rect",  [   -3,  20,  0],    11,    15,      0,  false, 8],   // Teabag grabber
    ["rect",  [  -20,  20,  0],     4,     9,      0,  false, 8],   // Sissors
    
    ["cyl",   [  6, -15,  0],    38,     0,      0,  true,  30], // Cutlery 
    
    ["rect",  [  -45,  -15,  0],    45,    38,      0,  true, 30]  // Misc Box
];


/**
* End of Customisable parameters
*
* You shouldn't need to modify anything pass here...
*/



$fn = 360;

// Render Drainage hole
module drain_block(diag) {
    diag2 = diag*2;
    z = block_height + 20;
    translate([0, 0, 1])
        difference() {
            translate([0, 0, diag])
                sphere(d=diag2);
            translate([-diag, -diag, 2]) {
                cube([diag2+2, diag2+2, z]);
            }
        }
    translate([0, 0, -53])
        cylinder(h=z, d=2);
}


// Cylinder block
module cyl_block(diag, drain=false, h=50) {
    translate([0, 0, 2])
        cylinder(h=h, d=diag);
    if (drain) drain_block(diag);
}


// Hull block - Oval like shape
module hull_block(w, d, drain=false, h=50) {
    diag = min(w, d);
    width = max(max(w, d) - diag, 0);
    rotate = w<d ? 0 : 90;
    translate([-width/2, 0, 2]) rotate([0, 0, rotate])
        hull() {
            translate([width,0,0]) cylinder(h=h, d=diag);
            cylinder(h=h, d=diag);
        }
    if (drain) drain_block(diag);
}


// Rectangle block
module rect_block(w, d, drain=false, h=50) {
    translate([0, 0, h/2+2])
        cube([w, d, h], center=true);
    if (drain) drain_block(min(w, d));
}


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


// Render the main block
module main_block(w, d, h) {
    round_edge_block(d=d, w1=w, h=h, mr=5, drain=false);
}


module render_slot(shape, d, w1, w2, drain=false, h=50) {
    if (shape == "rect") {
        rect_block(d, w1, drain=drain, h=h);
    } else if (shape == "cyl") {
        if (w1 > 0) {
            hull_block(d, w1, drain=drain, h=h);
        } else {
            cyl_block(d, drain=drain, h=h);
        }
    } else if (shape == "redge") {  // Round edge
        round_edge_block(d=d, w1=w1, w2=w2, drain=drain, h=h);
    }
}


module main() {
    difference() {
        // Render the main block
        union() {
            main_block(block_width, block_depth, block_height);
            for (s = slots) {
                ext = s[6];
                a = ext_width * 2;
                if (ext > 0) {
                    d = s[2] + a;
                    w1 = s[3] > 0 ? s[3] + a : 0;
                    w2 = s[4] > 0 ? s[4] + a : 0;
                    translate(s[1]) render_slot(shape=s[0], d=d, w1=w1, w2=w2, h=ext+block_height);
                }
            }
        }
        
        // Render the holes
        for (s = slots) {
            translate(s[1]) render_slot(shape=s[0], d=s[2], w1=s[3], w2=s[4], drain=s[5]);
        }
    }
}

main();
