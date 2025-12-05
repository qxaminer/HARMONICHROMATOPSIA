# HARMONICHROMATOPSIA - OSC Receiver
# Receives harmonica data from Processing via OSC
# Put this in a buffer and run it first, then run your visualization program

# Global variable to store the incoming data
set :harmonica_data, [1, 2, 4, 1, 1, 1, 1, 3, 1, 2, 2] # Default data

# Track recording state
set :recording_active, false
set :data_ready, false

puts "="*50
puts "HARMONICHROMATOPSIA - OSC Receiver"
puts "="*50
puts "Listening for harmonica data from Processing..."
puts "Default data loaded: #{get(:harmonica_data)}"
puts ""
puts "OSC Messages:"
puts "  /harmonica/start    - Recording started"
puts "  /harmonica/sample   - Individual sample (index, intensity)"
puts "  /harmonica/complete - Complete array received"
puts "  /harmonica/reset    - Reset recording"
puts "="*50

# Listen for recording start
live_loop :osc_start do
  use_real_time
  
  message = sync "/osc*/harmonica/start"
  
  set :recording_active, true
  set :data_ready, false
  set :harmonica_data, [] # Clear existing data
  
  puts "\n🎙️  RECORDING STARTED"
  puts "Waiting for samples..."
end

# Listen for individual samples (real-time feedback)
live_loop :osc_samples do
  use_real_time
  
  message = sync "/osc*/harmonica/sample"
  
  if get(:recording_active)
    index = message[0]
    intensity = message[1]
    
    puts "Sample #{index + 1}: intensity = #{intensity}"
    
    # Optional: trigger a sound for real-time feedback
    use_synth :beep
    play 60 + (intensity * 2), amp: 0.2, release: 0.1
  end
end

# Listen for complete array
live_loop :osc_complete do
  use_real_time
  
  message = sync "/osc*/harmonica/complete"
  
  # Extract all intensity values from the OSC message
  # OSC message format: ["/harmonica/complete", val1, val2, val3, ...]
  new_data = message.drop(0) # Get all values after the address
  
  set :harmonica_data, new_data
  set :data_ready, true
  set :recording_active, false
  
  puts "\n" + "="*50
  puts "✅ COMPLETE ARRAY RECEIVED"
  puts "="*50
  puts "Data: #{new_data}"
  puts "Length: #{new_data.length} samples"
  puts "Range: #{new_data.min} to #{new_data.max}"
  puts "="*50
  puts "\n🎵 Data ready! Run your visualization program now."
  puts "   Or it will auto-update if already running."
  puts ""
  
  # Victory chime
  use_synth :pretty_bell
  play_pattern_timed [:c5, :e5, :g5, :c6], [0.1, 0.1, 0.1, 0.2], amp: 0.3
end

# Listen for reset
live_loop :osc_reset do
  use_real_time
  
  message = sync "/osc*/harmonica/reset"
  
  set :recording_active, false
  set :data_ready, false
  
  puts "\n🔄 RECORDING RESET"
  puts "Ready for new recording..."
end

# Status monitor
live_loop :status_monitor do
  sleep 30
  
  current_data = get(:harmonica_data)
  is_ready = get(:data_ready)
  
  puts "\n--- Status Check ---"
  puts "Current data: #{current_data}"
  puts "Data ready: #{is_ready}"
  puts "-------------------\n"
end

