package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    public var ground:FlxObject;
    public var enemies:FlxGroup;

    private var _emitters:FlxGroup;

    private var _scoreText:FlxText;
    private var _highScoreText:FlxText;

    public static const GRAVITY:Number = 600;

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

      _emitters = new FlxGroup();
      add(_emitters);

      GameTracker.score = 0;

      _scoreText = new FlxText(0,16,FlxG.width, GameTracker.score.toString());
      _scoreText.alignment = "left";
      _scoreText.setFormat("adore");
      _scoreText.scrollFactor.x = _scoreText.scrollFactor.y = 0;
      add(_scoreText);

      _highScoreText = new FlxText(0,16,FlxG.width, GameTracker.highScore.toString());
      _highScoreText.alignment = "right";
      _highScoreText.setFormat("adore");
      _highScoreText.scrollFactor.x = _highScoreText.scrollFactor.y = 0;
      add(_highScoreText);

//      FlxG.visualDebug = true;
    }

    override public function update():void {
      FlxG.collide(player, ground, function(player:Player, ground:FlxObject):void {
        var gog:GameOverGroup = new GameOverGroup();
        add(gog);
        player.die();
      });

      FlxG.overlap(player, enemies, function(player:Player, enemy:EnemySprite):void {
        if(enemy.touching|FlxObject.UP && player.velocity.y > 0) {
          enemy.exists = false;
          player.bounce();

          var emitter:FlxEmitter = new FlxEmitter();
          //Use recycling here later, this might get pretty slow
          for(var i:int = 0; i < 10; i++) {
            var p:GibParticle = new GibParticle();
            p.trailCallback = trailCallbackGenerator();
            p.follow(player);
            emitter.add(p);
          }
          emitter.bounce = 1;
          emitter.gravity = GRAVITY;
          emitter.at(enemy);
          _emitters.add(emitter);
          emitter.start();
          emitter.setYSpeed(-400, -200);
        }
      });

      _scoreText.text = GameTracker.score.toString();
      _highScoreText.text = GameTracker.highScore.toString();

      super.update();
    }

    public function trailCallbackGenerator():Function {
      var bloodTrail:FlxGroup = new FlxGroup();
      add(bloodTrail);

      var trailTimer:Number = 0;
      var trailThreshold:Number = 0.1;

      return function(X:Number, Y:Number):void {
        trailTimer += FlxG.elapsed;
        if(trailTimer > trailThreshold) {
          var g:GibTrailSprite = bloodTrail.recycle(GibTrailSprite) as GibTrailSprite;
          g.create(X,Y);
          trailTimer = 0;
        }
      }
    }
  }
}
