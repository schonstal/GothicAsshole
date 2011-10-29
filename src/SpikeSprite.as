package
{
  import org.flixel.*;

  public class SpikeSprite extends FlxSprite
  {
    [Embed(source='../data/spike.png')] private var ImgGibs:Class;
    private var _alphaRate:Number = 0.2;

    public var deadly:Boolean = true;
    public static const WIDTH:Number = 20;
    public static const HEIGHT:Number = 30;

    public function SpikeSprite(X:Number, Y:Number):void {
      super(X,Y);
      loadGraphic(ImgGibs, true, true, WIDTH, HEIGHT);
      antialiasing = false;
      immovable = true;

      addAnimation("normal", [0]);
      addAnimation("bloody", [1]);
      addAnimation("disappear", [2], 15, false);
      play("normal");
    }

    public function retract():void {
      deadly = false;
      play("disappear");
    }
  }
}
