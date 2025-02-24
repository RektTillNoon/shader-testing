uniform float time;
uniform vec2 resolution;
varying vec2 vUv;

void main() {
  // Create a flowing effect using sine waves
    vec2 pos = vUv * 2.0 - 1.0;
    pos.x *= resolution.x / resolution.y;

    float r = length(pos) * 2.0;
    float a = atan(pos.y, pos.x);

  // Create multiple layers of waves
    float f = cos(a * 3.0);
    f += sin(a * 7.0);
    f += sin(a * 5.0 + time + r);

  // Add some color
    vec3 color = vec3(0.0);
    color += 0.5 + 0.5 * cos(time + vUv.xyx + vec3(0.0, 2.0, 4.0));

  // Mix with the wave pattern
    float pattern = 0.5 + 0.5 * sin(f * 3.0 - time * 2.0);
    color *= pattern;

  // Add glow effect
    color += 0.1 / (0.1 + r * r);

    gl_FragColor = vec4(color, 1.0);
}