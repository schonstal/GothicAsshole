package
{
  import org.flixel.*;

  public class BackgroundSprite extends FlxSprite
  {
    //[Embed(source='../data/spike.png')] private var ImgGibs:Class;
    public function BackgroundSprite():void {
      super(0,0);
//      loadGraphic(ImgGibs, true, true, WIDTH, HEIGHT);
      antialiasing = false;

      makeGraphic(FlxG.width,FlxG.height,0xff333333);
    }
  }
}
