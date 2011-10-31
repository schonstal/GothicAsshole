package
{
  import org.flixel.*;

  public class BackgroundSprite extends FlxSprite
  {
    [Embed(source='../data/background.png')] private var ImgGibs:Class;
    public function BackgroundSprite():void {
      super(0,0);
      loadGraphic(ImgGibs, true, true, 800, 600);
      antialiasing = false;
    }
  }
}
