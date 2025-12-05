# HARMONICHROMATOPSIA

An audio-visual synesthesia project that captures harmonica performance data and translates it into multiple sonic visualizations inspired by different approaches to data sonification.

## Overview

This project consists of:
- **Processing sketch** for capturing harmonica audio intensity data
- **Sonic Pi programs** for sonifying the data in different aesthetic modes
- **OSC communication** for real-time data transfer between Processing and Sonic Pi

## Installation Requirements

### Processing
1. Install [Processing](https://processing.org/download)
2. Install required libraries via Processing IDE:
   - Go to **Sketch → Import Library → Add Library**
   - Install **Sound** library
   - Install **oscP5** library

### Sonic Pi
1. Install [Sonic Pi](https://sonic-pi.net/)
2. No additional setup required - OSC is built-in!

## Quick Start Guide

### Method 1: Live OSC Mode (Recommended)

1. **Start Sonic Pi** and open a new buffer

2. **Load the OSC receiver** in Buffer 0:
   ```ruby
   # Copy contents of 0_osc_receiver.rb
   ```
   Click **Run** - this will listen for incoming harmonica data

3. **Open Processing** and load `audio_capture_osc.pde`

4. **Run the Processing sketch**:
   - Position your harmonica near the microphone
   - Press **SPACE** to start recording
   - Play for 15 seconds
   - Data automatically sends to Sonic Pi via OSC

5. **Load a visualization** in Sonic Pi Buffer 1:
   - Choose one: `1_clinical_geiger_live.rb`, `2_harbisson_dreamscape_live.rb`, etc.
   - Click **Run** - it will automatically use the captured data

6. **Try different visualizations**:
   - Stop the current one with **Stop**
   - Load a different program
   - Click **Run** to hear a new interpretation

### Method 2: Manual Copy-Paste (Simple)

1. **Open Processing** and load `audio_capture.pde` (original version)

2. **Run the sketch**:
   - Press **SPACE** to record
   - After recording, check the console for the array output
   - Copy the array like: `[1, 2, 4, 1, 1, 1, 1, 3, 1, 2, 2]`

3. **Open Sonic Pi** and load any of the original programs:
   - `1_clinical_geiger.rb`
   - `2_harbisson_dreamscape.rb`
   - `3_experimental_sculpture.rb`
   - `4_hybrid_consciousness.rb`

4. **Replace the data array** on line 13 (or similar) with your captured data

5. **Click Run** to hear your performance sonified!

## Files Description

### Processing Sketches
- `audio_capture.pde` - Original version (console output only)
- `audio_capture_osc.pde` - OSC-enabled version (sends to Sonic Pi)

### Sonic Pi Programs

#### Receiver
- `0_osc_receiver.rb` - OSC receiver for live data (run this first)

#### Original (Manual Data)
- `1_clinical_geiger.rb` - Geiger counter-style beeping
- `2_harbisson_dreamscape.rb` - Melodic/harmonic interpretation
- `3_experimental_sculpture.rb` - 3D spatial sound sculpture
- `4_hybrid_consciousness.rb` - Combines all three approaches

#### Live (OSC-Enabled)
- `1_clinical_geiger_live.rb` - Clinical mode with live data
- `2_harbisson_dreamscape_live.rb` - Melodic mode with live data
- More live versions can be created following the same pattern

## Sonification Approaches

### 1. Clinical Geiger Counter
Raw data sonification with medical/scientific precision:
- Intensity → beep frequency and pitch
- High values trigger alert patterns
- Minimal processing, maximum clarity

### 2. Harbisson Dreamscape
Inspired by Neil Harbisson's synaesthetic art:
- Intensity → musical notes in pentatonic scale
- Lush reverb and echo effects
- Peaks create harmonic "blooms"
- Emotional and melodic interpretation

### 3. Experimental Sculpture
Sound as 3D spatial sculpture:
- Intensity → stereo position (low=left, high=right)
- Multiple layers (granular, crystalline, atmospheric)
- Exponential frequency mapping
- Immersive soundscape

### 4. Hybrid Consciousness
Cycles through all three approaches:
- Clinical → Melodic → Sculptural → repeat
- Shows the same data from different aesthetic perspectives
- Demonstrates the interpretive nature of sonification

## Technical Details

### Data Format
- **Samples**: 12 values
- **Range**: 1-10 (intensity levels)
- **Duration**: 15 seconds of recording
- **Update**: ~1.25 seconds per sample

### OSC Configuration
- **Processing sends to**: `127.0.0.1:4560` (Sonic Pi default)
- **Messages**:
  - `/harmonica/start` - Recording started
  - `/harmonica/sample` - Individual sample (index, intensity)
  - `/harmonica/complete` - Full array sent
  - `/harmonica/reset` - Recording reset

### Tips for Best Results

1. **Microphone placement**: Position harmonica 6-12 inches from mic
2. **Consistent breath**: Try to maintain steady breath pressure
3. **Dynamic range**: Mix soft and loud notes for interesting patterns
4. **Multiple takes**: Record several times to explore variations
5. **Experiment**: Try different harmonica techniques (bending, tongue blocking, etc.)

## Customization

### Change Recording Duration
In Processing (`audio_capture_osc.pde`):
```java
float recordingDuration = 15.0; // Change to desired seconds
int totalSamples = 12; // Change number of samples
```

### Change OSC Port
In Processing:
```java
int sonicPiPort = 4560; // Match Sonic Pi's OSC port
```

### Modify Intensity Mapping
In Processing, change the mapping function:
```java
int intensity = (int)map(volume, 0, 1, 1, 10);
```

## Troubleshooting

### No sound in Processing?
- Check system preferences → microphone permissions
- Try different microphone input (change `0` in `new AudioIn(this, 0)`)

### OSC not connecting?
- Verify Sonic Pi is running
- Check that port 4560 is not blocked by firewall
- Make sure `0_osc_receiver.rb` is running in Sonic Pi

### Data not updating in Sonic Pi?
- Stop and restart the visualization program
- Check the OSC receiver buffer is still running
- Press 'T' in Processing to send a test array

## Future Enhancements

- Real-time FFT analysis for pitch detection
- Multiple harmonica tracks/layers
- Visual representation in Processing
- MIDI output option
- Save/load recording sessions
- Web-based interface

## Credits

Created as an exploration of data sonification and audio-visual synesthesia, inspired by:
- Neil Harbisson's sonochromatic art
- Clinical data audification practices
- Experimental music and sound art

## License

Creative Commons - feel free to use, modify, and share!

---

*Play, record, visualize, and explore the sonic dimensions of breath and data.*

