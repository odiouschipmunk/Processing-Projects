ArrayList<Frog> army;
ArrayList<Mosquite> scourge;
ArrayList<Tree> forest;
float simW = 800;
float simH = 800;
int armySize = 6;
int scourgeSize = 20;
int forestSize = 45;
int msE = 0;
int sec = 0;
Tree t;

LineGraph armyPop;
LineGraph mosqPop;
LineGraph fruitPop;

void setup() {
  frameRate(30);
  size(1200, 800);

  army = new ArrayList<Frog>(armySize);
  scourge = new ArrayList<Mosquite>(scourgeSize);
  forest = new ArrayList<Tree>(forestSize);

  armyPop = new LineGraph(800, 0, 400, 266, "Frog Population Over Time", "Time(s)", "Population");
  mosqPop = new LineGraph(800, 266, 400, 266, "Mosquite Population Over Time", "Time(s)", "Population");
  fruitPop = new LineGraph(800, 532, 400, 266, "Fruit Population Over Time", "Time(s)", "Population");

  t = new Tree(random(55, simW-55), random(55, simH-55), random(0.5)+1, random(1)+0.3);
  for (int i = 0; i < armySize; i++) {
    Frog f = new Frog(random(simW-1)+1, random(simH-1)+1, random(255), random(255), random(255), random(1,4), randomGaussian()+10, constrain((float)randomGaussian()+1, 0.1, 1), (int)constrain(randomGaussian()*1000, 200, 1500));
    army.add(f);
  }
  for (int i = 0; i < scourgeSize; i++) {
    Mosquite m = new Mosquite(random(simW-1)+1, random(simH-1)+1, random(2.5), (int)constrain(randomGaussian()*800, 400, 1600), random(1)+0.4);
    scourge.add(m);
  }
  for (int i = 0; i < forestSize; i++) {
    Tree t = new Tree(random(55, simW-55), random(55, simH-55), random(0.5)+1, random(1)+0.3);
    forest.add(t);
  }
  sort(forest);
  
  armyPop.addPoint(new Point(0, army.size()));
  mosqPop.addPoint(new Point(0, scourge.size()));
  fruitPop.addPoint(new Point(0, numFruit(forest)));
}

void draw() {
  fill(120,255,120);
  rect(0,0,simW,simH);
  msE++;
  
  for (int i = 0; i < army.size(); i++) {

    if (army.get(i).getEnergy() <= 0){
      army.remove(i);
      continue;
    } else {
      for (int j = 0; j < army.size(); j++){
        if (j == i)
          continue;
        else {
 
        }
      }
    }
    for (int j = 0; j < scourge.size(); j++) {
      army.get(i).applyForce(scourge.get(j).attract(army.get(i)));
      if (army.get(i).canEat(scourge.get(j))) {
        army.get(i).setEnergy((int)army.get(i).getEnergy() + (int)scourge.get(j).getSize() * 5);
        scourge.remove(j);
      }
    }
    army.get(i).update();
    army.get(i).display();
  }

  for (int i = 0; i < scourge.size(); i++) {
    if (scourge.get(i).getEnergy() <= 0){
      scourge.remove(i);
      continue;
    }
    for (int j = 0; j < army.size(); j++)
      scourge.get(i).applyForce(army.get(j).repel(scourge.get(i)));
    
    for (int j = 0; j < forest.size(); j++) {
      t = forest.get(j);
      if (scourge.get(i).closestFruit(t) >= 0 && t.getBunch().size() > 0) {
        scourge.get(i).applyForce(t.getBunch().get(scourge.get(i).closestFruit(t)).attract(scourge.get(i)));
        if (scourge.get(i).canEat(t) >= 0) {
          t.removeFruit(scourge.get(i).canEat(t));
          scourge.get(i).setEnergy((int)scourge.get(i).getSize()*100);
        }  
      }
    }
    scourge.get(i).update();
    scourge.get(i).display();
  }
 
  for (int i = 0; i < forest.size(); i++) {
    forest.get(i).update();
    forest.get(i).display();
  }
  
  fill(255);
  noStroke();
  rectMode(CORNER);
  rect(simW,0,simW+400,height);

  if (msE % (int)frameRate == 0) {
    sec++;
    armyPop.addPoint(new Point(sec, army.size()));
    mosqPop.addPoint(new Point(sec, scourge.size()));
    fruitPop.addPoint(new Point(sec, numFruit(forest)));
  }
    armyPop.sketch(armyPop.co.size(), maxY(armyPop.co));
    mosqPop.sketch(mosqPop.co.size(), maxY(mosqPop.co));
    fruitPop.sketch(fruitPop.co.size(), maxY(fruitPop.co));
  
}

void sort(ArrayList<Tree> t) {
  int gaps[] = new int[]{701, 301, 132, 57, 23, 10, 4, 1};
  int n = t.size();
  for (int g = 0; g < gaps.length; g++) {

    for (int i = gaps[g]; i < n; i++) {
      Tree temp = t.get(i).copy(); 
      int j;

      for (j = i; j >= gaps[g] && t.get(j - gaps[g]).getLocation().y > temp.getLocation().y; j -= gaps[g])
        t.set(j, t.get(j-gaps[g]));       
      t.set(j, temp);
    }
  }
}

float maxY(ArrayList<Point> p) {
  float max = p.get(0).getY(); 
  for (int i = 0; i < p.size(); i++) {
    if (p.get(i).getY() > max)
      max = p.get(i).getY();
  }
  return max;
}

int numFruit(ArrayList<Tree> t) {
  int size=0;
  for (int i = 0; i < t.size(); i++) {
    size += t.get(i).getBunch().size();
  }
  return size;
}




  class Frog {
    PVector loc;
    PVector vel;
    PVector acc;
    float mass;
    float j; //jump power
    float jFreq; //frequency of the jump
    int energy;
    float r, g, b;
    float size;


    Frog(float x, float y, float red, float green, float blue, float m_, float j_, float jFreq_, int NRG) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    mass = m_;
    j = j_ /4;
    jFreq = jFreq_;
    energy = NRG;
    r = red;
    g = green;
    b = blue;
    size = mass * 6.5;
  }


   Frog(Frog f) {
    loc = f.loc.copy();
    vel = f.loc.copy();
    acc = f.loc.copy();
    mass = f.mass;
    j = f.j;
    jFreq = f.jFreq;
    energy = f.energy;
    r = f.r;
    g = f.g;
    b = f.b;
    size = mass * 4.5;
  }


  /**
   *Returns a copy of the frog.
   * Frog copy.
   */
    Frog copy() {
    Frog f = new Frog(this);
    return f;
  }






    PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }


  /**
   *Get frog's energy.
   * Frog's energy.
   */
   int getEnergy() {
    return energy;
  }

  /**
   *Set energy.
   New energy.
   */
   void setEnergy(int newEnergy) {
    energy = newEnergy;
  }

  /**
   *Size is a measure of frog dimensions. Width of frog is approx 1 size, Height of frog is approx 1.875 size.
   return Size.
   */
   float getSize() {
    return size;
  }




  /**
   *Update position and energy of frog.
   */
   void update() {   
    if (random(1) < jFreq) {
      if (loc.x + vel.x < simW && loc.x + vel.x > 0 && loc.y + vel.y < simH && loc.y + vel.y > 0){
        vel.add(acc);
        loc.add(PVector.mult(vel, j));
      }else 
      vel.mult(-1);
    }
    vel.limit(3);
    acc.mult(0);
    energy--;
  }

  /**
   *Draw frog.
   */
   void display() {
    fill(r, g, b);
    stroke(r+10, g+10, b+10);
    strokeWeight(3);
    ellipse(loc.x, loc.y+0.375*size, 0.75*size, 0.75*size);
    ellipse(loc.x, loc.y, size, size);
    ellipse(loc.x, loc.y-0.5*size, 0.75*size, size);
  }

  /**
   *Apply an acceleration force to frog.
   *   force New force to be applied.
   */
    void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  /**
   *Determine the strength of the repelling force acting on mosquito m.
   * m The mosquito to be repelled.
   * The acceleration vector that should be applied to m.
   */
   PVector repel(Mosquite m) {
    PVector force = PVector.sub(loc, m.loc);
    float distance = force.mag();
    if (distance > 50)
      return force.mult(0);
    distance = constrain(distance, 5, 50);
    force.normalize();
    float strength = (-mass * 4 * m.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }

  /**
   *Determine if frog is close enough to mosquite m.
   * Candidate for eating.
   * Can I eat this mosquite?
   */
   boolean canEat(Mosquite m) {
    PVector mLoc = m.loc.copy(); 

    PVector dist = PVector.sub(loc, mLoc);
    float distance = dist.mag();

    if (distance > Math.sqrt(Math.pow(0.5 * size + m.getSize(), 2) + Math.pow(0.9375 * size + 0.75 * m.getSize(), 2) ) )
      return false;

    return true;
  }

  /**
   *Check for collision between frog and an array list of mosquitoes. Return the index of the first mosquito collided with.
   *   m Array list of mosqutioes.
   *  returns Index of first mosquito collided with.
   */
    int canEat(ArrayList<Mosquite> m) {
    for (int i = 0; i < m.size(); i++) {
      if (this.canEat(m.get(i)))
        return i;
    }
    return -1;
  }
}



class Fruit {
     PVector loc;
     float red = random(255);
     float green = random(255);
     float yums;


     Fruit(float x_, float y_) {
    loc = new PVector(x_, y_);
    yums = 2 * (float)Math.sqrt(red + green);
  }

  /**
    *Constructor used to copy a fruit.
    *@param f Fruit to be copied.
  */
     Fruit(Fruit f){
   loc = f.loc.copy();
   yums = f.yums;
  }
  

     Fruit copy(){
   Fruit f = new Fruit(this); 
   return f;
  }
  
 

     PVector getLocation() {
    PVector l = loc.copy();  
    return l;
  }

   float getYums() {
    return yums;
  }


   void display() {
    noStroke();
    fill(red, green, 19);
    ellipse(loc.x, loc.y, 16, 16);
  }


   PVector attract(Mosquite m) {
    PVector force = PVector.sub(loc, m.getLocation());
    float distance = force.mag();

    if (distance > 100)
      return force.mult(0);

    distance = constrain(distance, 5, 50);
    force.normalize();
    float strength = (yums * 4 * m.getSize()) / (distance * distance);
    force.mult(strength);
    return force;
  }
}



class LineGraph {
     ArrayList<Point> co;
     float x;
     float y;
     float xsize;
     float ysize;
     String title;
     String xTitle;
     String yTitle;
     int rL, gL, bL;
     int rBG, gBG, bBG;


  /**
   *Create a new line graph at x,y of size width * height.
   *   x Xpos of graph.
   *   y Ypos of graph.
   *   width Width of graph.
   *   height Height of graph.
   */
     LineGraph(float x_, float y_, float wdth_, float hght_) {
    co = new ArrayList<Point>();
    x = x_;
    y = y_;
    xsize = wdth_;
    ysize = hght_;
    title = " ";
    xTitle = " ";
    yTitle = " ";
    rL = 255;
    gL = 0;
    bL = 0;
    rBG = 255;
    gBG = 200;
    bBG = 200;
  }


     LineGraph(float x_, float y_, float wdth_, float hght_, String t, String tx, String ty) {
    co = new ArrayList<Point>();
    x = x_;
    y = y_;
    xsize = wdth_;
    ysize = hght_;
    title = t;
    xTitle = tx;
    yTitle = ty;
    rL = 255;
    gL = 0;
    bL = 0;
    rBG = 255;
    gBG = 200;
    bBG = 200;
  }

  /**
   *Create a copy of the line graph.
   *   Line graph to be copied.
   */
     LineGraph(LineGraph l) {
    co = new ArrayList<Point>(co.size());
    
    for (int i = 0; i < l.co.size(); i++)  
      co.add(new Point(l.co.get(i)));
      
    x = l.x;
    y = l.y;
    xsize = l.xsize;
    ysize = l.ysize;
    title = l.title;
    xTitle = l.xTitle;
    yTitle = l.yTitle;
    rL = l.rL;
    gL = l.gL;
    bL = l.bL;
    rBG = l.rBG;
    gBG = l.gBG;
    bBG = l.bBG;
  }


     LineGraph copy() {
    LineGraph l = new LineGraph(this);
    return l;
  }



  /**
   *Shift the graph along the canvas.
   
   */
     void translate(float cX, float cY) {
    this.x += cX;
    this.y += cY;
  }

  /**
   *Scale the graph's size.
   */
     void scale(float cX, float cY) {
    this.xsize *= cX;
    this.ysize *= cY;
  }


     void rename(String t, String tx, String ty) {
    title = t;
    xTitle = tx;
    yTitle = ty;
  }


     void setColor(int lR, int lG, int lB, int bgR, int bgG, int bgB) {
    rL = lR;
    gL = lG;
    bL = lB;
    rBG = bgR;
    gBG = bgG;
    bBG = bgB;
  }

  /**
   *Draw the graph and any axis titles.
   */
     void sketch(int size, float max) {
    pushMatrix();
    popMatrix();
    float domain = (float)xsize / size;
    fill(rL, gL, bL);
    stroke(0);
    rectMode(CORNER);
    rect(x, y, xsize, ysize);
    for (int i = 0; i < size - 1; i++) {
      strokeWeight(3);
      stroke(rBG, gBG, bBG);
      if (i == size-2)
        line(x+(i*domain), (y+ysize)-(ysize*(co.get(i).getY()/max)), x+xsize, (y+ysize)-(ysize*(co.get(i+1).getY()/max)));
      else
        line(x+(i*domain), (y+ysize)-(ysize*(co.get(i).getY()/max)), x+(i+1)*domain, (y+ysize)-(ysize*(co.get(i+1).getY()/max)));
    }
    PFont f = createFont("Console", 16, true);
    textFont(f, 12);
    textAlign(LEFT);
    fill(0, 255);
    text(max/2, x, (y+ysize)-(ysize*(max/2)/max)); //1/2 of yscale line
    text((max/4), x, (y+ysize)-(ysize*(max/4)/max)); //1/4 of yscale line
    text(3*(max/4), x, ((y+ysize)-(ysize*(3*max/4)/max))); //3/4 of yscale line

    
    textFont(f, 16);
    textAlign(CENTER);
    text(title, x + xsize / 2, y+20);
    text(xTitle, x + xsize / 2, y + ysize-10);
    

  }

  /**
   *Add a new point to the end of the graph.
   */
     void addPoint(Point p) {
    co.add(p);
  }
}




 class Mosquite {
   float tx, ty;
   PVector loc;
   PVector vel;
   PVector acc;
   float mass;
   float buzz; //impact of perlin noise
   float yums;
   float size;
 int energy;


   Mosquite(float x, float y, float m_, int NRG, float bz) {
    loc = new PVector(x, y); 
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    energy = NRG;
    tx = random(10000);
    ty = random(100);
    mass = m_;
    buzz = bz;
    size = mass * 4;
    yums = size * 5;
  }

  /**
   *Constructor for returning a copy of an existing mosquito.
   *param m Mosquito to be copied.
   */
   Mosquite(Mosquite m) {
    loc = m.loc.copy();
    vel = m.vel.copy();
    acc = m.acc.copy();
    energy = m.energy;
    tx = random(10000);
    ty = random(100);
    mass = m.mass;
    buzz = m.buzz;
    size = m.size;
    yums = size * 5;
  }

  /**
   *Return a copy of this instance of a mosquite.
   *return Copy of this mosquite.
   */
   Mosquite copy() {
    Mosquite m = new Mosquite(this);
    return m;
  }




  /**
   *Location of mosquite.
   *return Location of mosquite as a copy of its location PVector.
   */
   PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

  /**
   *Get mosquite's energy.
   return mosquite's energy.
   */
   int getEnergy() {
    return energy;
  }
  
  /**
    *Set mosquite's energy.
    *param newEnergry New value.
  */
   void setEnergy(int nE){
     energy = nE; 
  }

  /**
   *Size is a measure of mosquite dimensions. Width of mosquite is approx 2 size, Height of mosquite is approx 1.5 size.
   *return Size.
   */
   float getSize() {
    return size;
  }

  /**
   *Determines if mosquite can eat with fruit base off of fruit location.
   * Fruit to be checked.
   * Can the mosquito ear?
   */
   boolean canEat(Fruit f) {
    PVector fLoc = f.getLocation();

    PVector dist = PVector.sub(loc, fLoc);
    float distance = dist.mag();

    if (distance > 8 + Math.sqrt(Math.pow(0.75 * size, 2) + Math.pow(size, 2)))
      return false;

    return true;
  }

  /**
   *Checks a tree for potential eating between mosquite and fruit.
   *@param t Tree to check.
   *@return Index of possible eaten fruit.
   */
   int canEat(Tree t) {
    ArrayList<Fruit> f = t.getBunch();
    for (int i = 0; i < f.size(); i++) {
      if (this.canEat(f.get(i)))
        return i;
    }
    return -1;
  }

  /**
   *Returns the index of a tree and a fruit that can be consumed
   */
   int[] canEat(ArrayList<Tree> t) {
    ArrayList<Tree> tC = new ArrayList<Tree>(t.size());
    for (int i = 0; i < t.size(); i++)
      tC.add(new Tree(t.get(i))); 

    int[] index = {-1, -1};
    for (int i = 0; i < tC.size(); i++) {
      if (this.canEat(tC.get(i)) >= 0) {
        index[0] = i;
        index[1] = canEat(tC.get(i));
      }
    }
    return index;
  }

  /**
   *Applies an acceleration force to the mosquite.
   * The acceleration force to be applied.
   */
  public void applyForce(PVector force) {
    PVector f = force.copy();
    acc.add(f);
  }

  /**
   *Attract a frog to this mosquito's location.
   *@param f Frog to be attracted.
   */
   PVector attract(Frog f) {
    PVector fLoc = f.getLocation();
    PVector force = PVector.sub(loc, fLoc);
    float distance = force.mag();
    if (distance > 150)
      return force.mult(0);

    distance = constrain(distance, 5, 50.0); //think about division by very small or very big numbers
    force.normalize();
    float strength = (yums * mass * f.getSize()) / (distance * distance);
    force.mult(strength);     
    return force;
  }

  /**
   *Return the position of the closest fruit.
   * Tree to check.
   * Index of closest fruit.
   */
   int closestFruit(Tree t) {
    ArrayList<Fruit> f = t.getBunch();
    int posMin = 0;
    for (int i = 0; i < f.size(); i++) {
      PVector force = PVector.sub(loc, f.get(i).getLocation());
      float distance = force.mag();
      if (distance < PVector.sub(loc, f.get(posMin).getLocation()).mag())
        posMin = i;
    }
    return posMin;
  }

  /**
   *Take an array of trees and return the closest fruit as an int array. {Tree,Fruit}
   * t The list of trees to be searched.
   */
   int[] closestFruit(ArrayList<Tree> t) {
    int t1 = this.closestTree(t);
    int f1 = this.closestFruit(t.get(t1));
    int[] i = {-1, -1};

    if (t1 >= 0 && f1 >= 0) {
      i[0] = t1;
      i[1] = f1;
    }
    return i;
  }

  /**
   *Return the position of the closest tree.
   *return Closest tree.
   */
  public int closestTree(ArrayList<Tree> t) {
    if (t.size() == 0)
      return -1;
    int posMin = 0;
    for (int i = 0; i < t.size(); i++) {
      PVector force = PVector.sub(loc, t.get(i).getLocation());
      float distance = force.mag();
      if (t.get(i).getBunch().size() > 0 && distance < PVector.sub(loc, t.get(posMin).getLocation()).mag())
        posMin = i;
    }
    return posMin;
  }

  /**
   *Display the mosquite.
   */
   void display() {
    noStroke();
    fill(200);
    ellipse(loc.x+(mass)*2, loc.y-(size)/2, size, size);
    ellipse(loc.x-(mass)*2, loc.y-(size)/2, size, size);
    noStroke();
    fill(0);
    ellipse(loc.x, loc.y, size, size);
  }

  /**
   *Bounds checking and update location.
   */
   void update() {
    acc.x += buzz * map(noise(tx), 0, 1, -2, 2) /100;
    acc.y += buzz * map(noise(ty), 0, 1, -2, 2) /100;
    if (loc.x + vel.x < simW && loc.x + vel.x > 0 && loc.y + vel.y < simH && loc.y + vel.y > 0)
      loc.add(vel);
    else 
    vel.mult(-0.8);
    tx += 0.01;
    ty += 0.01;
    vel.add(acc);
    vel.limit(3);
    loc.add(vel);
    acc.mult(0);
    energy--;
  }
}


 class Tree {
   PVector loc;
   float size;
   float greenScale;
   ArrayList<Fruit> bunch;


     Tree(float x_, float y_, float size_, float greenscale_) {
    loc = new PVector(x_, y_);
    size = (1 + size_);
    greenScale = greenscale_;
    bunch = new ArrayList<Fruit>(5);
    bunch.add(new Fruit(loc.x + map(random(1), 0, 1, -size * 8, size * 8), loc.y + map(random(1), 0, 1, -size * 8, size * 8)));
  }


     Tree(Tree t) {
    loc = t.loc.copy();
    size = t.size;

    if (t.bunch.size() > 0) {
      for (int i = 0; i < t.bunch.size(); i++)
        bunch.add(new Fruit(t.bunch.get(i)));
    }
  }


     Tree copy() {
    Tree copy = new Tree(loc.x, loc.y, size, greenScale);
    for (int i = 0; i < bunch.size(); i++)
      copy.bunch.add(new Fruit(bunch.get(i)));
    return copy;
  }



     PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

     ArrayList<Fruit> getBunch() {
    ArrayList<Fruit> f = new ArrayList<Fruit>();
    if (bunch.size() > 0) {
      for (int i = 0; i < bunch.size(); i++)
        f.add(new Fruit(bunch.get(i)));
    }
    return f;
  }

     void removeFruit(int i) {
    bunch.remove(i);
  }

     void display() {
    noStroke();
    fill(150, 75, 0);
    rectMode(CENTER);
    rect(loc.x, loc.y+(20), 15, 20*size);
    noStroke();
    fill(15*greenScale + 100, 235*greenScale, 0, 150);
    ellipse(loc.x, loc.y, size*20, size*20);
  }

     void update() {
    if (bunch.size() < 50 && random(1) < 0.01)
      bunch.add(new Fruit(loc.x + map(random(1), 0, 1, -size * 8, size * 8), loc.y + map(random(1), 0, 1, -size * 8, size * 8)));
    for (int i = 0; i < bunch.size(); i++)
      bunch.get(i).display();
  }
}
