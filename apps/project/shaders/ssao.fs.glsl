#version 330 core

in vec2 texCoords;

out vec3 fragColor;

uniform sampler2D gPosition;
uniform sampler2D gNormal;
uniform sampler2D texNoise;

uniform vec3 samples[64];
uniform mat4 projection;

const vec2 noiseScale = vec2(1, 1);

void main() {
	vec3 fragPos	= texelFetch(gPosition, ivec2(gl_FragCoord.xy), 0).xyz;
	vec3 normal		= texelFetch(gNormal, ivec2(gl_FragCoord.xy), 0).rgb;
	vec3 randomVec	= texelFetch(texNoise, ivec2(gl_FragCoord.xy * noiseScale), 0).xyz;

	vec3 tangent	= normalize(randomVec - normal * dot(randomVec, normal));
	vec3 bitangent	= cross(normal, tangent);
	mat3 TBN		= mat3(tangent, bitangent, normal);

	int kernelSize	= 64;
	float radius	= 0.5f;
	float bias		= 0.025f;

	float occlusion	= 0.f;

	for(int i = 0; i < kernelSize; ++i) {
		// get sample position
		vec3 sample = TBN * samples[i]; // transform from tangent to view space
		sample = fragPos + sample * radius;

		vec4 offset = vec4(sample, 1.0);
		offset		= projection * offset;
		offset.xy	/= offset.w;
		offset.xy	= offset.xy * 0.5f + 0.5f;

		float sampleDepth = texelFetch(gPosition, ivec2(gl_FragCoord.xy), 0).z;

		float rangeCheck = smoothstep(0.f, 1.f, radius / abs(fragPos.z - sampleDepth));

		occlusion += (sampleDepth >= sample.z + bias ? 1.f : 0.f) * rangeCheck;
	}

	occlusion = 1.f - (occlusion / kernelSize);
	fragColor = vec3(occlusion, occlusion, occlusion);
}