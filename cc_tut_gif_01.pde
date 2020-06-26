int frameCounter;
int totalFrames = 300;
boolean recording = false;

float noiseScale = 0.01;
float circleX = 0;
float circleY = 0;
float radius;

void setup() {
  size(500, 700);
  radius = width/2 - 50;
}

void draw() {  
  float percent = 0;
  if (recording) {
    percent = float(frameCounter) / totalFrames;
  }
  else {
    percent = float(frameCounter % totalFrames) / totalFrames;
  }
  
  render(percent);
  
  if(recording) {
    saveFrame("output/gif-"+nf(frameCounter, 3)+".png");
    if (frameCounter == totalFrames-1) {
      exit();
    }
  }
  frameCounter++;
}

float getNoise(float angle) {
   float xoff = radius*cos(TWO_PI*angle);
   float yoff = radius*sin(TWO_PI*angle);
   return noise((width/2 + xoff) * noiseScale, (height*1/4+yoff) * noiseScale);
}

void render(float percent) {  
  // draw 2D noise
  loadPixels();
  for(int x = 0; x<width;x++){
    for(int y = 0; y<height;y++){
      float col = 255*noise(noiseScale*x,noiseScale*y);
      pixels[x + width*y] = color(col);
    }
  }
  updatePixels();


  // draw rotating circle
  fill(255);
  circleX = width/2 + radius*cos(TWO_PI*percent);
  circleY = width/2 + radius*sin(TWO_PI*percent);
  circle(circleX, circleY, 25);
   
 
  // clear bottom part of screen);
  translate(0, width);
  fill(0);
  rect(0, 0, width, height-width);

  // draw noise time line
  noFill();
  stroke(255);
  beginShape();
  for(int i = 0; i < width; i++) {
    float p = (float)i/width;
    
    float value = getNoise(p);
    float x = p*width;
    float y = map(value, -1, 1, 0, height-width);

    vertex(x, y);
  }
  endShape();
  
  
  // draw current noise value
  float value = getNoise(percent);
  float x = percent*width;
  float y = map(value, -1, 1, 0, height-width);
  noStroke();
  fill(255, 0, 0);
  circle(x, y, 15);
}
