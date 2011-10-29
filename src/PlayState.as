package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    public var ground:FlxObject;
    public var enemies:FlxGroup;

    private var _scoreText:FlxText;

    override public function create():void {
      FlxG.worldBounds = new FlxRect(0,0,400,900);
      player = new Player(15,15);
      add(player);

      FlxG.camera.bounds = FlxG.worldBounds;
      FlxG.camera.follow(player);

      ground = new FlxObject(0, FlxG.worldBounds.height-100, FlxG.camera.width, 100);
      ground.immovable = true;
      add(ground);

      var enemy:EnemySprite;
      enemies = new FlxGroup();
      for(var i:Number = 1; i < 50; i++) {
        enemy = new EnemySprite(Math.random() * FlxG.camera.width, Math.random() * FlxG.worldBounds.height-100);
        enemies.add(enemy);
      }
      add(enemies);

      _scoreText = new FlxText(0,16,FlxG.width, GameTracker.score );
      _scoreText.alignment = "center";
      _scoreText.setFormat("ack");
      _scoreText.scrollFactor.x = _scoreText.scrollFactor.y = 0;
      add(_scoreText);

      FlxG.visualDebug = true;
    }

    override public function update():void {
      FlxG.collide(player, ground, function(player:Player, ground:FlxObject):void {
        FlxG.switchState(new PlayState());
      });

      FlxG.overlap(player, enemies, function(player:Player, enemy:EnemySprite):void {
        if(enemy.touching|FlxObject.UP && player.velocity.y > 0) {
          enemy.exists = false;
          player.bounce();;
        }
      });

      super.update();
    }
  }
}
