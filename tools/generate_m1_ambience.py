"""Generate a small, seamless, deterministic wind bed for the M1 scene."""

from array import array
from math import cos, pi, sin, sqrt
from pathlib import Path
import random
import wave


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "assets" / "audio" / "plateau_evening_wind.wav"
SAMPLE_RATE = 22050
DURATION_SECONDS = 8
SAMPLE_COUNT = SAMPLE_RATE * DURATION_SECONDS


def periodic_low_pass(source: list[float], alpha: float) -> list[float]:
    """Filter periodic noise with the exact matching state at the loop seam."""
    decay = 1.0 - alpha
    state = 0.0
    weight = alpha
    for offset in range(1, min(len(source), 12000) + 1):
        state += weight * source[-offset]
        weight *= decay
    state /= 1.0 - decay**len(source)

    result: list[float] = []
    for sample in source:
        state = alpha * sample + decay * state
        result.append(state)
    return result


def main() -> None:
    rng = random.Random(417)
    raw = [rng.uniform(-1.0, 1.0) for _ in range(SAMPLE_COUNT)]
    low = periodic_low_pass(raw, 0.008)
    body = periodic_low_pass(raw, 0.032)
    air = periodic_low_pass(raw, 0.12)

    signal: list[float] = []
    for index in range(SAMPLE_COUNT):
        time = index / SAMPLE_RATE
        phase = time / DURATION_SECONDS
        gust = 0.62 + 0.20 * sin(2.0 * pi * 3.0 * phase + 0.8) + 0.12 * sin(2.0 * pi * 5.0 * phase + 1.4)
        texture = 0.72 * low[index] + 0.42 * body[index] + 0.16 * air[index]
        signal.append(texture * gust)

    rms = sqrt(sum(sample * sample for sample in signal) / SAMPLE_COUNT)
    gain = min(0.58 / max(abs(sample) for sample in signal), 0.20 / rms)
    pcm = array("h", (int(max(-1.0, min(1.0, sample * gain)) * 32767) for sample in signal))
    if pcm.itemsize != 2:
        raise RuntimeError("Expected 16-bit PCM samples")

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(OUTPUT), "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(SAMPLE_RATE)
        wav.writeframes(pcm.tobytes())
    print(f"Wrote {OUTPUT} ({SAMPLE_COUNT} samples, {SAMPLE_RATE} Hz)")


if __name__ == "__main__":
    main()
