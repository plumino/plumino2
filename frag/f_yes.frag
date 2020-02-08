/**
 * f_yes.frag
 * file part of plumino^2
 * written by rin 2020
 */

uniform float time;

#define TIME_WOBBLE 2
#define INTENSITY 25
#define DIVIDER 50

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec2 xy = texture_coords;
    xy.x += sin((time*TIME_WOBBLE)+(xy.y*INTENSITY))/DIVIDER;
    vec4 texcolor = Texel(tex, xy);
    return texcolor * color;
}