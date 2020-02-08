uniform float time;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    vec4 newpos = vertex_position;
    newpos.x += sin((time*5.0f))*25.0f;
    newpos.y += cos((time*5.0f))*25.0f;
    return transform_projection * newpos;
}