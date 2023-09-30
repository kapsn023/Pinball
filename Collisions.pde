public class Shape2{
  public float time;
  public int idx;
}
public class Sphere2 extends Shape2{
  float r;
  Vec2 cent;
  
  public Sphere2(Vec2 cent, float r){
    this.cent = cent;
    this.r = r;
  }
}

public class Line2 extends Shape2{
  public Vec2 p1;
  public Vec2 p2;
  
  public Line2(Vec2 p1, Vec2 p2){
    this.p1 = p1;
    this.p2 = p2;
  }
}

public class Box2 extends Shape2{
  public Vec2 cent;
  public float width, height;
  
  public Box2(Vec2 cent, float width, float height){
    this.cent = cent;
    this.width = width;
    this.height = height;
  }
}

// Helper Clamp Function
private float clamp(float c, float x, float y){
  if (c <= x) return x;
  if (c >= y) return y;
  return c;
}

// Circle on circle
public boolean circleOnCircle(Sphere2 c1, Sphere2 c2){
  return c1.cent.distanceTo(c2.cent) <= (c1.r + c2.r);
}
  
// Circle on Box
public boolean circleOnBox(Sphere2 c, Box2 b){
  Vec2 closest = new Vec2(
    clamp(c.cent.x, b.cent.x - b.width/2, b.cent.x + b.width/2),
    clamp(c.cent.y, b.cent.y - b.height/2, b.cent.y + b.height/2));
  return (closest.new_sub(c.cent).length()) < c.r;
}

// Circle on Line
public boolean circleOnLine(Sphere2 c, Line2 l){
  // Test
  //l.p1 = new Vec2(0, 0); //<>//
  //l.p2 = new Vec2(0.5, -1); 
  //c.cent = new Vec2(0, -10);
  //c.r = 8.0;
  //
  Vec2 V = l.p2.new_sub(l.p1); //<>//
  V.normalize();
  Vec2 PC = l.p1.new_sub(c.cent);
  // b^2 - 4ac
  float B = 2 * dot(V, PC);
  float C = (PC.x * PC.x + PC.y * PC.y) - c.r * c.r;
  float quad = B * B - 4 * C;
  if  (quad >= 0){
    float t1 = ((-1.0 * B) + sqrt(quad)) / 2.0;
    float t2 = ((-1.0 * B) - sqrt(quad)) / 2.0;
    float length = V.length();
    if ((t1 >= 0 && t1 < length) || (t2 >= 0 && t2 < length)){
      return true;
    }
  }
  
  return false;
}

// Box on Box
public boolean boxOnBox(Box2 b1, Box2 b2){
  return Math.abs(b1.cent.x - b2.cent.x) <= (b1.width + b2.width) &&
  Math.abs(b1.cent.y - b2.cent.y) <= (b1.height + b2.height);
}

// Box on Line 
public boolean boxOnLine(Box2 b, Line2 l){
  Line2 top = new Line2(new Vec2(b.cent.x - width/2, b.cent.y + height/2), new Vec2(b.cent.x + width/2, b.cent.y + height/2));
  Line2 bottom = new Line2(new Vec2(b.cent.x - width/2, b.cent.y - height/2), new Vec2(b.cent.x + width/2, b.cent.y - height/2));
  Line2 right = new Line2(new Vec2(b.cent.x + width/2, b.cent.y + height/2), new Vec2(b.cent.x + width/2, b.cent.y - height/2));
  Line2 left = new Line2(new Vec2(b.cent.x - width/2, b.cent.y + height/2), new Vec2(b.cent.x - width/2, b.cent.y - height/2));
  return lineOnLine(top, l) || lineOnLine(bottom, l) || lineOnLine(right, l) || lineOnLine(left, l);
}

// Same-side Test
public boolean sameSide(Line2 l, Vec2 p1, Vec2 p2){
  float cp1 = cross(l.p2.new_sub(l.p1), p1.new_sub(l.p1));
  float cp2 = cross(l.p2.new_sub(l.p1), p2.new_sub(l.p1));
  return cp1 * cp2 >= 0;
}

// Line on Line
public boolean lineOnLine(Line2 l1, Line2 l2){
  if (sameSide(l1, l2.p1, l2.p2)) return false;
  if (sameSide(l2, l1.p1, l1.p2)) return false;
  return true;
}
