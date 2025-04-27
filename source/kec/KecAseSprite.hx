package kec;

import flixel.FlxSprite;
import flixel.graphics.FlxAsepriteUtil;
import flixel.math.FlxPoint;
import flixel.util.FlxDirectionFlags;
import openfl.utils.Assets;

class KecAseSprite extends FlxSprite
{
    public static var debugBoundingBoxColor_:Int = 0xFFBB1AB3;
    public static var allowCollisions_: FlxDirectionFlags = FlxDirectionFlags.NONE;

    private static var animationOffsets:Map<String, Map<Int, FlxPoint>> = [
        "Idle" => [
            0 => new FlxPoint(0, 0),
        ],
        "Walk" => [
            0 => new FlxPoint(0, 0),
            1 => new FlxPoint(0, 0),
        ],
        "B Move" => [
            0 => new FlxPoint(0, 0),
            1 => new FlxPoint(0, 0),
            2 => new FlxPoint(0, 0),
            3 => new FlxPoint(0, 0),
            4 => new FlxPoint(0, 0),
            5 => new FlxPoint(0, 0),
            6 => new FlxPoint(0, 0),
            7 => new FlxPoint(0, 0),
            42 => new FlxPoint(0, 0),
            43 => new FlxPoint(-1, 0),
        ],
    ];

    private var currentOffset:FlxPoint;

    public function new(X:Float, Y:Float)
    {
        super(X, Y);
        debugBoundingBoxColor = debugBoundingBoxColor_;
        allowCollisions = allowCollisions_;
        currentOffset = new FlxPoint(0, 0);

    }

    public function loadAnims(fileName:String):Void {
        if (!Assets.exists("assets/images/aseprite/" + fileName + ".png") || !Assets.exists("assets/images/aseprite/" + fileName + ".json")) {
            throw "Error: " + fileName + " assets not found!";
                
        }
        FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(this, "assets/images/aseprite/" + fileName + ".png", "assets/images/aseprite/" + fileName + ".json");
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
  
        currentOffset = animationOffsets.get(animation.name).get(animation.frameIndex);
        offset.x = currentOffset?.x ?? 0; // Default offset is 0
        offset.y = currentOffset?.y ?? 0; // Default offset is 0


        
    }

}

