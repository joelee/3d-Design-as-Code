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

/**
* Customisable parameters
* [!] To be stackable the width, depth, corner_curve and wall thickness need to match.
*/

// Main block size
block_width = 150;
block_depth = 100;
block_height = 50;            // Set height to < 6 to make a lid.
block_wall_thickness = 3;
corner_curve = 9;  // 16.8;
stack_base_height = 1.5;

// Set to "" will disable text rendering.
label_text = "3D Printer Tools";      
label_size = 10;
label_font = "Marker Felt:style=bold";
label_spacing = 1.0;

/**
* separators
*/
separator_thickness = 1.5;    // Set to 0 to disable separators
separators = [
    // ["w", 33],
    ["w", 33],
    ["d", 50]
];

/**
* End of Customisable parameters
*
* You shouldn't need to modify anything pass here...
*/
layer_height = 0.2;
$fn = 360;

include <StackableTray.scad>

main();
