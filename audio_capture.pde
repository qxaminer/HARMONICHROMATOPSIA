import processing.sound.*;

AudioIn input;
Amplitude amp;

ArrayList<Integer> intensityValues;
int totalSamples = 12;
float recordingDuration = 15.0; // seconds
float sampleInterval;
float lastSampleTime = 0;
boolean isRecording = false;
boolean recordingComplete = false;
float recordingStartTime;

void setup() {
  size(800, 600);
  
  // Initialize audio input
  input = new AudioIn(this, 0);
  input.start();
  
  // Create amplitude analyzer
  amp = new Amplitude(this);
  amp.input(input);
  
  // Initialize data collection
  intensityValues = new ArrayList<Integer>();
  sampleInterval = (recordingDuration * 1000) / totalSamples; // Convert to milliseconds
  
  println("HARMONICHROMATOPSIA - Audio Capture");
  println("Press SPACE to start recording");
  println("Will capture " + totalSamples + " samples over " + recordingDuration + " seconds");
}

void draw() {
  background(20);
  
  // Get current amplitude
  float volume = amp.analyze();
  
  // Visual feedback
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  
  if (!isRecording && !recordingComplete) {
    text("Press SPACE to start recording", width/2, height/2);
    text("Position harmonica near microphone", width/2, height/2 + 40);
  }
  else if (isRecording) {
    // Recording in progress
    fill(255, 0, 0);
    ellipse(50, 50, 30, 30); // Red recording dot
    
    fill(255);
    text("RECORDING...", width/2, height/2);
    
    float elapsed = (millis() - recordingStartTime) / 1000.0;
    float remaining = recordingDuration - elapsed;
    text("Time remaining: " + nf(remaining, 1, 1) + "s", width/2, height/2 + 40);
    
    // Show current amplitude
    int barHeight = (int)(volume * 300);
    fill(0, 255, 0);
    rect(width/2 - 25, height/2 + 100, 50, barHeight);
    
    // Collect samples
    if (millis() - lastSampleTime >= sampleInterval && intensityValues.size() < totalSamples) {
      int intensity = (int)map(volume, 0, 1, 1, 10);
      intensity = constrain(intensity, 1, 10);
      intensityValues.add(intensity);
      lastSampleTime = millis();
      
      println("Sample " + intensityValues.size() + ": " + intensity + " (raw: " + nf(volume, 1, 3) + ")");
    }
    
    // Check if recording is complete
    if (intensityValues.size() >= totalSamples || elapsed >= recordingDuration) {
      isRecording = false;
      recordingComplete = true;
      printFinalArray();
    }
  }
  else if (recordingComplete) {
    fill(0, 255, 0);
    text("RECORDING COMPLETE!", width/2, height/2);
    text("Check console for data array", width/2, height/2 + 40);
    text("Press 'R' to record again", width/2, height/2 + 80);
  }
  
  // Show sample count
  if (isRecording || recordingComplete) {
    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Samples collected: " + intensityValues.size() + "/" + totalSamples, 20, 20);
  }
}

void keyPressed() {
  if (key == ' ' && !isRecording && !recordingComplete) {
    startRecording();
  }
  else if (key == 'r' || key == 'R') {
    resetRecording();
  }
}

void startRecording() {
  isRecording = true;
  recordingComplete = false;
  recordingStartTime = millis();
  lastSampleTime = millis();
  intensityValues.clear();
  println("\n--- STARTING RECORDING ---");
}

void resetRecording() {
  isRecording = false;
  recordingComplete = false;
  intensityValues.clear();
  println("\n--- RESET FOR NEW RECORDING ---");
}

void printFinalArray() {
  println("\n=== FINAL INTENSITY ARRAY ===");
  print("[");
  for (int i = 0; i < intensityValues.size(); i++) {
    print(intensityValues.get(i));
    if (i < intensityValues.size() - 1) {
      print(", ");
    }
  }
  println("]");
  println("Array size: " + intensityValues.size());
  println("Ready for Processing visualization and Sonic Pi!");
  println("==============================\n");
}
