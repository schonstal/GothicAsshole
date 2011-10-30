package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class FlameSprite extends FlxSprite
  {
    [Embed(source='../data/flameBall.png')] private var ImgFlames:Class;
    public function FlameSprite():void {
      super(0,0);
      loadGraphic(ImgFlames, true, true, 8, 8);
      antialiasing = false;

      addAnimation('poof', [0,2,0,2,0,2,1,3,2,4], 10, false);
    }

    public function create(X:Number, Y:Number):void {
      x = X;
      y = Y;
      exists = true;
      play('poof');
    }

    override public function update():void {
      if(finished)
        exists = false;
      super.update();
    }
  }
}
