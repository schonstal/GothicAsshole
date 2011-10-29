package
{
  import org.flixel.*;

  public class MenuState extends FlxState
  {
    override public function create():void {
      var button:FlxButton = new StartButton(45,202);
      add(button);

      FlxG.mouse.show();
    }

    override public function update():void {
      super.update();
    }
  }
}
