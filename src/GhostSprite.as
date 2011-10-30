package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class GhostSprite extends FlxSprite
  {
    [Embed(source='../data/ghost.png')] private var ImgGhosts:Class;
    private var _scaryTimer:Number = 0;
    private var _scaryThreshold:Number = 0.3;

    public static const SPEED:Number = 40;

    public function GhostSprite():void {
      var pos:FlxPoint;
      if(Math.random() > 0.5) {
        pos = new FlxPoint(0, Math.random()*(FlxG.camera.height-200) + 100);
        facing = RIGHT;
      } else {
        pos = new FlxPoint(FlxG.camera.width, Math.random()*(FlxG.camera.height-200) + 100);
        facing = LEFT;
      }
      super(pos.x, pos.y);

//      super(0,0);

      loadGraphic(ImgGhosts, true, true, 32, 32);
      antialiasing = false;

      var frames:Array = new Array();
      for(var i:int = 0; i < 40; i++) {
        frames.push(0);
      }

      for(i = 0; i < 20; i++) {
        frames.push(i%2);
      }

      addAnimation("cry", frames, 15);
      play("cry");
      
      width = 22;
      height = 30;
      offset.x = 10;

      if(x > FlxG.camera.width / 2) {
        velocity.x = SPEED * -1;
        facing = LEFT;
      } else {
        velocity.x = SPEED;
        facing = RIGHT;
      }
    }
  }
}
