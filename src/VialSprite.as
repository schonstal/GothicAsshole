package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class VialSprite extends FlxSprite
  {
    [Embed(source='../data/vial.png')] private var ImgVials:Class;

    public var vialCallback:Function;

    public function VialSprite():void {
      super(0,0);
      loadGraphic(ImgVials, true, true, 20, 128);
      antialiasing = false;

      scrollFactor.x = scrollFactor.y = 0;
    }

    override public function update():void {
      //Disgusting... or BRILLIANT?!??!
      if(vialCallback != null) {
        frame = vialCallback();
      }
      super.update();
    }
  }
}
