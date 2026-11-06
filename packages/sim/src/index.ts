export interface FoundationState {
  schemaVersion: 1;
  simulationVersion: 'foundation-1';
  tick: number;
  modified: boolean;
}
export function createState(): FoundationState {
  return { schemaVersion: 1, simulationVersion: 'foundation-1', tick: 0, modified: false };
}
export function loadState(raw: string): FoundationState {
  const s: unknown = JSON.parse(raw);
  if (typeof s !== 'object' || s === null) throw new Error('Invalid save');
  const v = s as Record<string, unknown>;
  if (v.schemaVersion !== 1 || v.simulationVersion !== 'foundation-1' ||
      !Number.isSafeInteger(v.tick) || (v.tick as number) < 0 || typeof v.modified !== 'boolean') {
    throw new Error('Invalid or unsupported save');
  }
  return { schemaVersion: 1, simulationVersion: 'foundation-1', tick: v.tick as number, modified: v.modified };
}
export function inspect(state: FoundationState): Readonly<FoundationState> {
  return { ...state };
}
