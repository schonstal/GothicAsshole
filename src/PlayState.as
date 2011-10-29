package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    public var ground:FlxObject;
    public var enemies:FlxGroup;

    override public function create():void {
      player = new Player(15,15);
      add(player);

      ground = new FlxObject(0, FlxG.camera.height, FlxG.camera.width, 100);
      ground.immovable = true;
      add(ground);

      var enemy:EnemySprite;
      enemies = new FlxGroup();
      for(var i:Number = 1; i < 50; i++) {
        enemy = new EnemySprite(Math.random() * FlxG.camera.width, Math.random() * FlxG.camera.height);
        enemies.add(enemy);
      }
      add(enemies);

      FlxG.visualDebug = true;
    }

    override public function update():void {
      FlxG.collide(player, ground);

      FlxG.overlap(player, enemies, function(player:Player, enemy:EnemySprite):void {
        if(enemy.touching|FlxObject.UP && player.velocity.y > 0) {
          enemy.exists = false;
          player.velocity.y = -600;
        }
        //do the bouncy bounce
      });

      super.update();
    }
  }
}
