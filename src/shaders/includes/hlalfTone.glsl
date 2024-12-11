vec3 halfTone( 
    vec3 color,
    vec3 normalDirection,
    vec3 pointColor,
    float highThreshold,
    float lowThreshold,
    float repetation,
    vec2 resolution,
    vec3 normal
    ){

    float intensity = dot(normal, normalDirection);
    intensity = smoothstep(lowThreshold, highThreshold, intensity);

    vec2 vuv = gl_FragCoord.xy/ resolution.y;
    vuv *= repetation;
    vuv = mod(vuv, 1.);
    float point = distance(vuv, vec2(.5));
    point = 1. - step(.5 * intensity, point);
    color = mix(color, pointColor, point);

    return color;
}