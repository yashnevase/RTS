export interface Camera { x: number; y: number; zoom: number; }

export const mapBounds = { west: 72, east: 82, south: 14.75, north: 22.5 } as const;
export const mapSize = {
  width: (mapBounds.east - mapBounds.west) * 160 * Math.cos(18.75 * Math.PI / 180),
  height: (mapBounds.north - mapBounds.south) * 160,
};

export interface Coordinate { latitude: number; longitude: number; }

export function project({ latitude, longitude }: Coordinate) {
  return {
    x: (longitude - mapBounds.west) / (mapBounds.east - mapBounds.west) * mapSize.width,
    y: (mapBounds.north - latitude) / (mapBounds.north - mapBounds.south) * mapSize.height,
  };
}

export function unproject(x: number, y: number): Coordinate {
  return {
    latitude: mapBounds.north - y / mapSize.height * (mapBounds.north - mapBounds.south),
    longitude: mapBounds.west + x / mapSize.width * (mapBounds.east - mapBounds.west),
  };
}
