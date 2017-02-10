float G=0.01;
int M=800;
int lineX, lineY;
boolean line=false;
Planet[] planets=new Planet[10];
int numPlanets=0;
float R;

void setup(){
  size(900,800);
  planets[numPlanets++]=new Planet(M, 400, 400, 0, 0,true);
}

void draw(){
  drawBackground();
  drawPlanets();
  makePlanet();
  doGravity();
}

void drawBackground(){
  background(255);
  fill(0);
  noStroke();
  text("Choose mass on right, click&drag to create planets. Any key to clear all planets. RMB to create a star", 100, 790);
  rect(800,0,100,800);
  fill(255, 0, 0);
  text(M,850,750);
  stroke(255, 0, 0);
  for(int i=1;i<8;i++){
    line(800,i*100,850,i*100);
    text(i*100,875,805-100*i);
  }
  if(line){
    stroke(0);
    line(lineX,lineY,mouseX,mouseY);
  }
}

class Planet{
  int m;
  float r, x, y, xvel, yvel;
  color c;
  boolean star;
  Planet(int im, float ix, float iy, float ixvel, float iyvel, boolean istar){
    m=im;
    x=ix;
    y=iy;
    xvel=ixvel;
    yvel=iyvel;
    c=color(random(255),random(255),random(255));
    star=istar;
    if(star){
      m=m*10;
      c=#F9FA00;
      xvel=0;
      yvel=0;
    }
    r=sqrt(m);
  }
  void display(){
    if(!star){
      x+=xvel;
      y+=yvel;
    }
    noStroke();
    fill(c);
    ellipse(x,y,r,r);
  }
}

void mousePressed(){
  if(mouseX>800){
    M=800-mouseY;
  }
  else{
    if(!line){
      lineX=mouseX;
      lineY=mouseY;
      if(numPlanets==planets.length){
        planets=(Planet[]) expand(planets);
      }
      planets[numPlanets]=new Planet(M, lineX, lineY, 0, 0, mouseButton==RIGHT);
    }
    line=!line;
  }
}

void drawPlanets(){
  for(int i=0;i<numPlanets;i++){
    planets[i].display();
  }
}

void makePlanet(){
  if(line && !mousePressed){
      planets[numPlanets].xvel=(mouseX-lineX)/20;
      planets[numPlanets].yvel=(mouseY-lineY)/20;
      numPlanets++;
      line=!line;
  }
}

void doGravity(){
  for(int i=0;i<numPlanets;i++){ //<>//
    if(planets[i].m!=0){
    for(int j=i+1;j<numPlanets;j++){
      if(planets[j].m!=0){
      R=pow((planets[i].x - planets[j].x),2)+pow((planets[i].y - planets[j].y),2);//R^2
      if(sqrt(R)<max(planets[i].r, planets[j].r)){//Colliding planets merge
        int k=j;
        int l=i;
        if(planets[i].m>=planets[j].m){
          k=i;
          l=j;
        }//k bigger, l smaller
        planets[k].xvel=(planets[k].m*planets[k].xvel+planets[l].m*planets[l].xvel)/(planets[k].m+planets[l].m);
        planets[k].yvel=(planets[k].m*planets[k].yvel+planets[l].m*planets[l].yvel)/(planets[k].m+planets[l].m);
        planets[k].m+=planets[l].m;
        planets[k].r=sqrt(planets[k].m);
        planets[l].m=0;
        planets[l].r=0;
        continue;
      }
      planets[i].xvel+=G*planets[j].m*(planets[j].x-planets[i].x)/R;
      planets[i].yvel+=G*planets[j].m*(planets[j].y-planets[i].y)/R;
      planets[j].xvel+=G*planets[i].m*(planets[i].x-planets[j].x)/R;
      planets[j].yvel+=G*planets[i].m*(planets[i].y-planets[j].y)/R;
    }}
  }}
}

void keyPressed(){
  planets=new Planet[10];
  numPlanets=0;
}