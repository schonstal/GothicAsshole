package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    public var ground:FlxObject;
    public var enemies:FlxGroup;
    public var spikes:FlxGroup;

    private var _emitters:FlxGroup;
    private var arrow:ArrowSprite;

    private var _skulls:FlxGroup; 

    private var _scoreText:FlxText;
    private var _highScoreText:FlxText;
    public var bats:Number = 5;

    public static const GRAVITY:Number = 600;
    public static const CLEAR_AREA:Number = 100;
    public static const SPIKE_VARIANCE:Number = 6;

    override public function create():void {
      var bg:BackgroundSprite = new BackgroundSprite();
      add(bg);

      player = new Player(FlxG.camera.width/2,15);
      add(player);

      arrow = new ArrowSprite(player);
      add(arrow);

      ground = new FlxObject(-50, FlxG.camera.height, FlxG.camera.width+100, 100);
      ground.immovable = true;
      add(ground);

      var enemy:EnemySprite;
      enemies = new FlxGroup();
      for(var i:Number = 1; i <= bats; i++) {
        enemy = new EnemySprite(Math.random() * (FlxG.camera.width-100)+50, (Math.random() * (FlxG.camera.height - CLEAR_AREA)) + CLEAR_AREA - SpikeSprite.HEIGHT);
        enemies.add(enemy);
      }
      add(enemies);

      var skull:SkullSprite;
      _skulls = new FlxGroup();
      for(i = 0; i <= 1; i++) {
        skull = new SkullSprite(Math.random() * (FlxG.camera.width-100)+50, (Math.random() * (FlxG.camera.height - CLEAR_AREA)) + CLEAR_AREA - SpikeSprite.HEIGHT);
        _skulls.add(skull);
      }
      add(_skulls);

      var spike:SpikeSprite;
      spikes = new FlxGroup();
      for(i = 0; i < FlxG.camera.width/SpikeSprite.WIDTH; i++) {
        spike = new SpikeSprite(20*i, FlxG.camera.height - SpikeSprite.HEIGHT + Math.random()*SPIKE_VARIANCE);
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

      FlxG.debug = true;
      FlxG.visualDebug = true;
    }

    override public function update():void {
      FlxG.collide(player, ground);

      FlxG.overlap(player, _skulls, function(player:Player, skull:SkullSprite):void {
        if(skull.touching|FlxObject.UP && player.velocity.y > 0 && !player.killed) {
          if(!skull.awake) {
            skull.wakeUp();
            skull.moveCallback = function():void {
              FlxVelocity.moveTowardsObject(skull, player, 50);
            }
            player.bounce();
          }
        } else if(skull.awake) {
          player.killed = true;
        }
      });

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
        if(spike.solid)
          spike.play("bloody");
        spike.bloody = true;
      });

      FlxG.collide(_emitters, ground);

      FlxG.overlap(player, enemies, function(player:Player, enemy:EnemySprite):void {
        if(enemy.touching|FlxObject.UP && player.velocity.y > 0 && !player.killed) {
          enemy.exists = false;
          player.bounce();
          player.play("bloody");
          
          bats--;
          if(bats <= 0)
            win();

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

//      if(FlxG.keys.P)
//        win();

      super.update();
    }

    public function win():void {
      FlxG.timeScale = 0.1;
      FlxG.flash(0xffffffff, 0.2, function():void {
        FlxG.timeScale = 1;
        for each(var spike:SpikeSprite in spikes.members) {
          spike.retract();
        }
      });
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
