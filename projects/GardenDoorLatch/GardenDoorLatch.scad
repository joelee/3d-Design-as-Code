$fn = 360;

deck_latch();


module cyn_latch_base() {
    difference() {
        union() {
            cylinder(h=150, d=20);
            translate([-10,0,0])
                cube([20,10,150]);
        }
        cylinder(h=152, d=10.2);
    }
}

module deck_latch() {
    
    polygon([
        [0,0],
        [100,
    ]);
    

}