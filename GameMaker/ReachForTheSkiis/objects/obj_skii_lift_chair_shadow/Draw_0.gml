if (live_call()) return live_result;
draw_set_color(c_black);

var _t = (chair.z - chair.entrance_height) / (chair.pole_height - chair.entrance_height);
var _size = lerp(3, 9, 1- _t)
draw_set_alpha(0.4);
draw_circle(x, y + z, _size, false); 
draw_set_color(1);
draw_set_alpha(1);