package
{
  import org.flixel.*;

  public class Player extends FlxSprite
  {
    [Embed(source='../data/player.png')] private var ImgPlayer:Class;
    private var _speed:FlxPoint;
    private var _gravity:Number = PlayState.GRAVITY; 

    private var collisionFlags:uint = 0;

    public var killed:Boolean = false;

    public function Player(X:Number,Y:Number):void {
      super(X,Y);
      loadGraphic(ImgPlayer, true, true, 32, 32);

      width = 13;
      height = 20;
      offset.y = 11;
      offset.x = 10;

      _speed = new FlxPoint();
      _speed.y = 500;
      _speed.x = 500;

      addAnimation("normal", [0]);
      addAnimation("bloody", [1]);

      acceleration.y = _gravity;

      maxVelocity.y = 800;
      maxVelocity.x = 600;
    }

    override public function update():void {
      if(!killed) {
        if(FlxG.keys.A) {
          acceleration.x = -_speed.x * (velocity.x > 0 ? 4 : 1);
        } else if(FlxG.keys.D) {
          acceleration.x = _speed.x * (velocity.x < 0 ? 4 : 1);
        } else if (Math.abs(velocity.x) < 50) {
          velocity.x = 0;
          acceleration.x = 0;
        } else {
          acceleration.x = 0;
        }
      } else {
        velocity.x = 0;
        acceleration.x = 0;
      }

      if(!(FlxG.keys.W || FlxG.keys.SPACE || FlxG.keys.UP) && velocity.y < 0)
        acceleration.y = _gravity * 2;
      else
        acceleration.y = _gravity;

      
      if(x < -width) {
        x = FlxG.camera.width;
      } else if (x > FlxG.camera.width + width) {
        x = -width;
      }

      super.update();
    }

    public function die():void {
      exists = false;
      FlxG.shake(0.005, 0.2);
    }

    public function bounce():void {
      velocity.y = -_speed.y;
    }
  }
}
