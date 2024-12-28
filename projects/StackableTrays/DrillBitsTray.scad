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
block_width = 160;
block_depth = 138;
// Set block_height to 2 to make a cover.
block_height = 50;            // Set height to < 6 to make a lid.
block_wall_thickness = 3;
corner_curve = 3.8;  // 16.8;
stack_base_height = 1.5;

label_text = "Drill bits";      // Set to "" will disable text rendering.
label_size = 12;
label_font = "Marker Felt:style=bold";
label_spacing = 1.0;

/**
* separators
*/
separator_thickness = 1.5;    // Set to 0 to disable separators
separators = [
    // 4 element array:
    //   1. "w" or "d" for Width or Depth
    //   2. Location offset (percentage: 0 to 100). 50 is in the centre.
    //   3. Starting offset (percentage). Default to 0.
    //   4. Ending offset (percentage). Default to 100. 
    // ["w", 50, 0, 75],
    // ["d", 25, 0, 50],
    // ["d", 75, 0, 100]
    // Above example will print:
    //            d            d
    //   |------------------------------| 0
    //   |        |            |        |
    // w |----------------------        | 50
    //   |                     |        |
    //   |------------------------------| 100
    //           25           75
    ["w", 25, 0, 100],
    ["w", 50, 0, 80],
    ["w", 75, 0, 80],
    ["d", 80, 25,100]
];

/**
* End of Customisable parameters
*
* You shouldn't need to modify anything pass here...
*/


$fn = 360;
layer_height = 0.2;

include <StackableTray.scad>
main();
