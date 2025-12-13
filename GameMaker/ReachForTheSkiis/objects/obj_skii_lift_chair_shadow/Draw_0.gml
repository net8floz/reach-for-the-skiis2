if (live_call()) return live_result;
draw_set_color(c_black);

var _t = (chair.z - sprite_get_height(spr_skii_lift_south_entrance_a)) / (sprite_get_height(spr_liftpole_a) - sprite_get_height(spr_skii_lift_south_entrance_a));
var _size = lerp(3, 9, 1 - _t)
var _opacity = lerp(0.05, 0.3, 1 - _t);
draw_set_alpha(_opacity);
draw_circle(x, y + z, _size, false); 
draw_set_color(1); 
draw_set_alpha(1);