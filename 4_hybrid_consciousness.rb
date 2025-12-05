# HARMONICHROMIA - Hybrid Consciousness (Simplified)
# Synthesis of clinical, synaesthetic, and sculptural approaches
# Data: Amazing Grace breath intensity [1,2,4,1,1,1,1,3,1,2,2]

# NoteDensity function with mode switching
define :noteDensity do |value, mode = :standard|
  case mode
  when :clinical
    return (1.2 - (value * 0.1)).abs
  when :melodic  
    return 0.5 + (value * 0.3)
  when :sculptural
    return 0.8 + (value * 0.15)
  else
    return 0.6 + (value * 0.2)
  end
end

# Mapping functions
define :intensityToNote do |value|
  scale_notes = [60, 62, 65, 67, 70, 72, 74, 77, 79, 82]
  return scale_notes[value - 1] || 60
end

define :intensityToPan do |value|
  return -1.0 + ((value - 1) * 0.22)
end

# Data array
data = [1, 2, 4, 1, 1, 1, 1, 3, 1, 2, 2]

puts "HYBRID CONSCIOUSNESS: Multi-dimensional sonification..."
puts "Data: #{data}"

# Main hybrid loop - cycles through all approaches
live_loop :hybrid_main do
  
  # Clinical phase
  puts "--- CLINICAL PHASE ---"
  data.each_with_index do |intensity, position|
    use_synth :beep
    
    if intensity >= 4
      # Critical alert
      3.times do
        play 72, amp: 0.4, release: 0.1
        sleep 0.05
      end
      puts "ALERT: Peak at position #{position + 1}"
    else
      play 60 + (intensity * 2), amp: 0.3, release: 0.2
    end
    
    sleep noteDensity(intensity, :clinical)
  end
  
  sleep 2
  
  # Melodic phase  
  puts "--- MELODIC PHASE ---"
  with_fx :reverb, room: 0.7, mix: 0.5 do
    data.each_with_index do |intensity, position|
      use_synth :prophet
      note_value = intensityToNote(intensity)
      duration = noteDensity(intensity, :melodic)
      
      if intensity >= 4
        # Harmonic bloom for peak
        chord = [note_value, note_value + 4, note_value + 7]
        chord.each_with_index do |chord_note, i|
          play chord_note, 
               amp: 0.5 - (i * 0.1), 
               release: duration * 2,
               pan: intensityToPan(intensity) * 0.5
          sleep 0.1
        end
        puts "Harmonic bloom at position #{position + 1}"
      else
        play note_value,
             amp: 0.3 + (intensity * 0.05),
             release: duration,
             pan: intensityToPan(intensity) * 0.6
      end
      
      sleep duration
    end
  end
  
  sleep 3
  
  # Sculptural phase
  puts "--- SCULPTURAL PHASE ---"
  with_fx :reverb, room: 0.9, mix: 0.8 do
    data.each_with_index do |intensity, position|
      
      # Granular layer
      use_synth :gnoise
      play :c2,
           amp: 0.1 + (intensity * 0.02),
           release: noteDensity(intensity, :sculptural) * 2,
           pan: intensityToPan(intensity),
           cutoff: 40 + (intensity * 8)
      
      # Bell layer for higher intensities
      if intensity >= 2
        use_synth :pretty_bell
        frequency = 200 + (intensity * intensity * 15)
        play frequency,
             amp: 0.06 * intensity,
             release: 2.0,
             pan: intensityToPan(intensity) * 0.8
        puts "Crystal at position #{position + 1}: #{frequency.round}Hz"
      end
      
      sleep noteDensity(intensity, :sculptural) * 0.8
    end
  end
  
  sleep 5
  puts "--- HYBRID CYCLE COMPLETE ---"
end