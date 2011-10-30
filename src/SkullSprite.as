package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class SkullSprite extends FlxSprite
  {
    [Embed(source='../data/skull.png')] private var ImgSkulls:Class;
    public var awake:Boolean = false;
    public var moveCallback:Function;
    public var poofCallback:Function;

    public var waking:Boolean = false;
    private var _wakeUpTimer:Number = 0;
    private var _wakeUpThreshold:Number = 0.3;
    
    private var _poofTimer:Number = 0;
    private var _poofThreshold:Number = 0.25;

    private var sinAmt:Number = 0;
    private var sinOffset:Number = 0;
    private var sinMod:Number = 0;

    public function SkullSprite(X:Number, Y:Number):void {
      super(X,Y);
      loadGraphic(ImgSkulls, true, true, 19, 23);
      antialiasing = false;

      addAnimation("sleeping", [0]);
      addAnimation("awake", [1,2], 5);
      
      width = 13;
      height = 20;
      offset.x = 4;
      offset.y = 3;
    }

    public function wakeUp():void {
      waking = true;
    }

    override public function update():void {
      if(waking) {
          _wakeUpTimer += FlxG.elapsed;

        if(_wakeUpTimer > _wakeUpThreshold) {
          awake = true;
          waking = false;
        }
      }

      if(velocity.x > 0)
        facing = RIGHT;
      else
        facing = LEFT;

      if(moveCallback != null && awake)
        moveCallback();

      if(awake) {
        _poofTimer += FlxG.elapsed;
        if(_poofTimer > _poofThreshold) {
          if(poofCallback != null) poofCallback();
          _poofTimer = 0;
        }
        play("awake");
      } else {
        sinAmt += FlxG.elapsed;
        sinOffset = Math.sin(sinAmt+sinMod)*30;
        velocity.x = sinOffset;
        velocity.y = 0;
        play("sleeping");
      }
      super.update();
    }
  }
}
