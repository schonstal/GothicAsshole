package
{
  import org.flixel.*;

  public class ArrowSprite extends FlxSprite
  {
    [Embed(source='../data/pointer.png')] private var ImgArrow:Class;
    private var player:Player;

    public function ArrowSprite(p:Player):void {
      super(0,0);
      loadGraphic(ImgArrow, true, true, 15, 15);
      antialiasing = false;
      visible = false;
      player = p;
    }

    public override function update():void {
      if(player.y < 0 - player.height) {
        visible = true;
        x = player.x;
      } else {
        visible = false;
      }
    }
  }
}
