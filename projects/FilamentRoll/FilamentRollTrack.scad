$fn = 100;

roller_width = 24;
rail_width = 40;
rail_height = 6;
rail_gap = 3;

bump_length = 15;
bump_width = 12;

gap1 = 62;
gap2 = 100;


length = gap1 + roller_width + ( 2 * rail_height );

difference() {
    cube([length, rail_width, rail_height]);
    
    translate([rail_gap, -1, 2])
        cube([roller_width, rail_width - bump_width, 200]);
    translate([length - roller_width - rail_gap, -1, 2])
        cube([roller_width, rail_width - bump_width, 200]);
  
    translate([rail_gap, -1, 2])
        cube([roller_width - bump_length, rail_width + 2, 200]);
    translate([length - roller_width - rail_gap + bump_length, -1, 2])
        cube([roller_width - bump_length, rail_width + 2, 200]);
        
    translate([(rail_gap * 2) + roller_width, -1, 2])
        cube([length - (roller_width * 2) - (rail_gap * 4), rail_width + 2, 200]);
 }
 
// translate([-1, rail_height, rail_height / 2])
//        cube([roller_width, 200, 200]);