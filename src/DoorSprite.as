package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class DoorSprite extends FlxSprite
  {
    [Embed(source='../data/entranceExit.png')] private var ImgDoors:Class;
    public function DoorSprite():void {
      super(FlxG.camera.width/2-13,FlxG.camera.height-48);
      loadGraphic(ImgDoors, true, true, 36, 48);
    }
  }
}
