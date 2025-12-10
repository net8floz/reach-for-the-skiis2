draw_clear_alpha(c_white, 0);

draw_set_alpha(0.2);
var grid_size = 16;
var color1 = c_white;
var color2 = c_gray;


var vx = camera_get_view_x(view_camera[0]);
var vy = camera_get_view_y(view_camera[0]);
var vw = camera_get_view_width(view_camera[0]);
var vh = camera_get_view_height(view_camera[0]);


var start_x = floor(vx / grid_size) * grid_size;
var start_y = floor(vy / grid_size) * grid_size;
var end_x = vx + vw + grid_size;
var end_y = vy + vh + grid_size;


for (var gx = start_x; gx < end_x; gx += grid_size) {
    for (var gy = start_y; gy < end_y; gy += grid_size) {

        var col = ((gx / grid_size) + (gy / grid_size)) mod 2 == 0 ? color1 : color2;
        draw_set_color(col);
        draw_rectangle(gx, gy, gx + grid_size, gy + grid_size, false);
    }
}
draw_set_alpha(1);
