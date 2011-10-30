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
    public var grounded:Boolean = false;
    public var bloody:Boolean = false;
    public var enterDoor:Boolean = false;

    public var dead:Boolean = false;

    private var _bloodStr:String = "";
    private var _dirStr:String = "";
    private var _jumpControl:Boolean = false;
    private var _jumpPressed:Boolean = false;
    private var _canMove:Boolean = false;
    private var _started:Boolean = false;

    private var _beforeJumpTimer:Number = 0;
    private var _beforeJumpThreshold:Number = 0.15;

    private var _afterJumpTimer:Number = 0;
    private var _afterJumpThreshold:Number = 0.15;

    private var _looking:uint = RIGHT;

    public static const DOOR_FADE_TIME:Number = 1.0;

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

      addAnimation("standing_left", [8]);
      addAnimation("standing_bloody_left", [11]);
      addAnimation("standing_right", [2]);
      addAnimation("standing_bloody_right", [5]);

      addAnimation("walking_left", [9,8,10,8], 10);
      addAnimation("walking_bloody_left", [12,11,13,11], 10);
      addAnimation("walking_right", [3,2,4,2], 10);
      addAnimation("walking_bloody_right", [6,5,7,5], 10);

      addAnimation("stab_charge_bloody", [0], 10);
      addAnimation("stab_charge", [0], 10);

      addAnimation("stab_bloody", [0], 10);
      addAnimation("stab", [0], 10);

      addAnimation("door", [14,15], 5);

      addAnimation("dead", [16]);

      acceleration.y = _gravity;

      maxVelocity.y = 800;
      maxVelocity.x = 400;
    }

    override public function update():void {
      _bloodStr = (bloody ? "_bloody" : "");
      _dirStr = (_looking == LEFT ? "_left" : "_right");

      if(!_started && GameTracker.transitionSprite.done) {
        _started = _canMove = true;
      }

      if(dead) {
        _canMove = false;
        play("dead");
      } else {
        if(grounded) {
          maxVelocity.x = 200;
          drag.x = 400;
          if(enterDoor) {
            _canMove = false;
            velocity.x = 0;
            alpha -= FlxG.elapsed / DOOR_FADE_TIME;
            play("door");
          } else {
            if(Math.abs(velocity.x) > 0) {
              play("walking" + _bloodStr + _dirStr);
            } else {
              play("standing" + _bloodStr + _dirStr);
            }
          }
        } else {
          maxVelocity.x = 400;
          drag.x = 0;
          play((bloody?"bloody":"normal"));
        }
      }

      if(FlxG.keys.justPressed("W") || FlxG.keys.justPressed("UP")) {
        _jumpPressed = true;
        _beforeJumpTimer = 0;
        if(_afterJumpTimer < _afterJumpThreshold) {
          _jumpControl = true;
        }
        if(grounded && !dead) {
          _jumpControl = true;
          velocity.y = -150;
        }
      }

      _afterJumpTimer += FlxG.elapsed;

      _beforeJumpTimer += FlxG.elapsed;
      if(_beforeJumpTimer >= _beforeJumpThreshold) {
        _jumpPressed = false;
      }
      
      if(!killed && !dead) {
        if(FlxG.keys.A || FlxG.keys.LEFT && _canMove) {
          _looking = LEFT;
          acceleration.x = -_speed.x * (velocity.x > 0 ? 4 : 1);
        } else if(FlxG.keys.D || FlxG.keys.RIGHT && _canMove) {
          acceleration.x = _speed.x * (velocity.x < 0 ? 4 : 1);
          _looking = RIGHT;
        } else if (Math.abs(velocity.x) < 50) {
          velocity.x = 0;
          acceleration.x = 0;
        } else {
          acceleration.x = 0;
        }
      } else if(!dead){
        velocity.x = 0;
        acceleration.x = 0;
        angularVelocity = 1000;
      }

      if(!dead) {
        if(!((FlxG.keys.W || FlxG.keys.UP) && _jumpControl) && velocity.y < 0)
          acceleration.y = _gravity * 2;
        else
          acceleration.y = _gravity;
      }

      
      if(x < -width) {
        x = FlxG.camera.width;
      } else if (x > FlxG.camera.width + width) {
        x = -width;
      }

      super.update();
    }

    public function die():void {
      dead = true;
      acceleration.y = 0;
      velocity.y = 5;
      acceleration.x = 0;
      velocity.x = 0;
      _canMove = false;
      angularVelocity = 0;
      angle = 0;
      FlxG.shake(0.005, 0.2);
      FlxG.level = 1;
    }

    public function bounce():void {
      _jumpControl = false;
      velocity.y = -_speed.y;
      bloody = true;
      _afterJumpTimer = 0;
      if(_jumpPressed)
        _jumpControl = true;
    }
  }
}
