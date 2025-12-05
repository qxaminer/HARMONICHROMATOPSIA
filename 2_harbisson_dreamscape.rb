# HARMONICHROMIA - Harbisson Dreamscape
# Neil Harbisson-inspired synaesthetic translation
# Data: Amazing Grace breath intensity [1,2,4,1,1,1,1,3,1,2,2]

# NoteDensity function for musical timing
define :noteDensity do |value|
  # Musical timing - higher values get longer note durations
  return 0.5 + (value * 0.3)
end

# Musical scale mapping (pentatonic for ethereal beauty)
define :intensityToNote do |value|
  # Map 1-10 to pentatonic scale starting from C4
  scale_notes = [60, 62, 65, 67, 70, 72, 74, 77, 79, 82] # C major pentatonic extended
  return scale_notes[value - 1] || 60
end

# Harmonica breath intensity data
data = [1, 2, 4, 1, 1, 1, 1, 3, 1, 2, 2]

puts "HARBISSON DREAMSCAPE: Synaesthetic translation beginning..."
puts "Data as melody: #{data.map { |v| intensityToNote(v) }}"

# Melodic interpretation with lush effects
live_loop :dreamscape_melody do
  
  # Deep spatial reverb for dreamlike quality
  with_fx :reverb, room: 0.8, mix: 0.6 do
    with_fx :echo, phase: 0.75, mix: 0.4, decay: 4 do
      
      data.each_with_index do |intensity, position|
        
        # Convert intensity to musical note
        note_value = intensityToNote(intensity)
        duration = noteDensity(intensity)
        
        # Use prophet synth for warm, analog feel
        use_synth :prophet
        
        # Peak at position 3 (value 4) - moment of beauty
        if intensity >= 4
          puts "✨ PEAK BEAUTY: Position #{position + 1} - Harmonic bloom"
          
          # Harmonic bloom - play chord based on the peak note
          chord_notes = [note_value, note_value + 4, note_value + 7] # Major triad
          
          chord_notes.each_with_index do |chord_note, i|
            play chord_note, 
                 amp: 0.6 - (i * 0.1), 
                 release: duration * 2,
                 cutoff: 90 + (intensity * 5),
                 attack: 0.1
            sleep 0.1
          end
          
        else
          # Single melodic note with expression
          play note_value,
               amp: 0.4 + (intensity * 0.05),
               release: duration,
               cutoff: 70 + (intensity * 3),
               attack: 0.05,
               sustain: duration * 0.3
        end
        
        sleep duration
        puts "Note #{position + 1}: #{note_value} (intensity #{intensity}) - #{duration.round(2)}s"
      end
      
    end
  end
  
  # Pause between phrases
  sleep 3
  puts "--- Melodic phrase complete ---"
end

# Ambient bass layer following the contour
live_loop :ambient_bass do
  
  with_fx :reverb, room: 0.9, mix: 0.8 do
    
    data.each do |intensity|
      use_synth :tb303
      
      # Bass note follows intensity contour
      bass_note = 36 + intensity  # Low bass register
      
      play bass_note,
           amp: 0.2 + (intensity * 0.02),
           release: 2.0,
           cutoff: 40 + (intensity * 2),
           res: 0.7,
           attack: 0.5
      
      sleep noteDensity(intensity) * 2  # Slower than melody
    end
    
    sleep 6  # Longer pause for bass
  end
end