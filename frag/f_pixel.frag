uniform float time;

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec2 xy = texture_coords;
    xy.xy -= mod(xy.xy, 0.0038);
    vec4 texcolor = Texel(tex, xy);
    return texcolor * color;
}