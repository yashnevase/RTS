import { mapSize, type Camera } from './index.ts';

export function homeCamera(width: number, height: number): Camera {
  const zoom = Math.min(width / mapSize.width, height / mapSize.height) * 0.94;
  return { x: (width - mapSize.width * zoom) / 2, y: (height - mapSize.height * zoom) / 2, zoom };
}

export function zoomAt(camera: Camera, x: number, y: number, factor: number, minimum: number): Camera {
  const zoom = Math.max(minimum, Math.min(minimum * 18, camera.zoom * factor));
  const ratio = zoom / camera.zoom;
  return { x: x - (x - camera.x) * ratio, y: y - (y - camera.y) * ratio, zoom };
}

export interface LabelRect { x: number; y: number; width: number; height: number; }

export function reserveLabel(candidate: LabelRect, placed: LabelRect[], width: number, height: number) {
  if (candidate.x < 0 || candidate.y < 0 || candidate.x + candidate.width > width ||
      candidate.y + candidate.height > height) return false;
  const overlaps = placed.some(other => candidate.x < other.x + other.width &&
    candidate.x + candidate.width > other.x && candidate.y < other.y + other.height &&
    candidate.y + candidate.height > other.y);
  if (overlaps) return false;
  placed.push(candidate);
  return true;
}
