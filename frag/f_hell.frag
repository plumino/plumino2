vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 texcolor = Texel(tex, texture_coords);
    color.x *= 8;
    color.y /= 2;
    color.z /= 2;
    return texcolor * color;
}