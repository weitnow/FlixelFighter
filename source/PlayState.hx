package;

import entities.Character;
import flixel.FlxG;
import flixel.FlxState;
import gameObjects.Fighter;
import kec.KecAseSprite;

class PlayState extends FlxState
{
	
	public var p1:Character;
	public var p2:Fighter;
	public var p3:KecAseSprite;



	override public function create()
	{
		super.create();
			
		// set camera color
		//FlxG.camera.bgColor = 0xFFCFF10E;
		// FlxG.camera.height = 72;

		bgColor = 0xFFA0A5AD;

		// p1 = new Character(20, 100);
		// add(p1);
		// p1.playAnimation("B Move");



		// p2 = new Fighter(120, 100);
		// add(p2);

		p3 = new KecAseSprite(10, 10);
		// check current animation name and current frame
		p3.loadAnims("gbFighter");
		p3.animation.play("B Move");
		p3.animation.timeScale = 0.4;
		add(p3);

	



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
