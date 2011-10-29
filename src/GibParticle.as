package
{
  import org.flixel.*;

  public class GibParticle extends FlxParticle
  {
    [Embed(source='../data/gibs.png')] private var ImgGibs:Class;
    public var onEmitCallback:Function;
    private var _objectToFollow:FlxObject;
    private var _angle:Number;
    private var _amplitude:Number;

    public function GibParticle():void {
      loadGraphic(ImgGibs, true, true, 8, 8);
      exists = false;
      antialiasing = false;
      randomFrame();
    }

    public function follow(objectToFollow:FlxObject):void {
      _objectToFollow = objectToFollow;
    }

    override public function onEmit():void {
      if(onEmitCallback != null) 
        onEmitCallback();
    }

    override public function update():void {
      if(_objectToFollow != null) {
      }
    }
  }
}
