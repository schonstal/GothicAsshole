package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class GibTrailSprite extends FlxSprite
  {
    [Embed(source='../data/blood.png')] private var ImgGibs:Class;
    private var _alphaRate:Number = 0.2;

    public function GibTrailSprite():void {
      super(0,0);
      loadGraphic(ImgGibs, true, true, 8, 8);
      antialiasing = false;
    }

    public function create(X:Number, Y:Number):void {
      x = X;
      y = Y;
      exists = true;
      alpha = 1;
    }

    override public function update():void {
      alpha -= FlxG.elapsed / _alphaRate;
      if(alpha <= 0)
        exists = false;
      super.update();
    }
  }
}
