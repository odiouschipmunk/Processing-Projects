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

  //t = new Tree(random(55, simW-55), random(55, simH-55), random(0.5)+1, random(1)+0.3);
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
    //println(army.get(i).toString());
    //PVector rand = new PVector(random(-0.02,0.02),random(-0.02,0.02));
    if (army.get(i).getEnergy() <= 0){
      army.remove(i);
      continue;
    } else {
      for (int j = 0; j < army.size(); j++){
        if (j == i)
          continue;
        else {
         if (army.get(i).canBreed(army.get(j))){
           //print("&&&&&");
           army.get(i).setEnergy(army.get(i).getRepNRG()/6);
           army.get(j).setEnergy(army.get(j).getRepNRG()/6);
           Frog f = new Frog(army.get(i).breed(army.get(j)));
           army.add(f);
         }
        }
      }
    }
    for (int j = 0; j < scourge.size(); j++) {
      army.get(i).applyForce(scourge.get(j).attract(army.get(i)));
      if (army.get(i).canEat(scourge.get(j))) {
        //println("@@@@@@");
        army.get(i).setEnergy((int)army.get(i).getEnergy() + (int)scourge.get(j).getSize() * 5);
        scourge.remove(j);
      }
    }
    //army.get(i).applyForce(rand);
    army.get(i).update();
    army.get(i).display();
  }

  for (int i = 0; i < scourge.size(); i++) {
    //PVector rand = new PVector(random(-0.02,0.02),random(-0.02,0.02));
    if (scourge.get(i).getEnergy() <= 0){
      scourge.remove(i);
      continue;
    }
    for (int j = 0; j < army.size(); j++)
      scourge.get(i).applyForce(army.get(j).repel(scourge.get(i)));
    //army.get(i).applyForce(rand);
    
    for (int j = 0; j < forest.size(); j++) {
      t = forest.get(j);
      if (scourge.get(i).closestFruit(t) >= 0 && t.getBunch().size() > 0) {
        scourge.get(i).applyForce(t.getBunch().get(scourge.get(i).closestFruit(t)).attract(scourge.get(i)));
        //print(scourge.get(i).closestFruit(t));
        if (scourge.get(i).canEat(t) >= 0) {
          //println(",================== "+scourge.get(i).canEat(t));
          t.removeFruit(scourge.get(i).canEat(t));
          scourge.add(scourge.get(i).breed());
          scourge.get(i).setEnergy((int)scourge.get(i).getSize()*100);
        } //else 
        //println();
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











//frog.pde


public class Frog {
  private PVector loc;
  private PVector vel;
  private PVector acc;
  //private float yums = -10;
  private float mass;
  private float j; //jump power
  private float jFreq;
  private int energy;
  private float r, g, b;
  private float size;
  private int repNRG;

  /**
   *Create the first instance of a frog in a program
   *@param x X position
   *@param y Y position
   *@param red Red value
   *@param green Green value
   *@param blue Blue value
   *@param m_ Mass
   *@param j_ Jump power
   *@param jFreq_ Jump frequency (chance to jump each frame)
   *@param NRG Starting energy
   */
  public Frog(float x, float y, float red, float green, float blue, float m_, float j_, float jFreq_, int NRG) {
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
    repNRG = (int) mass * 400;
    size = mass * 6.5;
  }

  /**
   *Create a copy of an existing frog.
   *@param Frog to be copied
   */
  public Frog(Frog f) {
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
    repNRG = (int) mass * 400;
    size = mass * 4.5;
  }

  /**
   *Constructor for creating a new mutated frog from two parents.
   *@param f1 Parent 1.
   *@param f2 Parent 2.
   */
  public Frog(Frog f1, Frog f2) {
    Frog f1C = new Frog(f1);
    Frog f2C = new Frog(f2);

    loc = new PVector(f1.loc.x, f2.loc.y);
    mass = ((f1C.mass + f2C.mass) / 2) * random(0.9, 1.1);
    j = ((f1C.j + f2C.j) / 2) * random(0.9, 1.1);
    jFreq = ((f1C.jFreq + f2C.jFreq) / 2) * random(0.9, 1.1);
    energy = (int)(((f1C.energy + f2C.energy) / 2) * random(0.9, 1.1));
    r = ((f1C.r + f2C.r) / 2) * random(0.9, 1.1);
    g = ((f1C.g + f2C.g) / 2) * random(0.9, 1.1);
    b = ((f1C.b + f2C.b) / 2) * random(0.9, 1.1);
  }

  /**
   *Returns a copy of the frog.
   *@return Frog copy.
   */
  public Frog copy() {
    Frog f = new Frog(this);
    return f;
  }

  /**
   *Breed frog instance with other frog, creating a new, slightly mutated frog at same position.
   *@param f2 Parent two.
   *@return New frog.
   */
  public Frog breed(Frog f2) {
    Frog f1C = new Frog(this);
    Frog f2C = new Frog(f2);

    float f3Mass = ((f1C.mass + f2C.mass) / 2) * random(0.9, 1.1);
    float f3J= ((f1C.j + f2C.j) / 2) * random(0.9, 1.1);
    float f3JFreq = ((f1C.jFreq + f2C.jFreq) / 2) * random(0.9, 1.1);
    int f3Energy = (int)(((f1C.energy + f2C.energy) / 2) * random(0.9, 1.1));
    float f3R = ((f1C.r + f2C.r) / 2) * random(0.9, 1.1);
    float f3G = ((f1C.g + f2C.g) / 2) * random(0.9, 1.1);
    float f3B = ((f1C.b + f2C.b) / 2) * random(0.9, 1.1);

    return new Frog(f1C.loc.x, f1C.loc.y, f3R, f3G, f3B, f3Mass, f3J, f3JFreq, f3Energy);
  }

  /**
   *String representation of any usable information from instance.
   *@return String representation of usable info.
   */
  public String toString() {
    String s = ("Location: ("+(int)loc.x+", "+(int)loc.y+") Mass: " + mass + " Jump Constant: " + j + " JumpFreq: " + jFreq + " Energy: " + energy + " Rep Energy: " + repNRG);
    return s;
  }

  /**
   *Location of frog.
   *@return Location of frog as a copy of its location PVector.
   */
  public PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

  /**
   *Get frog's reproduction energy.
   *@return Frog's reproduction energy.
   */
  public int getRepNRG() {
    return repNRG;
  }

  /**
   *Get frog's energy.
   *@return Frog's energy.
   */
  public int getEnergy() {
    return energy;
  }

  /**
   *Set energy.
   *@param New energy.
   */
  public void setEnergy(int newEnergy) {
    energy = newEnergy;
  }

  /**
   *Size is a measure of frog dimensions. Width of frog is approx 1 size, Height of frog is approx 1.875 size.
   *@return Size.
   */
  public float getSize() {
    return size;
  }

  /**
   *Determines if frog can breed with other frog based off reproduction energy requirements and relative location.
   *@param Potential Parent 2.
   *@return Can the frogs breed?
   */
  public boolean canBreed(Frog f2) {
    PVector f2Loc = f2.getLocation();
    int f2Energy = f2.getEnergy();
    int f2repNRG = f2.getRepNRG();

    if (energy < repNRG && f2Energy < f2repNRG)
      return false;

    PVector dist = PVector.sub(loc, f2Loc);
    float distance = dist.mag();

    if (distance > Math.sqrt(Math.pow(0.5 * size + 0.5 * f2.getSize(), 2) + Math.pow(0.9375 * size + 0.9375 * f2.getSize(), 2) ) )
      return false;

    return true;
  }

  /**
   *Checks an array list of Frog objects, and returns the first possible parent frog.
   *@param f Array to be checked.
   *@return Index of frog first possible parent.
   */
  public int canBreed(ArrayList<Frog> f) {
    for (int i = 0; i < f.size(); i++) {
      PVector f2Loc = f.get(i).getLocation();
      int f2Energy = f.get(i).getEnergy();
      int f2repNRG = f.get(i).getRepNRG();

      PVector dist = PVector.sub(loc, f2Loc);
      float distance = dist.mag();

      if (energy >= repNRG && f2Energy >= f2repNRG && distance <= Math.sqrt(Math.pow(0.5 * size + 0.5 * f.get(i).getSize(), 2) + Math.pow(0.9375 * size + 0.9375 * f.get(i).getSize(), 2) ) )
        return i;
    }
    return -1;
  }

  /**
   *Update position and energy of frog.
   */
  public void update() {   
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
  public void display() {
    fill(r, g, b);
    stroke(r+10, g+10, b+10);
    strokeWeight(3);
    ellipse(loc.x, loc.y+0.375*size, 0.75*size, 0.75*size);
    ellipse(loc.x, loc.y, size, size);
    ellipse(loc.x, loc.y-0.5*size, 0.75*size, size);
  }

  /**
   *Apply an acceleration force to frog.
   *@param force New force to be applied.
   */
  public void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  /**
   *Determine the strength of the repelling force acting on mosquito m.
   *@param m The mosquito to be repelled.
   *@return The acceleration vector that should be applied to m.
   */
  public PVector repel(Mosquite m) {
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
   *@param Candidate for eating.
   *@return Can I eat this mosquite?
   */
  public boolean canEat(Mosquite m) {
    PVector mLoc = m.loc.copy(); 

    PVector dist = PVector.sub(loc, mLoc);
    float distance = dist.mag();

    if (distance > Math.sqrt(Math.pow(0.5 * size + m.getSize(), 2) + Math.pow(0.9375 * size + 0.75 * m.getSize(), 2) ) )
      return false;

    return true;
  }

  /**
   *Check for collision between frog and an array list of mosquitoes. Return the index of the first mosquito collided with.
   *@param m Array list of mosqutioes.
   *@return Index of first mosquito collided with.
   */
  public int canEat(ArrayList<Mosquite> m) {
    for (int i = 0; i < m.size(); i++) {
      if (this.canEat(m.get(i)))
        return i;
    }
    return -1;
  }
}
















//fruit.pde

public class Fruit {
  private PVector loc;
  private float red = random(255);
  private float green = random(255);
  private float yums;

  /**
   *Constructor used to create a fruit.
   *@param x X location.
   *@param y Y location.
   */
  public Fruit(float x_, float y_) {
    loc = new PVector(x_, y_);
    yums = 2 * (float)Math.sqrt(red + green);
  }

  /**
    *Constructor used to copy a fruit.
    *@param f Fruit to be copied.
  */
  public Fruit(Fruit f){
   loc = f.loc.copy();
   yums = f.yums;
  }
  
  /**
    *Return a copy of this fruit.
    *@return Fruit copy.
  */
  public Fruit copy(){
   Fruit f = new Fruit(this); 
   return f;
  }
  
  /**
   *Return a string representation of notable data held within Fruit.
   *@return String.
   */
  public String toString() {
    String s = ("Location: (" + loc.x + ", " + loc.y + ") Yums: + " +yums);
    return s;
  }
  /**
   *Used to get the location of the fruit.
   *@return Location as a PVector.
   */
  public PVector getLocation() {
    PVector l = loc.copy();  
    return l;
  }

  /**
   *Return the yums, or attraction force of the fruit.
   *@return Attraction force.
   */
  public float getYums() {
    return yums;
  }

  /**
   *Draw the fruit.
   */
  public void display() {
    noStroke();
    fill(red, green, 19);
    ellipse(loc.x, loc.y, 16, 16);
  }

  /**
   *Calculate the attraction force that the fruit applies on the mosquito.
   *@param m Mosquito to be attracted.
   *@return Acceleration force that should be applied to mosquito.
   */
  public PVector attract(Mosquite m) {
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








//linegraph.pde
public class LineGraph {
  private ArrayList<Point> co;
  private float x;
  private float y;
  private float xsize;
  private float ysize;
  private String title;
  private String xTitle;
  private String yTitle;
  private int rL, gL, bL;
  private int rBG, gBG, bBG;


  /**
   *Create a new line graph at x,y of size width * height.
   *@param x Xpos of graph.
   *@param y Ypos of graph.
   *@param width Width of graph.
   *@param height Height of graph.
   */
  public LineGraph(float x_, float y_, float wdth_, float hght_) {
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

  /**
   *Create a new line graph with graph and axis titles.
   *@param x Xpos of graph.
   *@param y Ypos of graph.
   *@param width Width of graph.
   *@param height Height of graph.
   *@param t Graph title.
   *@param tx X axis title.
   *@param ty Y axis title.
   */
  public LineGraph(float x_, float y_, float wdth_, float hght_, String t, String tx, String ty) {
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
   *@param Line graph to be copied.
   */
  public LineGraph(LineGraph l) {
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

  /**
   *Return a copy of this instance of line graph.
   *@return Copy of this graph.
   */
  public LineGraph copy() {
    LineGraph l = new LineGraph(this);
    return l;
  }

  /**
   *Return any important data of this class as a string.
   *@param List of important parameters, including every existing point.
   */
  public String toString() {
    String s = ("Position : (" + x + ", " + y + ") Size: (" + xsize + ", " + ysize +") Points: ");
    for (int i = 0; i < co.size(); i++)
      s.concat(co.get(i).toString());
    return s;
  }

  /**
   *Shift the graph along the canvas.
   *@param cX Change in x position.
   *@param cY Change in y position.
   */
  public void translate(float cX, float cY) {
    this.x += cX;
    this.y += cY;
  }

  /**
   *Scale the graph's size.
   *@param cX Multiplier for x axis.
   *@param cY Mulitplier for y axis.
   */
  public void scale(float cX, float cY) {
    this.xsize *= cX;
    this.ysize *= cY;
  }

  /**
   *Change the labels of the graph.
   *@param t Graph title.
   *@param tx X-axis title.
   *@param ty Y-axis title.
   */
  public void rename(String t, String tx, String ty) {
    title = t;
    xTitle = tx;
    yTitle = ty;
  }

  /**
   *Change the color of the line and the background.
   *@param lR The red value of the line.
   *@param lG The green value of the line.
   *@param lB The blue value of the line.
   *@param bgR The red vlaue fo the background.
   *@param bgG The green value of the background.
   *@param bgB The blue value of the background.
   */
  public void setColor(int lR, int lG, int lB, int bgR, int bgG, int bgB) {
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
  public void sketch(int size, float max) {
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
    
    /*
    pushMatrix();
    translate(x + xsize / 2, y + 20);
    rotate(-HALF_PI);
    text("Some vertical text",0,0);
    popMatrix();
    //text("Some not vertical text",20,20);
    */
  }

  /**
   *Add a new point to the end of the graph.
   */
  public void addPoint(Point p) {
    co.add(p);
  }
}










//Mosquite.pde



public class Mosquite {
  private float tx, ty;
  private PVector loc;
  private PVector vel;
  private PVector acc;
  private float mass;
  private float buzz; //impact of perlin noise
  private float yums;
  private float size;
  private int energy;

  /**
   *Constructor for creating initial mosquitoes.
   *@param x X location.
   *@param y Y location.
   *@param m_ Mass of mosquito.
   *@param NRG Energy of mosquito.
   *@param bz Impact of perlin noise on mosquito.
   */
  public Mosquite(float x, float y, float m_, int NRG, float bz) {
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
   *@param m Mosquito to be copied.
   */
  public Mosquite(Mosquite m) {
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
   *@return Copy of this mosquite.
   */
  public Mosquite copy() {
    Mosquite m = new Mosquite(this);
    return m;
  }

  /**
   *Create a slightly mutated new mosquito from this instance and another parent.
   *@param m2 Parent 2.
   *@return New and slightly mutated mosquito.
   */
  public Mosquite breed(Mosquite m2) {
    Mosquite m1C = this.copy();
    Mosquite m2C = m2.copy();
    int m3Energy = (int)(((m1C.energy + m2C.energy) /2) * random(0.9, 1.1));
    float m3Mass = ((m1C.mass + m2C.mass) /2) * random(0.9, 1.1);
    float m3Buzz = ((m1C.buzz + m2C.buzz) /2) * random(0.9, 1.1);

    Mosquite m3 = new Mosquite(m1C.loc.x, m1C.loc.y, m3Mass, m3Energy, m3Buzz);
    return m3;
  }

  /**
   *Create a slightly mutated new mosquito from this instance.
   *@return New and slightly mutated mosquito.
   */
  public Mosquite breed() {
    Mosquite m1C = this.copy();

    int m2Energy = (int)(m1C.energy * random(0.9, 1.1));
    float m2Mass = m1C.mass * random(0.9, 1.1);
    float m2Buzz = m1C.buzz * random(0.9, 1.1);

    Mosquite m2 = new Mosquite(m1C.loc.x, m1C.loc.y, m2Mass, m2Energy, m2Buzz);
    return m2;
  }

  /**
   *For debugging use, returns a string representation of important mosquito variables.
   *@return Important Mosquite variables.
   */
  public String toString() {
    String s = ("Location: (" +loc.x+ ", " +loc.y+ ") Mass: " +mass+ " Perlin Accleration: " +buzz+ " Energy: " +energy);
    return s;
  }

  /**
   *Location of mosquite.
   *@return Location of mosquite as a copy of its location PVector.
   */
  public PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

  /**
   *Get mosquite's energy.
   *@return mosquite's energy.
   */
  public int getEnergy() {
    return energy;
  }
  
  /**
    *Set mosquite's energy.
    *@param newEnergry New value.
  */
  public void setEnergy(int nE){
     energy = nE; 
  }

  /**
   *Size is a measure of mosquite dimensions. Width of mosquite is approx 2 size, Height of mosquite is approx 1.5 size.
   *@return Size.
   */
  public float getSize() {
    return size;
  }

  /**
   *Determines if mosquite can eat with fruit base off of fruit location.
   *@param Fruit to be checked.
   *@return Can the mosquito ear?
   */
  public boolean canEat(Fruit f) {
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
  public int canEat(Tree t) {
    ArrayList<Fruit> f = t.getBunch();
    for (int i = 0; i < f.size(); i++) {
      if (this.canEat(f.get(i)))
        return i;
    }
    return -1;
  }

  /**
   *Returns the index of a tree and a fruit that can be consumed
   *@param Array list of Tree to check.
   *@return Index of tree and of fruit of that tree to consume
   */
  public int[] canEat(ArrayList<Tree> t) {
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
   *@param The acceleration force to be applied.
   */
  public void applyForce(PVector force) {
    PVector f = force.copy();
    acc.add(f);
  }

  /**
   *Attract a frog to this mosquito's location.
   *@param f Frog to be attracted.
   */
  public PVector attract(Frog f) {
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
   *@param Tree to check.
   *@return Index of closest fruit.
   */
  public int closestFruit(Tree t) {
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
   *@param t The list of trees to be searched.
   *@return i The index of the closest tree.
   */
  public int[] closestFruit(ArrayList<Tree> t) {
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
   *@param t Array list of trees to check.
   *@return Closest tree.
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
  public void display() {
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
  public void update() {
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






//point.pde



public class Point {
  private float x;
  private float y;

  /**
   *Initialize a new point.
   *@param x The x value of the point.
   *@param y The y value of the point.
   */
  public Point(float x_, float y_) {
    x = x_;
    y = y_;
  }

  /**
   *Constructor for copying an existing point.
   *@param Point to be copied.
   */
  public Point(Point p) {
    x = p.x;
    y = p.y;
  }

  /**
   *Method for returning a copy of the point.
   *@return Copy of this point.
   */
  public Point copy() {
    Point p = new Point(this);
    return p;
  }  

  /**
   *Returns the point as a coordinate.
   *@return Coordinate in form (x,y)_.
   */
  public String toString() {
    String s = ("("+x+", "+y+") ");
    return s;
  }

  /**
   *Return x value of point.
   *@return Point's x value.
   */
  public float getX() {
    return x;
  }

  /**
   *Return the y value of a point.
   *@param Point's y value.
   */
  public float getY() {
    return y;
  }
}








//tree.pde



public class Tree {
  private PVector loc;
  private float size;
  private float greenScale;
  private ArrayList<Fruit> bunch;

  /**
   *Create an initial tree.
   *@param x_ X position.
   *@param y_ Y position.
   *@param size_ The radius of the tree is size * 10.
   *@param greenscale_ The color of the tree.
   */
  public Tree(float x_, float y_, float size_, float greenscale_) {
    loc = new PVector(x_, y_);
    size = (1 + size_);
    greenScale = greenscale_;
    bunch = new ArrayList<Fruit>(5);
    bunch.add(new Fruit(loc.x + map(random(1), 0, 1, -size * 8, size * 8), loc.y + map(random(1), 0, 1, -size * 8, size * 8)));
  }

  /**
   *Copy an existing tree's parameters.
   *@param t Tree to be copied.
   */
  public Tree(Tree t) {
    loc = t.loc.copy();
    size = t.size;

    if (t.bunch.size() > 0) {
      for (int i = 0; i < t.bunch.size(); i++)
        bunch.add(new Fruit(t.bunch.get(i)));
    }
  }

  /**
   *Copy this instance of a Tree.
   *@return A copy of this tree.
   */
  public Tree copy() {
    Tree copy = new Tree(loc.x, loc.y, size, greenScale);
    for (int i = 0; i < bunch.size(); i++)
      copy.bunch.add(new Fruit(bunch.get(i)));
    return copy;
  }

  /**
   
   */
  public String toString() {
    String s = ("Location: (" +loc.x+ ", " +loc.y+" ) Size: " +size+ " Number of Fruit: " +bunch.size());
    return s;
  }

  public PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

  public ArrayList<Fruit> getBunch() {
    ArrayList<Fruit> f = new ArrayList<Fruit>();
    if (bunch.size() > 0) {
      for (int i = 0; i < bunch.size(); i++)
        f.add(new Fruit(bunch.get(i)));
    }
    return f;
  }

  public void removeFruit(int i) {
    bunch.remove(i);
  }

  public void display() {
    noStroke();
    fill(150, 75, 0);
    rectMode(CENTER);
    rect(loc.x, loc.y+(20), 15, 20*size);
    noStroke();
    fill(15*greenScale + 100, 235*greenScale, 0, 150);
    ellipse(loc.x, loc.y, size*20, size*20);
  }

  public void update() {
    if (bunch.size() < 5 && random(1) < 0.01)
      bunch.add(new Fruit(loc.x + map(random(1), 0, 1, -size * 8, size * 8), loc.y + map(random(1), 0, 1, -size * 8, size * 8)));
    for (int i = 0; i < bunch.size(); i++)
      bunch.get(i).display();
  }
}