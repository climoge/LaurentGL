#version 330

uniform sampler2D uGStencil;

out vec3 fColor;

void main()
{
    float stencil = texelFetch(uGStencil, ivec2(gl_FragCoord.xy), 0).r;
    fColor = vec3(pow(stencil, 10.f)); // Since the depth is between 0 and 1, pow it to darkness its value
}