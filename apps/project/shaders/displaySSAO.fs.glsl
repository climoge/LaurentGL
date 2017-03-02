#version 330

uniform sampler2D uGSSAOSampler;

out vec3 fColor;

void main()
{
	fColor = vec3(texelFetch(uGSSAOSampler, ivec2(gl_FragCoord.xy), 0)) ;
    //float color = texelFetch(uGSSAOSampler, ivec2(gl_FragCoord.xy), 0);
    //fColor = vec3(color);
}