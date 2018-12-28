#shader vertex
#version 330 core

attribute vec2 vertex;
attribute vec2 uv;
attribute int textureID;

uniform mat4 world_matrix = mat4(1);

out DATA {
    vec2 uv;
    flat int textureID;
    vec4 color;
} vs_out;

void main() {
	vs_out.uv = uv;
	vs_out.textureID = textureID;
	vs_out.color = vec4(1);

	gl_Position = world_matrix * vec4(vertex, 0, 1);
}

#shader fragment
#version 400 core

uniform sampler2D textures[32];

out vec4 FragColor;

in DATA {
    vec2 uv;
    flat int textureID;
    vec4 color;
} fs_in;

void main() {
    int textureID = fs_in.textureID;

    if (textureID > 0) {
        FragColor = texture(textures[textureID - 1], fs_in.uv) * fs_in.color;
    } else {
        FragColor = fs_in.color;
    }
}