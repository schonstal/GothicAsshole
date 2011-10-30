package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class SkullSprite extends FlxSprite
  {
    [Embed(source='../data/skull.png')] private var ImgSkulls:Class;
    public var awake:Boolean = false;
    public var moveCallback:Function;

    public var waking:Boolean = false;
    private var _wakeUpTimer:Number = 0;
    private var _wakeUpThreshold:Number = 0.3;

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
      if(waking)
        _wakeUpTimer += FlxG.elapsed;

      if(_wakeUpTimer > _wakeUpThreshold) {
        awake = true;
      }

      if(moveCallback != null && awake)
        moveCallback();

      if(awake) {
        play("awake");
      } else {
        play("sleeping");
      }
      super.update();
    }
  }
}
