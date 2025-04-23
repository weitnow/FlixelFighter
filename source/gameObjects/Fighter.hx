package gameObjects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;


class Fighter extends FlxSprite
{

public var testgroup:FlxGroup;

    override public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic("assets/images/aseprite/debug32x32.png", true, 32, 32); 
        createSprite();

    }

    function createSprite():Void
    {
        var test:FlxSprite = new FlxSprite(20, 10);
        test.makeGraphic(10, 10, 0xFFAF8F38); 

        testgroup = new FlxGroup();
        testgroup.add(test);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed); 
    }
    
    override public function destroy():Void
    {
        super.destroy();
    }

}