# HARMONICHROMIA - Clinical Geiger Counter
# Raw data sonification with clinical precision
# Data: Amazing Grace breath intensity [1,2,4,1,1,1,1,3,1,2,2]

# NoteDensity function: maps intensity to timing intervals
define :noteDensity do |value|
  # Higher values = faster beeping (shorter intervals)
  # Range: 1.0 seconds (low) to 0.2 seconds (high)
  return (1.2 - (value * 0.1)).abs
end

# Data array - harmonica breath intensity
data = [1, 2, 4, 1, 1, 1, 1, 3, 1, 2, 2]

puts "CLINICAL GEIGER: Starting sonification..."
puts "Data pattern: #{data}"

# Clinical sonification loop
live_loop :geiger_counter do
  
  # Cycle through data array
  data.each_with_index do |intensity, position|
    
    # Calculate timing based on intensity
    interval = noteDensity(intensity)
    
    # Clinical beep - pitch slightly varies with intensity
    use_synth :beep
    
    # Subtle reverb for clinical space ambience
    with_fx :reverb, room: 0.3, mix: 0.2 do
      
      # Higher intensity = higher pitch + more urgent
      note_pitch = 60 + (intensity * 2)
      amplitude = 0.3 + (intensity * 0.1)
      
      # ALERT: Peak detection at position 3 (value 4)
      if intensity >= 4
        # Critical alert pattern - rapid triple beep
        3.times do
          play note_pitch, amp: amplitude * 1.5, release: 0.1
          sleep 0.05
        end
        puts "ALERT: Peak intensity detected - Position #{position + 1}"
      else
        # Standard clinical beep
        play note_pitch, amp: amplitude, release: 0.2
      end
      
    end
    
    # Wait based on intensity (data drives timing)
    sleep interval
    
    puts "Position #{position + 1}: Intensity #{intensity}, Interval #{interval.round(2)}s"
  end
  
  # Brief pause before next cycle
  sleep 2
  puts "--- Cycle complete, restarting sonification ---"
end