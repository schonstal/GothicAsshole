package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class GibParticle extends FlxParticle
  {
    [Embed(source='../data/blood.png')] private var ImgGibs:Class;
    public var onEmitCallback:Function;
    public var trailCallback:Function;

    private var _objectToFollow:FlxSprite;
    private var _angle:Number;
    private var _amplitude:Number;

    private var _followTimer:Number = 0;
    private var _followThreshold:Number = 1;

    public function GibParticle():void {
      loadGraphic(ImgGibs, true, true, 8, 8);
      exists = false;
      antialiasing = false;

      width = height = 6;
      offset.y = offset.x = 1;
    }

    public function follow(objectToFollow:FlxSprite):void {
      _objectToFollow = objectToFollow;
    }

    override public function onEmit():void {
      if(onEmitCallback != null) 
        onEmitCallback();
    }

    override public function update():void {
      _followTimer += FlxG.elapsed;
      if(_followTimer > _followThreshold) {
        if(_objectToFollow != null) {
          FlxVelocity.accelerateTowardsObject(this, _objectToFollow, 50000, 600, 600);

          if(FlxG.overlap(this, _objectToFollow)) {
            exists = false;
            GameTracker.score++;
          }
        }
      }

      if(trailCallback != null)
        trailCallback(x,y);
    }
  }
}
