# HARMONICHROMIA - Experimental Sculpture
# Sound as 3D spatial sculpture - Burke's dimensional concept
# Data: Amazing Grace breath intensity [1,2,4,1,1,1,1,3,1,2,2]

# NoteDensity function for temporal sculpture
define :noteDensity do |value|
  # Non-linear mapping for experimental timing
  return (0.8 + (value * value * 0.15))
end

# Spatial position mapping
define :intensityToPan do |value|
  # Map intensity to stereo position: low = left, high = right
  return -1.0 + ((value - 1) * 0.22)  # Range: -1.0 to +1.0
end

# Spectral mapping for frequency
define :intensityToFreq do |value|
  # Exponential frequency mapping for sculptural effect
  return 100 * (1.4 ** value)  # Exponential growth
end

# Harmonica breath intensity data
data = [1, 2, 4, 1, 1, 1, 1, 3, 1, 2, 2]

puts "EXPERIMENTAL SCULPTURE: Constructing 3D sonic architecture..."
puts "Spatial map: #{data.map { |v| intensityToPan(v).round(2) }}"

# Primary sculptural layer - granular texture
live_loop :sculpture_texture do
  
  data.each_with_index do |intensity, position|
    
    pan_position = intensityToPan(intensity)
    frequency = intensityToFreq(intensity)
    duration = noteDensity(intensity)
    
    # Multi-layered spatial reverb
    with_fx :reverb, 
            room: 0.9 + (intensity * 0.01),
            mix: 0.7,
            damp: 0.3 do
      
      # Layer 1: Granular texture
      use_synth :gnoise
      play :c2, 
           amp: 0.1 + (intensity * 0.02),
           release: duration * 3,
           pan: pan_position,
           cutoff: 40 + (intensity * 8)
      
      # Layer 2: Harmonic resonance
      use_synth :hollow
      play_pattern_timed [frequency, frequency * 1.5], [0.1, 0.1],
                         amp: 0.05 + (intensity * 0.01),
                         release: duration * 2,
                         pan: pan_position * 0.7
      
    end
    
    sleep duration * 0.5
    puts "Sculpture point #{position + 1}: Pan #{pan_position.round(2)}, Freq #{frequency.round(1)}Hz"
  end
  
  sleep 4
end

# Secondary layer - crystalline structures
live_loop :crystal_structures do
  
  with_fx :reverb, room: 1.0, mix: 0.8 do
    with_fx :echo, phase: 1.5, mix: 0.3 do
      
      data.each_with_index do |intensity, position|
        
        # Skip lower intensities for sparse crystalline effect
        if intensity >= 2
          
          use_synth :pretty_bell
          
          # Harmonic series based on intensity
          harmonics = [1, 2, 3, 5].map { |h| 200 + (intensity * intensity * h) }
          
          harmonics.each_with_index do |freq, h_index|
            play_pattern_timed [freq], [0.05],
                               amp: (0.08 / (h_index + 1)) * intensity,
                               release: 2.0 + (intensity * 0.5),
                               pan: intensityToPan(intensity) * (h_index * 0.3)
            sleep 0.1
          end
          
          puts "Crystal formation: Position #{position + 1}, Harmonics: #{harmonics.map(&:round)}"
        end
        
        sleep noteDensity(intensity) * 0.8
      end
      
    end
  end
  
  sleep 6
end

# Tertiary layer - atmospheric pressure
live_loop :atmospheric_pressure do
  
  # Create pressure waves based on data contour
  data.each_cons(3) do |triplet|
    avg_intensity = triplet.sum / 3.0
    
    with_fx :reverb, room: 0.95, mix: 0.9 do
      with_fx :lpf, cutoff: 60 + (avg_intensity * 10) do
        
        use_synth :dark_ambience
        
        # Long atmospheric tones
        play 30 + avg_intensity,
             amp: 0.15 + (avg_intensity * 0.01),
             release: 8.0,
             attack: 2.0,
             pan: (avg_intensity - 2.5) * 0.4  # Center around mid-range
        
      end
    end
    
    sleep 3.0
  end
  
  sleep 8
  puts "--- Atmospheric cycle complete ---"
end

# Quaternary layer - peak event sculpture
live_loop :peak_events do
  
  data.each_with_index do |intensity, position|
    
    # Sculptural events only for significant peaks
    if intensity >= 3
      
      puts "🎭 SCULPTURAL EVENT: Peak #{intensity} at position #{position + 1}"
      
      with_fx :reverb, room: 1.0, mix: 0.9 do
        with_fx :echo, phase: 2.0, mix: 0.5, decay: 8 do
          
          # Multi-timbral explosion for peaks
          [[:sine, 0.8], [:saw, 0.4], [:pulse, 0.3]].each do |synth_type, amp_mult|
            
            use_synth synth_type
            
            # Ascending cascade
            5.times do |cascade|
              note_freq = 60 + (intensity * 4) + (cascade * 2)
              
              play note_freq,
                   amp: (0.1 * amp_mult) / (cascade + 1),
                   release: 3.0 + (intensity * 0.5),
                   pan: intensityToPan(intensity) + (cascade * 0.1)
              
              sleep 0.15
            end
          end
          
        end
      end
      
      sleep 2.0
    else
      sleep noteDensity(intensity)
    end
  end
  
  sleep 10
  puts "--- Peak event cycle complete ---"
end