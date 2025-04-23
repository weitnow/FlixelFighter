package;

import flixel.FlxG;
import flixel.FlxState;
import gameObjects.Fighter;


class PlayState extends FlxState
{
	
	var fighter:Fighter;
	


	override public function create()
	{
		super.create();
			
		// set camera color
		//FlxG.camera.bgColor = 0xFFCFF10E;
		FlxG.camera.height = 72;
		
		//bgColor = 0xFFE68EF8;
		
		fighter = new Fighter(80, 112);
		add(fighter);
		add(fighter.testgroup);	//<-- does not work, shows nothing

	
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
