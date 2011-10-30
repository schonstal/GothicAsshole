package
{
  import org.flixel.*;

  public class TransitionSprite extends FlxSprite
  {
//    [Embed(source='../data/transition.png')] private var ImgTransition:Class;

    public var _hasTransitioned:Boolean = false;

    public function TransitionSprite():void {
      super(-1000,0);
//      loadGraphic(ImgTransition, true, true, 1000, 600);
      makeGraphic(1000,600,0xffff00ff);
      velocity.x = 600;
    }

    public function create():void {
      x = -1000;
      _hasTransitioned = false;
    }

    public override function update():void {
      if(transitionReady && !_hasTransitioned) {
        FlxG.switchState(new PlayState());
        _hasTransitioned = true;
      }
      
      super.update();
    }

    public function get transitionReady():Boolean {
      return x > FlxG.width - width;
    }

    public function get done():Boolean {
      return x > FlxG.width;
    }

    override public function destroy():void {}
  }
}
