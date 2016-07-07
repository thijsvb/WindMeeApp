import ketai.sensors.*;
KetaiLocation location;
KetaiSensor sensor;

JSONObject weather;
JSONObject wind;
float windDeg, windSpe;
double lat, lon;
float dir;
String OPMkey = "secret";
PShape rose;

void setup() {
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
  fullScreen();
  fill(255);
  stroke(255);
  strokeWeight(3);

  while (location.getProvider() == "none") {
    background(0);
    text("Waiting\nfor\nlocation", width/2, height/2);
  }
  updateWeather();
}

void draw() {
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
  text(windSpe + " m/s\n\nBeaufort:\n" + Beaufort(windSpe), 0, 3*height/8);
}

void onOrientationEvent(float x, float y, float z, long time, int accuracy) {
  dir = x;
}

void updateWeather() {
  lat = location.getLocation().getLatitude();
  lon = location.getLocation().getLongitude();
  weather = loadJSONObject("http://api.openweathermap.org/data/2.5/weather?lat="+ lat + "&lon=" + lon + "&appid=" + OPMkey);
  wind = weather.getJSONObject("wind");
  windDeg = wind.getFloat("deg") + 180; //We want the direction the wind is going in, not where it's coming from
  windSpe = wind.getFloat("speed");
}

float degBetween(float a, float b) {
  return abs(min( (a-b+360)%360, (b-a+360)%360));  //did this in a separate function for thinking purposes
}

int Beaufort(float speed) {
  if (speed < 0.3) {
    return 0;
  } else if (speed < 1.5) {
    return 1;
  } else if (speed < 3.4) {
    return 2;
  } else if (speed < 5.5) {
    return 3;
  } else if (speed < 8.0) {
    return 4;
  } else if (speed < 10.8) {
    return 5;
  } else if (speed < 13.9) {
    return 6;
  } else if (speed < 17.2) {
    return 7;
  } else if (speed < 20.8) {
    return 8;
  } else if (speed < 24.5) {
    return 9;
  } else if (speed < 28.5) {
    return 10;
  } else if (speed < 32.7) {
    return 11;
  } else {
    return 12;
  }
}