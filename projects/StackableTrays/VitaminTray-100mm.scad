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
*            Layer Height: 0.2mm (Change layer_height below to match your setting)
*              Perimeters: 3
*      Top & Bottom Layer: 3
*                  Infill: 20%
*
* Author: Joseph Lee
*         https://github.com/joelee
*         https://www.joeworks.com
*/

include <StackableTray.scad>


/**
* Customisable parameters
* [!] To be stackable the width, depth, corner_curve and wall thickness need to match.
*/

// Main block size
block_width = 100;
block_depth = 100;
block_height = 15;            // Set height to < 6 to make a lid.
block_wall_thickness = 1.6;
corner_curve = 3.8;  // 16.8;
stack_base_height = 0.6;
join_variance = 0.2; 

// Set to "" will disable text rendering.
label_text = "Vitamins";
label_size = 8;

/**
* separators
*/
separator_thickness = 1.5;    // Set to 0 to disable separators
separators = [
    ["d", 50, 0,  100],
    ["w", 50, 0,  100] 
];
stackable = 1;

main();
engrave_text("J", 23, -23);
engrave_text("Q", -23, -23);
engrave_text("H", 23, 23);
engrave_text("A", -23, 23);