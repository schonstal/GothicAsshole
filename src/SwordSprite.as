package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class SwordSprite extends FlxSprite
  {
    [Embed(source='../data/sword.png')] private var ImgSwords:Class;
    public function SwordSprite(player:Player):void {
      var X:Number = player.x;
      var Y:Number = player.y;
      var velocityX:Number = player.velocity.x;

      super(X, Y);
      angularVelocity = 3000;
      velocity.x = velocityX;

      acceleration.y = PlayState.GRAVITY;
      velocity.y = -450;

      loadGraphic(ImgSwords, true, true, 11, 23);

      addAnimation("bloody", [1]);
      if(player.bloody)
        play("bloody");

      height = 20;
    }

    override public function update():void {
      if(x < -width) {
        x = FlxG.camera.width;
      } else if (x > FlxG.camera.width + width) {
        x = -width;
      }

      super.update();
    }

    public function rest():void {
      velocity.x = velocity.y = angularVelocity = angle = 0;
    }
  }
}
