/**
* Customisable Tea Organiser
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
block_width = 43;
block_depth = 98;
block_height = 40;


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
    ["rect",  [  10,  -22.6, 2],    18, 47.9,  0,  false], // Kanto Speakers
    ["rect",  [  -5,  -23.8, 10],    8, 42,  0,  false],    // Fan 
    ["rect",  [ -14.5,  -23.8, 2],    8, 42,  0,  false],   // RGB LED
    ["redge", [ 3,  25,  0], 33, 36, 43.8, false],      // LG C1 TV

//    ["rect",  [   15,  34.5, 15],   5, 13, 0,  false],    // USB Stick
//    ["rect",  [      1,  34.5, 15], 5, 13, 0,  false],  // USB Stick
//    ["rect",  [  -13.8,  34.5, 15], 5, 13, 0,  false],  // USB Stick
//    
//    ["rect",  [    0,  57.9, 12],    2.6, 25,  0,  false],  // SD Card 1
//    ["rect",  [   -8,  57.9, 16],    2.6, 25,  0,  false],  // SD Card 2
//    ["rect",  [  -16,  57.9, 20],    2.6, 25,  0,  false],  // SD Card 3
//    
//    ["rect",  [   19,  63.8, 20],    1.1, 11.3,  0,  false],  // MicroSD Card 1
//    ["rect",  [   13,  63.8, 22],    1.1, 11.3,  0,  false],  // MicroSD Card 2
//    ["rect",  [    7,  63.8, 24],    1.1, 11.3,  0,  false],  // MicroSD Card 3
//    ["rect",  [   19,  50,   20],    1.1, 11.3,  0,  false],  // MicroSD Card 4
//    ["rect",  [   13,  50,   22],    1.1, 11.3,  0,  false],  // MicroSD Card 5
//    ["rect",  [    7,  50,   24],     1.1, 11.3,  0,  false],  // MicroSD Card 6
];


/**
* End of Customisable parameters
*
* You shouldn't need to modify anything pass here...
*/



$fn = 188;

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
module rect_block(w, d, h=50, drain=false) {
    translate([0, 0, h/2])
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
                cube([w1, d, h], center=true);
            }
    } else {
        if (mr>0) {
            translate([-d/2, 0, 27])
                minkowski() {
                    hull() {
                        translate([d-(mr*2),0,0]) cube([1, w1-(mr*2), h], center=true);
                        cube([1, w2-(mr*2), h], center=true);
                    }
                    cylinder(r=mr,h=h);
                }
        } else {
            hull() {
                translate([d,0,0]) cube([1, w1, h], center=true);
                cube([1, w2, h], center=true);
            }
        }
    }
    if (drain) drain_block(min(w1, w2, d));
}


// Render the main block
module main_block(w, d, h) {
    round_edge_block(d=d, w1=w, h=h, mr=2, drain=false);
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
        
//        // Render Text
//        translate([-190, -79.9, 5.4]) rotate([90,0,0])
//            linear_extrude(3)
//                text("Joe Lee", size=12, font="Marker Felt:style=bold", spacing = 1.02);
        
        // Render the slots
        for (s = slots) {
            translate(s[1]) render_slot(shape=s[0], d=s[2], w1=s[3], w2=s[4], drain=s[5]);
        }
    }
}

// Render Text
        translate([-30, 36, 38]) rotate([0,0,270])
            linear_extrude(2.3)
                text("Joseph's Controllers", size=7, font="Marker Felt:style=bold", spacing = 1.00);

difference() {
    main();
    rotate([90,0,0]) translate([20,62,-50])
        cylinder(h=100, d=88);
}

difference() {
    union() {
        translate([-34.5,0,0])
            round_edge_block(d=81, w1=30, h=20);
        translate([-26,0,20])
            round_edge_block(d=81, w1=13.8, h=20);
    }
    translate([-35.4,0,5])
      rect_block(d=block_depth, w=32, h=29);
}  

//difference() {
//translate([-34.5,0,0])
//    round_edge_block(d=81, w1=30, h=40);
//translate([-35.4,0,5])
//    rect_block(d=block_depth, w=32, h=29);
//}

