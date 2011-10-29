package
{
  import org.flixel.*;

  public class EnemySprite extends FlxSprite
  {
    [Embed(source='../data/enemy.png')] private var ImgEnemy:Class;

    public function EnemySprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      loadGraphic(ImgEnemy, true, true, 16, 16);
      height = 8;
    }
  }
}
