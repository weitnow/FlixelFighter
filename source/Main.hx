package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.debug.watch.Tracker;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import openfl.display.Sprite;


class Main extends Sprite
{

	// define screen size constants
	public static inline var SCREEN_WIDTH:Int = 256;
	public static inline var SCREEN_HEIGHT:Int = 144;

	public function new()
	{
		super();
		
		addChild(new FlxGame(256, 144, PlayState));
		FlxG.scaleMode = new PixelPerfectScaleMode();

		
	}
}
