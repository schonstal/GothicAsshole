package
{
  import org.flixel.*;

  public class GameOverGroup extends FlxGroup
  {
    [Embed(source='../data/gameOver.png')] private var ImgGameOver:Class;
    [Embed(source='../data/newRecord.png')] private var ImgNewRecord:Class;

    public function GameOverGroup():void {
      var gameOverSprite:FlxSprite = new FlxSprite(0,0);
      gameOverSprite.scrollFactor.x = gameOverSprite.scrollFactor.y = 0;
      gameOverSprite.loadGraphic(ImgGameOver, true, true, 240, 320);
      add(gameOverSprite);

      //Flixel shadow is only 1 pixel :(
      var t:FlxText = new FlxText(0,120,FlxG.width, Math.floor(GameTracker.score).toString());
      t.alignment = "center";
      t.setFormat("adore");
      t.color = 0xff000000;
      t.size = 24;
      t.scrollFactor.x = t.scrollFactor.y = 0;
      add(t);

      t = new FlxText(-3,117,FlxG.width, Math.floor(GameTracker.score).toString());
      t.alignment = "center";
      t.setFormat("adore");
      t.size = 24;
      t.scrollFactor.x = t.scrollFactor.y = 0;
      add(t);

      t = new FlxText(0,168,FlxG.width, Math.floor(GameTracker.highScore).toString());
      t.alignment = "center";
      t.setFormat("adore");
      t.size = 16;
      t.color = 0xff000000;
      t.scrollFactor.x = t.scrollFactor.y = 0;
      add(t);

      t = new FlxText(-2,166,FlxG.width, Math.floor(GameTracker.highScore).toString());
      t.alignment = "center";
      t.setFormat("adore");
      t.size = 16;
      t.scrollFactor.x = t.scrollFactor.y = 0;
      add(t);

      if(GameTracker.score >= GameTracker.highScore) {
        var newRecordSprite:FlxSprite = new FlxSprite(38,200);
        newRecordSprite.scrollFactor.x = newRecordSprite.scrollFactor.y = 0;
        newRecordSprite.loadGraphic(ImgNewRecord, true, true, 166, 16);
        newRecordSprite.addAnimation("flash", [0,1], 15);
        newRecordSprite.play("flash");
        add(newRecordSprite);
      }
    }

    override public function update():void {
      if(FlxG.keys.justPressed("SPACE")) {
        FlxG.fade(0xff000000, 1, function():void {
          FlxG.switchState(new PlayState());
        });
      }

      super.update();
    }
  }
}
