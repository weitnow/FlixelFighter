package;

import entities.Character;
import flixel.FlxG;
import flixel.FlxState;
import gameObjects.Fighter;


class PlayState extends FlxState
{
	
	var p1:Character;
	var p2:Fighter;



	override public function create()
	{
		super.create();
			
		// set camera color
		//FlxG.camera.bgColor = 0xFFCFF10E;
		// FlxG.camera.height = 72;

		//bgColor = 0xFFE68EF8;

		p1 = new Character(20, 100);
		add(p1);

		p2 = new Fighter(120, 100);
		add(p2);


	
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
