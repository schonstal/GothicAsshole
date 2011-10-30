package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class DoorSprite extends FlxSprite
  {
//    [Embed(source='../data/door.png')] private var ImgDoors:Class;
    public function DoorSprite():void {
      super(FlxG.camera.width/2-10,FlxG.camera.height-30);
//      loadGraphic(ImgDoors, true, true, 20, 30);
      makeGraphic(20, 30, 0xffff00ff);
    }
  }
}
