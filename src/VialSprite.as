package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class VialSprite extends FlxSprite
  {
    [Embed(source='../data/vial.png')] private var ImgVials:Class;

    public function VialSprite():void {
      super(FlxG.width-25,5);
      loadGraphic(ImgVials, true, true, 20, 128);
      antialiasing = false;

      scrollFactor.x = scrollFactor.y = 0;
    }

    override public function update():void {
      frame = 100 - Math.floor(((GameTracker.score-GameTracker.mostRecentScore)/GameTracker.dropRequirement)*100);
      super.update();
    }
  }
}
