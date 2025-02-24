import { useRef } from 'react';
import { Canvas, useFrame, extend, useThree } from '@react-three/fiber';
import { shaderMaterial, OrthographicCamera } from '@react-three/drei';
import * as THREE from 'three';
import type { VisualizerMaterialImpl } from '../types/shader.types';

// Import shaders
import vertexShader from '../shaders/visualizer/vertex.glsl';
import fragmentShader from '../shaders/visualizer/fragment.glsl';

// Custom shader material
const VisualizerMaterial = shaderMaterial(
  {
    time: 0,
    resolution: new THREE.Vector2(),
    mousePosition: new THREE.Vector2(),
  },
  vertexShader,
  fragmentShader
);

// Extend Three.js with our custom material
extend({ VisualizerMaterial });

function Scene() {
  const materialRef = useRef<VisualizerMaterialImpl>(null);
  const { viewport } = useThree();

  useFrame((state) => {
    if (materialRef.current?.uniforms) {
      materialRef.current.uniforms.time.value = state.clock.elapsedTime;
      materialRef.current.uniforms.resolution.value.set(
        state.size.width * viewport.dpr,
        state.size.height * viewport.dpr
      );
    }
  });

  return (
    <>
      <OrthographicCamera makeDefault position={[0, 0, 1]} zoom={1} near={0.1} far={1000} />
      <mesh scale={[viewport.width, viewport.height, 1]}>
        <planeGeometry />
        <visualizerMaterial ref={materialRef} />
      </mesh>
    </>
  );
}

export default function ShaderVisual() {
  return (
    <Canvas>
      <Scene />
    </Canvas>
  );
}
