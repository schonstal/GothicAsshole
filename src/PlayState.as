package
{
  import org.flixel.*;
  import org.flixel.plugin.photonstorm.*;

  public class PlayState extends FlxState
  {
    [Embed(source='../data/music.swf', symbol='castlestep.wav')] private var CastleStep:Class;

    public var player:Player;

    public var ground:FlxObject;
    public var enemies:FlxGroup;
    public var spikes:FlxGroup;
    public var door:DoorSprite;

    private var _emitters:FlxGroup;
    private var arrow:ArrowSprite;

    private var _skulls:FlxGroup; 
    private var _skullFlames:FlxGroup; 
    private var _ghosts:FlxGroup;

    private var _vial:VialSprite;

    public var bats:Number = 20;
    
    private var _droplets:Number = 0;
    private var _dropRequirement:Number = 45;
    private var _won:Boolean = false;

    private var _mostRecentScore:Number = 0;

    public static const GRAVITY:Number = 600;
    public static const CLEAR_AREA:Number = 100;
    public static const SPIKE_VARIANCE:Number = 6;

    override public function create():void {
      if(!GameTracker.playedMusic) {
        FlxG.playMusic(CastleStep);
        GameTracker.playedMusic = true;
      }

      _mostRecentScore = GameTracker.score;

      var bg:BackgroundSprite = new BackgroundSprite();
      add(bg);

      door = new DoorSprite();
      add(door);

      player = new Player(FlxG.camera.width/2,15);
      add(player);

      ground = new FlxObject(-50, FlxG.camera.height, FlxG.camera.width+100, 100);
      ground.immovable = true;
      add(ground);

      _dropRequirement += FlxG.level * 5;

      var enemy:EnemySprite;
      enemies = new FlxGroup();
      for(var i:Number = 1; i <= (FlxG.level < 10 ? bats - FlxG.level : 10); i++) {
        enemy = new EnemySprite(Math.random() * (FlxG.camera.width-100)+50, (Math.random() * (FlxG.camera.height - CLEAR_AREA)) + CLEAR_AREA - 40);
        enemies.add(enemy);
      }
      add(enemies);

      _skullFlames = new FlxGroup();
      add(_skullFlames);

      var skull:SkullSprite;
      _skulls = new FlxGroup();
      for(i = 0; i < FlxG.level-1; i++) {
        skull = new SkullSprite(Math.random() * (FlxG.camera.width-100)+50, (Math.random() * (FlxG.camera.height - CLEAR_AREA)) + CLEAR_AREA - 50);
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

      _ghosts = new FlxGroup;
      var ghost:GhostSprite = new GhostSprite();
      _ghosts.add(ghost);
      add(_ghosts);

      //HUD
      _vial = new VialSprite();
      _vial.vialCallback = function():uint {
        return 100 - Math.floor(((GameTracker.score-_mostRecentScore)/_dropRequirement)*100) as uint;
      }
      add(_vial);

      arrow = new ArrowSprite(player);
      add(arrow);

//      FlxG.visualDebug = true;
    }

    override public function update():void {
      if(FlxG.collide(player, ground)) {
        if(FlxG.overlap(player, door) && _won) {
          FlxG.level++;
          FlxG.switchState(new PlayState());
        }
      }

      FlxG.overlap(player, _skulls, function(player:Player, skull:SkullSprite):void {
        if(skull.touching|FlxObject.UP && player.velocity.y > 0 && !player.killed) {
          if(!skull.awake) {
            skull.wakeUp();
            skull.moveCallback = function():void {
              FlxVelocity.moveTowardsObject(skull, player, 50);
            }
            skull.poofCallback = function():void {
              (_skullFlames.recycle(FlameSprite) as FlameSprite).create(skull.x, skull.y);
            }
            player.bounce();
          }
        }
        if(skull.awake) {
          player.killed = true;
        }
      });

      FlxG.overlap(player, _ghosts, function(p:Player, ghost:GhostSprite):void {
        p.killed = true;
      });

      FlxG.overlap(player, spikes, function(player:Player, spike:SpikeSprite):void {
        var gog:GameOverGroup = new GameOverGroup();
        add(gog);
        player.die();
        spike.play("bloody");

        for each(var skull:SkullSprite in _skulls.members) {
          skull.awake = false;
        }

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
          
          _droplets += 5;
          var emitter:FlxEmitter = new FlxEmitter();
          //Use recycling here later, this might get pretty slow
          for(var i:int = 0; i < 5; i++) {
            var p:GibParticle = new GibParticle();
            p.trailCallback = trailCallbackGenerator();
            p.follow(player);
            emitter.add(p);
          }
          emitter.gravity = GRAVITY;
          emitter.at(enemy);
          _emitters.add(emitter);
          emitter.start();
          emitter.setYSpeed(-300, -200);
        }
      });

      if(_droplets >= _dropRequirement && !_won)
        win();

      super.update();
    }

    public function win():void {
      _won = true;
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
