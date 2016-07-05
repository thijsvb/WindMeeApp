package processing.test.windmee;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ketai.sensors.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class WindMee extends PApplet {


KetaiLocation location;
KetaiSensor sensor;

JSONObject weather;
JSONObject wind;
float windDeg, windSpe;
double lat, lon;
float dir;
String OPMkey = "f28ba67a47127b85a62a8875060a4ff2";
PShape rose;

public void setup() {
  location = new KetaiLocation(this);
  sensor = new KetaiSensor(this);
  sensor.start();

  rose = createShape();
  rose.beginShape();
  rose.noStroke();
  rose.fill(64);
  for (float i=0; i!=16; ++i) {
    float r;
    if (i%2 == 1) {
      r = width/12;
    } else if (i%4 == 0) {
      r = width/3;
    } else {
      r = width/6;
    }
    float a = i * PI/8;
    rose.vertex(cos(a)*r, sin(a)*r);
  }
  rose.endShape();
  textAlign(CENTER, BOTTOM);
  textSize(width/20);

  orientation(PORTRAIT);
  
  fill(255);
  stroke(255);
  strokeWeight(3);

  while (location.getProvider() == "none") {
    background(0);
    text("Waiting\nfor\nlocation", width/2, height/2);
  }
  updateWeather();
}

public void draw() {
  background(0);
  translate(width/2, height/2);
  pushMatrix();
  rotate(-radians(dir));
  shape(rose);
  fill(64);
  text("N", 0, -width/3);


  rotate(radians(windDeg));
  stroke(128);
  for (float x=-height/2; x<=height/2; x+=2*height/9) {
    for (float y=-height/2; y<=height/2; y+=2*height/5) {
      line(x, y, x, y+height/5);
      line(x, y, x+height/50, y+height/50);
      line(x, y, x-height/50, y+height/50);
    }
  }
  for (float x=-height/2+height/9; x<=height/2; x+=2*height/9) {
    for (float y=-height/2+height/5; y<=height/2; y+=2*height/5) {
      line(x, y, x, y+height/5);
      line(x, y, x+height/50, y+height/50);
      line(x, y, x-height/50, y+height/50);
    }
  }

  popMatrix();

  noStroke();
  fill(lerpColor(color(0, 255, 0), color(255, 0, 0), degBetween(windDeg, dir)/180));
  triangle(0, -height/2+height/24, width/8, -height/2+height/5, -width/8, -height/2+height/5);

  fill(255);
  text(windSpe + " m/s\n\nWindkracht:\n" + Beaufort(windSpe), 0, 3*height/8);
}

public void onOrientationEvent(float x, float y, float z, long time, int accuracy) {
  dir = x;
}

public void updateWeather() {
  lat = location.getLocation().getLatitude();
  lon = location.getLocation().getLongitude();
  weather = loadJSONObject("http://api.openweathermap.org/data/2.5/weather?lat="+ lat + "&lon=" + lon + "&appid=" + OPMkey);
  wind = weather.getJSONObject("wind");
  windDeg = wind.getFloat("deg") + 180; //We want the direction the wind is going in, not where it's coming from
  windSpe = wind.getFloat("speed");
}

public float degBetween(float a, float b) {
  return abs(min( (a-b+360)%360, (b-a+360)%360));  //did this in a separate function for thinking purposes
}

public int Beaufort(float speed) {
  if (speed < 0.3f) {
    return 0;
  } else if (speed < 1.5f) {
    return 1;
  } else if (speed < 3.4f) {
    return 2;
  } else if (speed < 5.5f) {
    return 3;
  } else if (speed < 8.0f) {
    return 4;
  } else if (speed < 10.8f) {
    return 5;
  } else if (speed < 13.9f) {
    return 6;
  } else if (speed < 17.2f) {
    return 7;
  } else if (speed < 20.8f) {
    return 8;
  } else if (speed < 24.5f) {
    return 9;
  } else if (speed < 28.5f) {
    return 10;
  } else if (speed < 32.7f) {
    return 11;
  } else {
    return 12;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "WindMee" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
