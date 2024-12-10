uniform vec3 uColor;
uniform vec2 uResolution;
varying vec3 vNormal;
varying vec3 vPosition;

vec3 ambientLight(vec3 lightColor, float lightIntensity){
    return lightColor * lightIntensity;
}

vec3 directionalLight( 
    vec3 lightColor, float lightIntensity, vec3 normal, vec3 position, vec3 viewDirection, float specularPow){

    vec3 lightDirection = normalize(position);
    vec3 lightReflection = reflect(-lightDirection, normal );

    //shading
    float shading = dot(normal, lightDirection);
    shading = max( .0, shading);

    // specular
    float specular = - dot(lightReflection, viewDirection);
    specular = max( .0, specular);
    specular = pow( specular, specularPow);

    return lightColor * lightIntensity * shading + lightColor * lightIntensity * specular;
}

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


void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = uColor;

    // light
    vec3 light = vec3(.0);

    light += ambientLight(
        vec3(1.),
        1.
    );

    light += directionalLight(
        vec3(1.0),
        1.0,
        normal,
        vec3(1., 1., .0),
        viewDirection,
        1.
    );
    color *= light;

    // halftone
    color = halfTone(
        color,
        vec3(.0, -1., .0),
        vec3( 1., .0, .0),
        1.5,
        -.8,
        50.,
        uResolution,
        normal
    );

    // Final color
    gl_FragColor = vec4(color, 1.0);

    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}  