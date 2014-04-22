import de.voidplus.leapmotion.*;
import development.*;

LeapMotion leap;

BufferedReader reader;
boolean clicked = false;
String line;
String filename;
ArrayList<Stuff> stuffs;
float x, y, z;
boolean chosen;
int countdown;
int n = 50;
int[] randomIndices = new int[n];

void setup() {
  size(1048, 600, P3D);
  background(0);
  PFont ubuntu;
  textSize(30);

  stuffs = new ArrayList<Stuff>();
  String[] lines = loadStrings("harpersIndex2014.csv");

  int yPointer = 1;
  float xPointer = 50; 

  for (int i = 0; i < lines.length; i++) {
      String[] pieces = split(lines[i], ",");
      String fact = pieces[0];
      String number = pieces[1];
      if (xPointer + textWidth(number) >= width - 100) {
        yPointer++;
        xPointer = 0;
      }
      stuffs.add(new Stuff(fact, number, xPointer, yPointer*40));
      xPointer += textWidth(number);
      xPointer += 50;
    }
  
  //leap = new LeapMotion(this).withGestures();
  x = 3 * width/4;
  y = height/2;
  shuffle();
}

void draw() { 
  background(0);
  color sph = color(255, 255, 255, 100);
  /*if (leap.getHands().size() != 0) {
    Hand hand = leap.getHands().get(0);
    PVector hand_position = hand.getPosition();
    float[] handPos = hand_position.array();
    x = map(handPos[0], 400, 700, -width/2, width/2); 
    y = map(handPos[1], 200, 500, -3*height, height);
    sph = color(255, 255, 255, 200);
  } 
  else {
    if (second() % 10 == 0) {
      //  shuffle();
    }
    // x = width/3;
    // y = height;
  }*/

  camera(x, y, (height/2)/ tan(PI/6), x, y, 0, 0, 1, 0);
  pushMatrix();
  translate(x, y);

  fill(sph);
  sphere(10);
  popMatrix();
  boolean once = true;

  for (int i = 0; i < n; i++) {
    int temp = randomIndices[i];
    stuffs.get(temp).mouseHover(width/2, height/2);
    stuffs.get(temp).display();
    if (stuffs.get(temp).mouseOver && once) {
      once =false;
      chosen = true;
      countdown = second();
      stuffs.get(temp).displayFact();
    }
  }
}

void shuffle() {
  for (int i = 0; i < n; i++) {
    randomIndices[i] = (int) random(0, stuffs.size());
  }
}

void mouseMoved() {
  x = 2.0 * mouseX;
  y = 2.0 * mouseY - height/2;
}

void mouseClicked() {
  shuffle();
}

void leapOnCircleGesture(CircleGesture g, int state) {
  switch(state) {
  case 1: // Start
    break;
  case 2: // Update
    break;
  case 3: // Stop
    shuffle();
    break;
  }
}


class Stuff {
  String fact;
  String number;
  color c;
  float size;
  float posx;
  float posy;
  float posz;
  float rScale;
  boolean mouseOver;

  Stuff(String s, String n, float px, float py) {
    fact = s;
    number = n;
    color g = color(0, 255, 0);
    color b = color(0, 255, 255);
    c = lerpColor(g, b, random(0.2, 1.0));
    posx = px;
    posy = py;
    rScale = random(0.05, 0.1);
    posz = 0;
    size = 30;
  }

  void display() {
    if (!this.mouseOver) {
      posz += rScale;
      fill(c);
    } 
    else {
      displayFact();
      fill(255);
    }
    pushMatrix();
    translate(posx, posy, 0);
    noStroke(); 
    textSize(20);
    //box(textWidth(number) + 10, 35, (cos(posz) + 1.0) * 50);
    noStroke();
    //fill(0);
    text(number, -textWidth(number)/2, 10, 
    (cos(posz) + 1.0) * 25 + 2);

    popMatrix();
  }

  void setColor(float r, float g, float b) {
    c = color(r, g, b);
  }

  void mouseHover(float mx, float my) {

    float px = screenX(posx - 5, posy - 5, posz);
    float py = screenY(posx - 5, posy - 5, posz);
    float pxx = screenX(posx + textWidth(number) + 5, posy + 5, posz);
    float pyy = screenY(posx + textWidth(number) + 5, posy + 35, posz);

    fill(200);
    if (mx >= px && mx <= pxx && my >= py && my <= pyy) {
      mouseOver = true;
    } 
    else {
      mouseOver = false;
    }
  }

  void displayFact() {
    float y = screenY(posx, posy, (cos(posz) + 1.0) * 50);
    pushMatrix();
    translate(posx, posy + 35, 90);
    noStroke();
    textSize(15);
    noStroke();
    color pane = color(0, 0, 0, 200);
    fill(pane);
    rect(-textWidth(number)/2 - 20, -5, width/3 + 10, 100);
    
    popMatrix();
    pushMatrix();
    translate(posx, posy + 35, 100);
    noStroke();
    lights();
    textSize(15);
    noStroke();
    fill(255);
    text(fact, -textWidth(number)/2 - 10, 0, width/3, 90);
    popMatrix();
  }
}

