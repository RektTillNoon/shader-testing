uniform float time;
uniform vec2 resolution;
uniform vec2 mousePosition;

varying vec2 vUv;

#define PI 3.14159265359

// Noise functions
vec2 hash2(vec2 p) {
  p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
  return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);

  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(dot(hash2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)), dot(hash2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x), mix(dot(hash2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)), dot(hash2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

// FBM (Fractal Brownian Motion)
float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 2.0;

  for(int i = 0; i < 6; i++) {
    value += amplitude * noise(p * frequency);
    amplitude *= 0.5;
    frequency *= 2.0;
  }

  return value;
}

void main() {
    // Normalize coordinates
  vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);

    // Create symmetry
  vec2 symmetryUv = vec2(abs(uv.x), uv.y);

    // Calculate distance from mouse position
  float distToMouse = length(uv - mousePosition);
  float mouseInfluence = smoothstep(0.5, 0.0, distToMouse);

    // Animate with mouse influence
  float t = time * 0.2;
  vec2 distortion = vec2(cos(t + mousePosition.x * PI) * 0.3, sin(t + mousePosition.y * PI) * 0.3);

    // Create base pattern with mouse influence
  float pattern = fbm(symmetryUv * 3.0 + distortion + vec2(t * 0.5, t * 0.3));
  pattern += fbm(symmetryUv * 2.0 - distortion - vec2(t * 0.4, t * 0.2));

    // Add swirling motion affected by mouse
  float angle = atan(uv.y - mousePosition.y, uv.x - mousePosition.x);
  float radius = length(uv);
  float swirl = fbm(vec2(radius * 4.0 + t + mouseInfluence, angle * 2.0));

    // Combine patterns
  float finalPattern = mix(pattern * 0.6 + swirl * 0.4, pattern * 0.8 + swirl * 0.2, mouseInfluence);

    // Color mapping with mouse influence
  vec3 baseColor = vec3(0.1, 0.2, 0.3);
  vec3 highlightColor = vec3(0.2, 0.4, 0.6);
  vec3 mouseColor = vec3(0.3, 0.5, 0.7);

  vec3 color = baseColor + mix(highlightColor, mouseColor, mouseInfluence) * finalPattern;

    // Add glow
  float glow = exp(-radius * 2.0);
  color += vec3(0.1, 0.2, 0.4) * glow;

    // Add mouse glow
  float mouseGlow = exp(-distToMouse * 3.0) * 0.5;
  color += vec3(0.2, 0.3, 0.5) * mouseGlow;

    // Fade edges
  float vignette = smoothstep(1.2, 0.5, radius);
  color *= vignette;

  gl_FragColor = vec4(color, 1.0);
}