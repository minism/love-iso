vec4 effect(vec4 global_color, sampler2D texture, vec2 texcoord, vec2 pixcoord)
{
    vec4 color = texture2D(texture, texcoord);
    if (color.a > 0)
        color += vec4(0.1);
    return color;
}
