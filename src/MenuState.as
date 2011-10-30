package
{
  import org.flixel.*;

  public class MenuState extends FlxState
  {
    override public function create():void {
      var button:FlxButton = new StartButton(45,202);
      add(button);

      button.onUp = function():void {
        add(GameTracker.transitionSprite);
      }

      FlxG.mouse.show();
      FlxG.level = 1;
      GameTracker.score = 0;
    }

    override public function update():void {
      if(!GameTracker.api)
          (GameTracker.api = FlxG.stage.addChild(new KongApi()) as KongApi).init();

      super.update();
    }
  }
}
