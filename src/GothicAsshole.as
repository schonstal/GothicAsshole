package
{
  import org.flixel.*;
  [SWF(width="800", height="600", backgroundColor="#000000")]
  [Frame(factoryClass="Preloader")]

  public class GothicAsshole extends FlxGame
  {
    [Embed(source = '../data/celtic-bit.ttf', fontFamily="celtic", embedAsCFF="false")] public var AdoreFont:String;
    public function GothicAsshole() {
      FlxG.level = 0;
      super(400,300,MenuState,2);
    }
  }
}
