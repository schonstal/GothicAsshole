package
{
  import org.flixel.*;

  public class EnemySprite extends FlxSprite
  {
    [Embed(source='../data/enemy.png')] private var ImgEnemy:Class;

    private var originalPosition:FlxPoint;
    private var sinAmt:Number = 0;
    private var sinOffset:Number = 0;
    private var sinMod:Number = 0;

    private var horizMove:Boolean = true;

    public function EnemySprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      loadGraphic(ImgEnemy, true, true, 22, 18);
      height = 6;
      width = 12;

      offset.x = 5;
      offset.y = 6;

      var flapFrames:Array = [0,1,2,3,4,5];
      addAnimation("flap", flapFrames, 15);
      
      facing = RIGHT;

      create(X,Y);
    }

    //In case you need to recycle
    public function create(X:Number, Y:Number):void {
      x = X;
      y = Y;
      exists = true;
      originalPosition = new FlxPoint(x,y);
      play("flap");
      sinMod = Math.random() * 2 * Math.PI;

//      if(Math.random() > 0.5)
//        horizMove = !horizMove;
    }

    override public function update():void {
      sinAmt += FlxG.elapsed;
      sinOffset = Math.sin(sinAmt+sinMod)*30;

      if(velocity.x > 0)
        facing = RIGHT;
      else
        facing = LEFT;

      if(horizMove)
        velocity.x = sinOffset;
      else
        velocity.y = sinOffset;

      super.update();
    }
  }
}
