/* 
  Battery box for Elecraft KX3 -- holds 12 NiMH AA cells for 16 volts
  Jeffrey B. Otterson N1KDO
  licensed as Creative Commons Share-Alike, see https://creativecommons.org/licenses/by-sa/4.0/
  box is designed for Keystone battery terminals:
    1x 5223 positive terminal (button)
    3x 5212 positive/negative (button and spring)
    1x 5201 negative terminal(spring)

  WARNING: The KX3 is rated for a max input voltage of 15 volts. 12 fully charged NiMH cells
  may damage your radio.  A voltage regulator or something as simple as two silicon diodes 
  in series to introduce a 1.4 volt drop.
  
*/
kx3_width = 93;
kx3_length = 189;
pack_thickness = 32;
wall_thickness = 1.5;
box_length = kx3_length + wall_thickness + wall_thickness;
box_width = kx3_width +  wall_thickness + wall_thickness;
aa_length = 50.5;
aa_diameter = 14.0;
aa_radius = aa_diameter / 2;

aa3_length = aa_length * 3;
aa4_width = aa_diameter * 4;
aa_spring_length = 6;
bat_ribs_thickness = 2;
batbox_end_wall_thickness = 3;

rib_height = pack_thickness - 15;
rib_1_offset = 20;
rib_2_offset = 77.5;

slot_width = 4;
slot_depth = 12;
slot_1_offset=11;
slot_2_offset=75;

left_rounded_slot_dia = 12;
left_rear_hole_offset = 55;
left_front_hole_offset = 27;
left_hole_depth=12;

power_hole_offset = 74;
power_hole_dia = 8;
power_hole_depth = 24;

right_front_rounded_slot_dia = 11;
right_front_rounded_slot_depth = 5;
right_front_rounded_slot_offset = 36;
right_rear_rounded_slot_dia = 15;
right_rear_rounded_slot_depth = 5;
right_rear_rounded_slot_offset = 58;

module ruler(length)
{
  difference()
  {
    cube( [1, length, 8 ] );
    for ( i = [1:length-1] )
    {
      translate( [0.05, i, 0] ) 1_mm();
      if (i % 5 == 0)
      {
        translate( [0.05, i, 0] ) 5_mm();
      }
      if (i % 10 == 0)
      {
        translate( [0.05, i, 0] ) 10_mm();
      }
    }
  }
}

module 1_mm() { cube( [1, 0.125, 3 ] ); }
module 5_mm() { cube( [5, 0.125, 5 ] ); }
module 10_mm() { cube( [10, 0.125, 7 ] ); }

module hole(dia){
  translate([0.5,0,0]){
    rotate([90,-90,90]){
      cylinder(h=wall_thickness+2,d=dia,center=true,$fn=64);
    }
  }
}

module rounded_slot(dia, depth) {
  translate([0.5,0,0])
  rotate([90,-90,90]) {
    hull() {
      difference(){
        cylinder(h=wall_thickness+2,d=dia,center=true,$fn=64);
        translate ([0,-dia/2,0]) {
         cube([dia/2, dia, wall_thickness+2]);
        }
      } // subtract
      translate([0,-dia/2,-0.5]) {
         cube([depth+1,dia,wall_thickness]);
      } // translate
    } // hull
  } // rotate
}

module screw_slot() {
  rounded_slot(slot_width, slot_depth);
}

module box_end() {
  difference() {
    difference() {
      cube(size=[wall_thickness, box_width, pack_thickness]);
      translate([0, wall_thickness+slot_1_offset,pack_thickness-slot_depth+wall_thickness]) {
        screw_slot();
      }
    }
    translate([0, wall_thickness+slot_2_offset,pack_thickness-slot_depth+wall_thickness]) {
      screw_slot();
    }
  }
}

module left_box_end() {
    difference() {
      box_end();
      translate([0,left_front_hole_offset,pack_thickness-left_hole_depth]) {
        rounded_slot(left_rounded_slot_dia, left_hole_depth);
      }
      translate([0,left_rear_hole_offset,pack_thickness-left_hole_depth]) {
        rounded_slot(left_rounded_slot_dia, left_hole_depth);
      }
      translate([0,power_hole_offset, pack_thickness-power_hole_depth]) {
        hole(power_hole_dia);
      }
    }
}

module right_box_end() {
  difference() {
    difference() {
      box_end();
      translate([0, right_rear_rounded_slot_offset, pack_thickness - right_rear_rounded_slot_depth]) {
        rounded_slot(right_rear_rounded_slot_dia, right_rear_rounded_slot_depth);
      }
    }
    translate([0, right_front_rounded_slot_offset, pack_thickness - right_front_rounded_slot_depth]) {
      rounded_slot(right_front_rounded_slot_dia, right_front_rounded_slot_depth);
    }
  }
}

module make_box() {
  union() {
    // bottom of the box
    cube(size=[box_length, box_width, wall_thickness]);
    // left end of box
    translate([0,0,wall_thickness]){
      left_box_end();
    }
    // right end of box
    translate([kx3_length + wall_thickness,0,wall_thickness]){
      right_box_end();
    }
    // back of box
    translate([wall_thickness,0,wall_thickness]){
      cube(size=[kx3_length, wall_thickness, pack_thickness]);
    }
    // front of box
    translate([wall_thickness,kx3_width+wall_thickness,wall_thickness]){
      cube(size=[kx3_length, wall_thickness, pack_thickness]);
    }
    // ribs in box
    translate([wall_thickness,rib_1_offset+wall_thickness,wall_thickness]){
      cube(size=[kx3_length, wall_thickness, rib_height]);
    }
    translate([wall_thickness,rib_2_offset+wall_thickness,wall_thickness]){
      cube(size=[kx3_length, wall_thickness, rib_height]);
    }
  }
}
module make_battery_ribs(cells) {
  w = cells * aa_diameter;
  difference() {
    cube ([bat_ribs_thickness, w, aa_diameter/2]);
    for (i = [1:cells]) {
      translate([-0.5, aa_diameter/2+(i-1)*aa_diameter,aa_diameter/2]) {
        rotate([90,-90,90]) {
          cylinder(h=bat_ribs_thickness + 1,d=aa_diameter);
        }
      }
    }
  }
}

module make_battery_single_terminal_slot() {
  // this is based on the center of the cell, translate to get to that location.
  term_center_z_offset = 5; // from data sheet
  term_bump_z_offset = 5.74;
  term_bump_height = 0.5 ;
  term_center_y_offset = 11.2 / 2; // from data sheet
  term_thickness = 0.2; // from data sheet
  term_slot_width = 11.3;
  term_slot_height = 12+01; // fixme!
  term_slot_lip_size = 2;
  term_slot_lip_width = term_slot_width - term_slot_lip_size*2;
  term_slot_lip_height = term_slot_height - term_slot_lip_size;
  term_slot_lip_depth = 0.5;
  term_slot_depth = 0.6;
  translate ([-term_slot_lip_depth,-term_slot_lip_width /2 ,-term_center_z_offset + term_slot_lip_size])
    cube ([term_slot_lip_depth,term_slot_lip_width,term_slot_lip_height]);
  difference() {
    translate ([-term_slot_lip_depth-term_slot_depth,-term_slot_width/2,-term_center_z_offset])
      cube ([term_slot_depth,term_slot_width,term_slot_height]);
    translate ([-term_slot_lip_depth - 0.1,
                ,0,term_bump_z_offset])
      rotate([0,-90,0])
        cylinder(h=term_bump_height,d=1.75, $fn=36);
  }
}

module make_battery_double_contact_slot() {
  contact_center_z_offset = 6.35;
  contact_width = 24.64;
  contact_center_y_offset = 5.5; // (contact_width - 14) / 2;
  contact_slot_width = 25;
  contact_slot_height = 13;
  contact_end_bumps_z_offset = 2.8;
  contact_slot_depth = 0.6;
  contact_slot_lip_size = 2;
  contact_slot_lip_depth = 0.5;
  contact_slot_lip_width = contact_slot_width - 2 * contact_slot_lip_size;
  contact_slot_lip_height =  contact_slot_height - contact_slot_lip_size;
  contact_bump_z_offset =  contact_center_z_offset + 2.79;
  contact_bump_y_offset = (contact_slot_width / 2);
  contact_bump_height = contact_slot_depth;
  contact_bump_diameter = 2.5;
  contact_edge_bump_z = 3.5;
  contact_edge_bump_z_offset = (contact_slot_height/2) -  (contact_edge_bump_z / 2);

  translate ([contact_slot_lip_depth*1, -contact_center_y_offset , aa_radius - contact_slot_height]) {
    union() {
      difference () {
        cube ([contact_slot_depth, contact_slot_width, contact_slot_height]);
        translate ([contact_slot_depth+0.1,contact_bump_y_offset,contact_bump_z_offset]) 
	       rotate([0,-90,0])
           cylinder(h=contact_bump_height,d=contact_bump_diameter, $fn=36);
      }
      translate ([-contact_slot_lip_depth, contact_slot_lip_size, contact_slot_lip_size])
        cube ([contact_slot_lip_depth, contact_slot_lip_width, contact_slot_lip_height]);
      translate ([-contact_slot_lip_depth, 0, contact_edge_bump_z_offset])
        cube ([contact_slot_lip_depth, contact_slot_width, contact_edge_bump_z]);
    }
  }
}
module make_battery_double_contact_slot_down() {
  contact_center_z_offset = 6.35;
  contact_width = 24.64;
  contact_center_y_offset = 5.5; // (contact_width - 14) / 2;
  contact_slot_width = 25;
  contact_slot_height = 13;
  contact_end_bumps_z_offset = 2.8;
  contact_slot_depth = 0.6;
  contact_slot_lip_size = 2;
  contact_slot_lip_depth = 0.5;
  contact_slot_lip_width = contact_slot_width - 2 * contact_slot_lip_size;
  contact_slot_lip_height =  contact_slot_height - contact_slot_lip_size;
  contact_bump_z_offset =  contact_center_z_offset - 2.79;
  contact_bump_y_offset = (contact_slot_width / 2);
  contact_bump_height = contact_slot_depth;
  contact_bump_diameter = 2.5;
  contact_edge_bump_z = 3.5;
  contact_edge_bump_z_offset = (contact_slot_height/2) - (contact_edge_bump_z / 2);

  translate ([contact_slot_lip_depth*1, -contact_center_y_offset , aa_radius - contact_slot_height]) {
    union() {
      difference () {
        cube ([contact_slot_depth, contact_slot_width, contact_slot_height]);
        translate ([contact_slot_depth+0.1,contact_bump_y_offset,contact_bump_z_offset]) 
	       rotate([0,-90,0])
           cylinder(h=contact_bump_height,d=contact_bump_diameter, $fn=36);
      }
      translate ([-contact_slot_lip_depth, contact_slot_lip_size, contact_slot_lip_size])
        cube ([contact_slot_lip_depth, contact_slot_lip_width, contact_slot_lip_height]);
      translate ([-contact_slot_lip_depth, 0, contact_edge_bump_z_offset])
        cube ([contact_slot_lip_depth, contact_slot_width, contact_edge_bump_z]);
    }
  }
}

module make_battery_box() {
  box_length_inside = aa3_length+aa_spring_length;
  box_length_outside = box_length_inside + batbox_end_wall_thickness + batbox_end_wall_thickness;
  cube([box_length_outside, wall_thickness, aa_diameter]);
  translate([0,wall_thickness,0])
    difference() {
      cube([batbox_end_wall_thickness, aa4_width, aa_diameter]);
      translate([batbox_end_wall_thickness,aa_diameter/2, aa_diameter/2])
        make_battery_single_terminal_slot();
      translate([batbox_end_wall_thickness,aa_diameter/2 + 3 * aa_diameter, aa_diameter/2])
        make_battery_single_terminal_slot();

      translate([batbox_end_wall_thickness+.01,aa_diameter/2 + 2 * aa_diameter, aa_diameter/2])
        rotate ([0, 0, 180])
          make_battery_double_contact_slot_down();

    }
  translate([box_length_inside + batbox_end_wall_thickness,wall_thickness,0])
    difference() { 
      cube([batbox_end_wall_thickness, aa4_width, aa_diameter]);
      translate([0,aa_diameter/2,aa_diameter/2])
        make_battery_double_contact_slot();
      translate([0,aa_diameter*3 - aa_diameter/2,aa_diameter/2])
        make_battery_double_contact_slot();
    }
  translate([0,aa4_width+wall_thickness,0]) 
    cube([box_length_outside, wall_thickness, aa_diameter]);
  // now add thin ribs to separate the cells
  for (i = [1:12])
    translate ([i*12+batbox_end_wall_thickness,wall_thickness,0])
      make_battery_ribs(4);
}

color ([.4,.4,.4, 1]) {
  make_box();
  translate([15,20+wall_thickness,wall_thickness])
    make_battery_box();
  *make_battery_single_terminal_slot();
  *make_battery_double_contact_slot();
}


//# translate( [-5, 0, 0-20] ) rotate( [00, 180, 0] ) ruler(50);