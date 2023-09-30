public class Ball extends Sphere2{
 
  public Vec2 vel;
  public float m;
 
  public Ball(Vec2 cent, float r, Vec2 vel, float m){
   super(cent, r);
   this.vel = vel;
   this.m = m;
 }
}

// Ball on Ball Collision
void ballOnBall(Ball b1, Ball b2){
  if (b1.cent.distanceTo(b2.cent) <= (b1.r + b2.r)){
    Vec2 dir = b1.cent.new_sub(b2.cent);
    dir.normalize();
    float v1 = dot(b1.vel, dir);
    float v2 = dot(b2.vel, dir);
    float m1 = b1.m;
    float m2 = b2.m;
    float cor = 0.8;
    float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
    float new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
    //ball.cent = sphere.cent.new_add(normal.new_mul(sphere.r + ball.r).new_mul(1.01));
    b1.cent = b2.cent.new_add(dir.new_mul(b1.r + b2.r).new_mul(1));
    b2.cent = b1.cent.new_add(dir.new_mul(b1.r + b2.r).new_mul(-1));
    b1.vel.add(dir.new_mul(new_v1 - v1)); // += dir * (new_v1 - v1); //Change in velocity along the axis
    b2.vel.add(dir.new_mul(new_v2 - v2)); // += dir * (new_v2 - v2); //only affect velocity along axis!
  }
}
