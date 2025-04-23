package entities;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class Character extends FlxSpriteGroup
{



    public function new(X:Float, Y:Float)
    {
        super(X, Y);

        // Load the player sprite
        var fighterSprite:FlxSprite = new FlxSprite(0, 0);
        fighterSprite.makeGraphic(32, 32, FlxColor.RED); // Placeholder for player sprite
        add(fighterSprite);
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