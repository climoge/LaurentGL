#version 330 core
in vec2 TexCoords;
out vec3 fragColor;

uniform sampler2D ssaoInput;

void main() {
    vec2 texelSize = 1.0 / vec2(1280, 720);
    float result = 0.0;
    for (int x = -2; x < 2; ++x) 
    {
        for (int y = -2; y < 2; ++y) 
        {
            vec2 offset = vec2(float(x), float(y));
            result += texelFetch(ssaoInput, ivec2(gl_FragCoord.xy + offset.xy), 0).r;
        }
    }

	result /= (4.f * 4.f);

    fragColor = vec3(result, result, result);
}  