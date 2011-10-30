package
{
  import org.flixel.*;

  public class BrickSprite extends FlxSprite
  {
//    [Embed(source='../data/brick.png')] private var ImgBrick:Class;

    public function BrickSprite():void {
      super(FlxG.camera.width/2-20,53);
//      loadGraphic(ImgBrick, true, true, 15, 15);
      makeGraphic(40,16,0xffff00ff);
      antialiasing = false;
      allowCollisions = UP;
      immovable = true;
    }
  }
}
