import * as THREE from 'three';
import { type ThreeElement } from '@react-three/fiber';
import { shaderMaterial } from '@react-three/drei';

export type VisualizerMaterialImpl = {
    uniforms: {
        time: { value: number };
        resolution: { value: THREE.Vector2 };
        mousePosition: { value: THREE.Vector2 };
    };
} & THREE.ShaderMaterial;

// We need to export this type to be used in the module declaration
export type VisualizerMaterialType = ReturnType<typeof shaderMaterial>;

declare module '@react-three/fiber' {
    interface ThreeElements {
        visualizerMaterial: ThreeElement<VisualizerMaterialType>;
    }
} 