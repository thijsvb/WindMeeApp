PGraphics g;
g = createGraphics(512, 512);
g.beginDraw();
g.fill(32);
g.noStroke();
float u = 512/48;
g.rect(u,u,512-2*u,512-2*u,u*6);
g.stroke(255);
g.strokeWeight(u);
g.line(width/5, height-height/5, width-width/5, height/5);
g.line(width-width/5, height/5, width-2*width/5, height/5);
g.line(width-width/5, height/5, width-width/5, 2*height/5);
g.fill(255,128,0);
g.noStroke();
g.triangle(width-width/4, height/2, width/4, height/4, width/4, height-height/4);

g.endDraw();

size(512,512);
image(g,0,0);

g.save("../WindMee/icon-512.png");
PImage i = loadImage("../WindMee/icon-512.png");
i.resize(192,192);
i.save("../WindMee/icon-192.png");
i.resize(180,180);
i.save("../WindMee/icon-180.png");
i.resize(96,96);
i.save("../WindMee/icon-96.png");
i.resize(72,72);
i.save("../WindMee/icon-72.png");
i.resize(48,48);
i.save("../WindMee/icon-48.png");
i.resize(36,36);
i.save("../WindMee/icon-36.png");