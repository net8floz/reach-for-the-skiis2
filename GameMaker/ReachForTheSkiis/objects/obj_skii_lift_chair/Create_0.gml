previous_point_index = -1;
next_point_index = -1;

spd = 2;
image_speed = 0;

system = noone;

passengers = [];
accepting_passengers = false;

z = 0;

shadow = instance_create_depth(x, y, depth, obj_skii_lift_chair_shadow);
shadow.chair = id;

on_screen = false;
last_x = x;
last_y = y;
last_z = z;
next_x = x;
next_y = y;
next_z = z;

visual_x = x;
visual_y = y;