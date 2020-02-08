// this is a black and white shader for plumino2
// mostly to see if it works
// (it does)
// by rin 2020

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 texcolor = Texel(tex, texture_coords);
    float h = (texcolor.x + texcolor.y + texcolor.z) / 3.0f;
    texcolor.xyz = vec3(h);
    return texcolor * color;
}