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
block_width = 160;
block_depth = 80;
block_height = 15;


// Custom slots
// Available shapes:
//     "rect"  - Rectangle
//     "cyl"   - Cylinder, if width provided, a hull (oval like) shape
//     "redge" - Round Edge Rectangle, support 2 widths (width & width2)
// Location is relative to the centre of the main block
// If drain is set to true, it will render a drainage hole on the slot
slots = [
//                location
//  [Shape,   [    x,   y,  z], depth, width, width2, drain]
    ["cyl",   [   22,  18,  8],    40,     0,      0,  false],  // Krytox 1
    ["cyl",   [   -22,  18,  8],    40,     0,      0,  false],  // Krytox 2
    ["cyl",   [   -60,  -23,  0],    22,     0,      0,  false],  // Krytox 2
    
    ["rect",  [   61,  0,  5],    30,     66,      0,  false],  // pal 1
    ["rect",  [   -61,  15,  5],    30,     45,      0,  false],  // pal 2
    
    ["cyl",   [   38,  -3,  0],    5,     0,      0,  false],  // brush 1
    ["cyl",   [   -38,  -3,  0],    5,     0,      0,  false],  // brush 2
    ["cyl",   [   40,  -15,  0],    5,     0,      0,  false],  // brush 3
    ["cyl",   [   -40,  -15,  0],    5,     0,      0,  false],  // brush 4
    ["cyl",   [   42,  -28,  0],    5,     0,      0,  false],  // brush 3
    ["cyl",   [   -42,  -28,  0],    5,     0,      0,  false],  // brush 4
    
    ["rect",  [   25,  -23,  8],    20.6,     18.6,      0,  false],  // kpo 1
    ["rect",  [   -25,  -23,  8],    20.6,     18.6,      0,  false],  // kpo 2
    ["rect",  [   5,  -23,  0],    5,     15,      0,  false],  // kcp 1
    ["rect",  [   -5,  -23,  0],    5,     15,      0,  false],  // kcp 2
    
      ["rect",  [   0,  -8,  0],    11,     3.8,      0,  false],  // tw 1
    ["rect",  [   0,  -8,  0],    11,     3.8,      0,  false],  // tw 1
    ["rect",  [   13.8,  -8,  0],    11,     3.8,      0,  false],  // tw 2
    ["rect",  [   -13.8,  -8,  0],    11,     3.8,      0,  false],  // tw 2
    ["rect",  [   28,  -8,  0],    11,     3.8,      0,  false],  // tw 2
    ["rect",  [   -28,  -8,  0],    11,     3.8,      0,  false],  // tw 2
    
    
    
//    ["cyl",   [   55,  60,  0],    15,     0,      0,  true],  // Safety Shaver
//    ["cyl",   [   55, -20, 33],    38,     0,      0, false],  // Shaving Brush
//    ["rect",  [   55,  23, 33],    20,  34.5,      0,  true],  // Alum Block
//    ["cyl",   [   55, -60,  0],    38,     0,      0,  true],  // Precision Trimmer
//    ["cyl",   [ 13.8,  54,  0],    38,    33,      0,  true],  // Brio Beardscape
//    ["redge", [ 13.8,  18,  0],    28,    23,     27,  true],  // Philips OneBlade
//    ["cyl",   [ 13.8, -26,  0],    42,    38,      0,  true],  // Braun S9 Pro
//    ["rect",  [   20, -62,  0],    15,    20,      0,  true],  // Scissors
//    ["rect",  [    0, -62,  0],    10,    20,      0,  true],  // Cleaning Brush
//    ["redge", [-44.5,   0,  0],   156,  67.5,      0, false]   // Accessories/Attachments Box
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
module cyl_block(diag, drain=false) {
    translate([0, 0, 2])
        cylinder(h=50, d=diag);
    if (drain) drain_block(diag);
}


// Hull block - Oval like shape
module hull_block(w, d, drain=false) {
    diag = min(w, d);
    width = max(max(w, d) - diag, 0);
    rotate = w<d ? 0 : 90;
    translate([-width/2, 0, 2]) rotate([0, 0, rotate])
        hull() {
            translate([width,0,0]) cylinder(h=50, d=diag);
            cylinder(h=50, d=diag);
        }
    if (drain) drain_block(diag);
}


// Rectangle block
module rect_block(w, d, drain=false) {
    translate([0, 0, 27])
        cube([w, d, 50], center=true);
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


module render_slot(shape, d, w1, w2, drain=false) {
    if (shape == "rect") {
        rect_block(d, w1, drain=drain);
    } else if (shape == "cyl") {
        if (w1 > 0) {
            hull_block(d, w1, drain=drain);
        } else {
            cyl_block(d, drain=drain);
        }
    } else if (shape == "redge") {  // Round edge
        round_edge_block(d=d, w1=w1, w2=w2, drain=drain);
    }
}


module main() {
    difference() {
        // Render the main block
        main_block(block_width, block_depth, block_height);
        
        // Render the holes
        for (s = slots) {
            translate(s[1]) render_slot(shape=s[0], d=s[2], w1=s[3], w2=s[4], drain=s[5]);
        }
    }
}

main();
