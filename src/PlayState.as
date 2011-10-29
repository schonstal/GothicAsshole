package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    public var ground:FlxObject;
    public var enemies:FlxGroup;
    public var spikes:FlxGroup;

    private var _emitters:FlxGroup;

    private var _scoreText:FlxText;
    private var _highScoreText:FlxText;

    public static const GRAVITY:Number = 600;
    public static const CLEAR_AREA:Number = 100;

    override public function create():void {
      player = new Player(15,15);
      add(player);

      ground = new FlxObject(0, FlxG.camera.height, FlxG.camera.width, 100);
      ground.immovable = true;
      add(ground);

      var enemy:EnemySprite;
      enemies = new FlxGroup();
      for(var i:Number = 1; i < 30; i++) {
        enemy = new EnemySprite(Math.random() * FlxG.camera.width, (Math.random() * (FlxG.camera.height - CLEAR_AREA)) + CLEAR_AREA - SpikeSprite.HEIGHT);
        enemies.add(enemy);
      }
      add(enemies);

      var spike:SpikeSprite;
      spikes = new FlxGroup();
      for(i = 0; i < FlxG.camera.width/SpikeSprite.WIDTH; i++) {
        spike = new SpikeSprite(20*i, FlxG.camera.height - SpikeSprite.HEIGHT + Math.random()*4);
        spikes.add(spike);
      }
      add(spikes);

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
      FlxG.overlap(player, spikes, function(player:Player, spike:SpikeSprite):void {
        var gog:GameOverGroup = new GameOverGroup();
        add(gog);
        player.die();
        spike.play("bloody");

        var emitter:FlxEmitter = new FlxEmitter();
        //Use recycling here later, this might get pretty slow
        for(var i:int = 0; i < 50; i++) {
          var p:GibParticle = new GibParticle();
          p.trailCallback = trailCallbackGenerator();
          emitter.add(p);
        }
        emitter.bounce = 0.5;
        emitter.particleDrag = new FlxPoint(30, 0.2);
        emitter.gravity = GRAVITY;
        emitter.at(player);
        _emitters.add(emitter);
        emitter.start();
        emitter.setYSpeed(-400, -100);
        emitter.setXSpeed(-100, 100);
      });

      FlxG.overlap(_emitters, spikes, function(emitter:GibParticle, spike:SpikeSprite):void {
        spike.play("bloody");
      });

      FlxG.collide(_emitters, ground);

      FlxG.overlap(player, enemies, function(player:Player, enemy:EnemySprite):void {
        if(enemy.touching|FlxObject.UP && player.velocity.y > 0) {
          enemy.exists = false;
          player.bounce();
          player.play("bloody");

          var emitter:FlxEmitter = new FlxEmitter();
          //Use recycling here later, this might get pretty slow
          for(var i:int = 0; i < 5; i++) {
            var p:GibParticle = new GibParticle();
            p.trailCallback = trailCallbackGenerator();
            p.follow(player);
            emitter.add(p);
          }
//          emitter.gravity = GRAVITY;
          emitter.particleDrag = new FlxPoint(50,50);
          emitter.at(enemy);
          _emitters.add(emitter);
          emitter.start();
          emitter.setYSpeed(-100, 100);
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
      var trailThreshold:Number = 0.05;

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
