size(1024, 500);
background(0);
pushMatrix();
stroke(128);
translate(width/2, 0);
rotate(PI-PI/3);
for (float x=-width/2; x<=width; x+=2*width/13) {
  for (float y=-width; y<=width/2; y+=2*width/7) {
    line(x, y, x, y+width/7);
    line(x, y, x+20, y+20);
    line(x, y, x-20, y+20);
  }
}
for (float x=-width/2+width/13; x<=width; x+=2*width/13) {
  for (float y=-width+width/7; y<=width/2; y+=2*width/7) {
    line(x, y, x, y+width/7);
    line(x, y, x+20, y+20);
    line(x, y, x-20, y+20);
  }
}
popMatrix();
noStroke();
fill(128, 255, 0);
triangle(100, 200, 100, 300, 200, 250);
fill(255, 128, 0);
triangle(width-100, 200, width-100, 300, width-200, 250);
fill(255);
textSize(75);
textAlign(CENTER,CENTER);
text("Wind mee?",width/2,height/2);
save("feature.png");