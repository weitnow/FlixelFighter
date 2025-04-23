package gameObjects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;


class Fighter extends FlxSprite
{

    override public function new(x:Float, y:Float)
    {
        super(x, y);
		// loadGraphic("assets/images/aseprite/debug32x32.png", true, 32, 32);
		makeGraphic(32, 32, 0xFF38AF6A); // Placeholder for player sprite
        

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