package
{
  import org.flixel.*;

  public class HudGroup extends FlxGroup
  {
    private var _vial:VialSprite;
    private var _scoreText:FlxText;
    private var _levelText:FlxText;
    private var _scoreSprite:FlxSprite;
    private var _levelSprite:FlxSprite;

    public static const TEXT_COLOR:uint = 0xfffff829;
    public static const SHADOW_COLOR:uint = 0xff000000;

    public function HudGroup():void {
      _vial = new VialSprite();
      add(_vial);

      _scoreSprite = new FlxSprite(5,5);
      _scoreSprite.makeGraphic(16,16,0xffff00ff);
      add(_scoreSprite);

      _scoreText = new FlxText(26,5,FlxG.width - 26, GameTracker.score.toString());
      _scoreText.alignment = "left";
      _scoreText.setFormat("celtic");
      _scoreText.scrollFactor.x = _scoreText.scrollFactor.y = 0;
      _scoreText.shadow = SHADOW_COLOR;
      _scoreText.color = TEXT_COLOR;
      add(_scoreText);

      _levelSprite = new FlxSprite(5,26);
      _levelSprite.makeGraphic(16,16,0xffff00ff);
      add(_levelSprite);

      _levelText = new FlxText(26,26,FlxG.width - 26, FlxG.level.toString());
      _levelText.alignment = "left";
      _levelText.setFormat("celtic");
      _levelText.scrollFactor.x = _levelText.scrollFactor.y = 0;
      _levelText.shadow = SHADOW_COLOR;
      _levelText.color = TEXT_COLOR;
      add(_levelText);
    }

    public override function update():void {
      _scoreText.text = GameTracker.score.toString();
      super.update();
    }
  }
}
