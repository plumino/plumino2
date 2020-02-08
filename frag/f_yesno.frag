// f_admeme.frag

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 texcolor = Texel(tex, texture_coords);
    float h = (texcolor.x + texcolor.y + texcolor.z) / 3.0f;
    return (h > 0.30f) ? /* YES */ texcolor * color : /* NO */ vec4(0,0,0,0);
}