vec3 directionalLight( 
    vec3 lightColor, 
    float intensity,
    vec3 normal,
    vec3 position,
    vec3 viewDirection,
    float specularPow
    ){

    vec3 lightDirection = normalize(position);
    vec3 lightReflection = reflect( -lightDirection, normal);

    //shading
    float shading = dot(normal, lightDirection);
    shading = max(.0, shading);

    //specular
    float specular = -dot(lightReflection, viewDirection);
    specular = max( .0, specular);
    specular = pow(specular, specularPow);
    
    return lightColor * intensity * shading + lightColor * intensity * specular;
}