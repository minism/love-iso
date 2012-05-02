extern vec2 source;

vec4 effect(vec4 global_color, sampler2D texture, vec2 texcoord, vec2 pixcoord)
{
    vec4 color = texture2D(texture, texcoord);
    float dx = abs(pixcoord.x - source.x);
    float dy = abs(pixcoord.y - source.y);
    float distance = sqrt(dx * dx + dy * dy);
    float brightness = 0.3 + 0.7 / log(distance/10);
    if (brightness > 1) 
    {
        brightness = 1 ;
    }
    color *= vec4(brightness, brightness, brightness, color.a);
    return color * global_color;
}

