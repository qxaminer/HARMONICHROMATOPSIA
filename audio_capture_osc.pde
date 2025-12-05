// HARMONICHROMATOPSIA - Audio Capture with OSC Output
// Captures harmonica audio and sends data to Sonic Pi via OSC

import processing.sound.*;
import oscP5.*;
import netP5.*;

AudioIn input;
Amplitude amp;

OscP5 oscP5;
NetAddress sonicPi;

ArrayList<Integer> intensityValues;
int totalSamples = 12;
float recordingDuration = 15.0; // seconds
float sampleInterval;
float lastSampleTime = 0;
boolean isRecording = false;
boolean recordingComplete = false;
float recordingStartTime;

// OSC Configuration
int sonicPiPort = 4560; // Default Sonic Pi OSC receive port
String sonicPiIP = "127.0.0.1"; // localhost

void setup() {
  size(800, 600);
  
  // Initialize audio input
  input = new AudioIn(this, 0);
  input.start();
  
  // Create amplitude analyzer
  amp = new Amplitude(this);
  amp.input(input);
  
  // Initialize OSC
  oscP5 = new OscP5(this, 12000); // Processing listens on port 12000
  sonicPi = new NetAddress(sonicPiIP, sonicPiPort);
  
  // Initialize data collection
  intensityValues = new ArrayList<Integer>();
  sampleInterval = (recordingDuration * 1000) / totalSamples;
  
  println("HARMONICHROMATOPSIA - Audio Capture with OSC");
  println("Sending OSC to: " + sonicPiIP + ":" + sonicPiPort);
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
    
    // OSC status indicator
    fill(0, 255, 0);
    textSize(14);
    text("OSC Ready: " + sonicPiIP + ":" + sonicPiPort, width/2, height - 30);
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
    
    // Collect samples and send via OSC in real-time
    if (millis() - lastSampleTime >= sampleInterval && intensityValues.size() < totalSamples) {
      int intensity = (int)map(volume, 0, 1, 1, 10);
      intensity = constrain(intensity, 1, 10);
      intensityValues.add(intensity);
      lastSampleTime = millis();
      
      // Send individual sample via OSC
      sendOscSample(intensityValues.size() - 1, intensity);
      
      println("Sample " + intensityValues.size() + ": " + intensity + " (raw: " + nf(volume, 1, 3) + ") - SENT via OSC");
    }
    
    // Check if recording is complete
    if (intensityValues.size() >= totalSamples || elapsed >= recordingDuration) {
      isRecording = false;
      recordingComplete = true;
      sendCompleteArray();
      printFinalArray();
    }
  }
  else if (recordingComplete) {
    fill(0, 255, 0);
    text("RECORDING COMPLETE!", width/2, height/2);
    text("Data sent to Sonic Pi via OSC", width/2, height/2 + 40);
    text("Press 'R' to record again", width/2, height/2 + 80);
    
    // Show array preview
    textSize(16);
    text("Array: " + intensityValues.toString(), width/2, height/2 + 120);
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
  else if (key == 't' || key == 'T') {
    // Test: send a test array
    sendTestArray();
  }
}

void startRecording() {
  isRecording = true;
  recordingComplete = false;
  recordingStartTime = millis();
  lastSampleTime = millis();
  intensityValues.clear();
  
  // Send recording start signal
  OscMessage msg = new OscMessage("/harmonica/start");
  oscP5.send(msg, sonicPi);
  
  println("\n--- STARTING RECORDING ---");
  println("OSC message sent: /harmonica/start");
}

void resetRecording() {
  isRecording = false;
  recordingComplete = false;
  intensityValues.clear();
  
  // Send reset signal
  OscMessage msg = new OscMessage("/harmonica/reset");
  oscP5.send(msg, sonicPi);
  
  println("\n--- RESET FOR NEW RECORDING ---");
  println("OSC message sent: /harmonica/reset");
}

// Send individual sample as it's recorded
void sendOscSample(int index, int intensity) {
  OscMessage msg = new OscMessage("/harmonica/sample");
  msg.add(index);     // Sample position (0-11)
  msg.add(intensity); // Intensity value (1-10)
  oscP5.send(msg, sonicPi);
}

// Send complete array when recording finishes
void sendCompleteArray() {
  OscMessage msg = new OscMessage("/harmonica/complete");
  
  // Add each intensity value to the OSC message
  for (int i = 0; i < intensityValues.size(); i++) {
    msg.add(intensityValues.get(i));
  }
  
  oscP5.send(msg, sonicPi);
  
  println("\n=== OSC: COMPLETE ARRAY SENT ===");
  println("Message: /harmonica/complete");
  println("Values: " + intensityValues);
  println("===============================\n");
}

// Send test array (for debugging without recording)
void sendTestArray() {
  ArrayList<Integer> testData = new ArrayList<Integer>();
  int[] testValues = {1, 2, 4, 1, 1, 1, 1, 3, 1, 2, 2};
  
  OscMessage msg = new OscMessage("/harmonica/complete");
  for (int val : testValues) {
    testData.add(val);
    msg.add(val);
  }
  
  oscP5.send(msg, sonicPi);
  
  println("\n=== TEST ARRAY SENT ===");
  println("Message: /harmonica/complete");
  println("Values: " + testData);
  println("Press 'T' again to resend");
  println("======================\n");
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
  println("Ready for Sonic Pi visualization!");
  println("==============================\n");
}

