/**
* Customisable Generic Tray
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
block_width = 200;
block_depth = 200;
block_height = 100;
block_wall_thickness = 3;

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
    round_edge_block(d=d, w1=w, h=h, mr=3.8, drain=false);
}

module main_block() {
    layer_height = 0.2;
    iter_count = ((block_wall_thickness / 3) * 2) / layer_height;
    w_increment = layer_height * (3/2); 
    
    
    translate(0,0,0)
        make_block(block_width, block_depth, block_height);
         
    for ( i = [0:iter_count] ) {
        translate([0,0,(i*layer_height*-1)])
            make_block(
                block_width-(i*0.3), 
                block_depth-(i*0.3), 
                3
            );
    }
    
    translate([0,0,(iter_count*layer_height*-1)-1])
        make_block(
            block_width-(block_wall_thickness*1.1), 
            block_depth-(block_wall_thickness*1.1), 
            5
        );
}


module main() {
    difference() {
        main_block();
        translate(0,0,-1.0)
            make_block(
                block_width-block_wall_thickness, 
                block_depth-block_wall_thickness, 
                block_height+2
            );
    }
}

main();

