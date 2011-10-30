package
{
  import org.flixel.*;

  public class SpikeSprite extends FlxSprite
  {
    [Embed(source='../data/spike.png')] private var ImgGibs:Class;
    private var _alphaRate:Number = 0.2;

    public static const WIDTH:Number = 10;
    public static const HEIGHT:Number = 31;

    public var bloody:Boolean = false;

    public function SpikeSprite(X:Number, Y:Number):void {
      super(X,Y+10);
      loadGraphic(ImgGibs, true, true, WIDTH, HEIGHT);
      antialiasing = false;
      immovable = true;

      offset.y = 10;

      addAnimation("normal", [0]);
      addAnimation("bloody", [6]);
      addAnimation("disappear_bloody", [6,7,8,9,10,11], 15, false);
      addAnimation("disappear", [0,1,2,3,4,5], 15, false);
      play("normal");
    }

    public function retract():void {
      solid = false;
      play("disappear" + (bloody?"_bloody":""));
    }
  }
}
