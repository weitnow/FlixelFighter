package entities;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

typedef HurtboxData =
{
	var offsetX:Int;
	var offsetY:Int;
	var width:Int;
	var height:Int;
}

typedef HitboxData =
{
	var offsetX:Int;
	var offsetY:Int;
	var width:Int;
	var height:Int;
	var activeFrame:Int;
	var damage:Int;
}

typedef AttackData =
{
	var hurtboxes:Array<HurtboxData>;
	var hitboxes:Array<HitboxData>;
} 

class Character extends FlxSpriteGroup
{

	// sprites
	public var fighterSprite:FlxSprite;
	public var weaponSprite:FlxSprite;

	// collisionboxes
	public var hurtboxes:Array<FlxSprite>;
	public var hitboxes:Array<FlxSprite>;
	public var attackData:Map<String, {hurtboxes:Array<HurtboxData>, hitboxes:Array<HitboxData>}>; 

    public function new(X:Float, Y:Float)
    {
        super(X, Y);

        // Load the player sprite
		fighterSprite = new FlxSprite(0, 0);
		fighterSprite.makeGraphic(32, 32, FlxColor.BLUE); // Placeholder for player sprite
        add(fighterSprite);
		// Load the weapon sprite
		weaponSprite = new FlxSprite(32, 0);
		weaponSprite.makeGraphic(16, 16, FlxColor.BLUE); // Placeholder for weapon sprite
		add(weaponSprite);

		// Initialize the collisionboxes
		hurtboxes = [];
		hitboxes = [];
		attackData = [
			"idle" => {
				hurtboxes: [
					{
						offsetX: 0,
						offsetY: -32,
						width: 32,
						height: 32
					}
				],
				hitboxes: []
			},
			"punch" => {
				hurtboxes: [
					{
						offsetX: 10,
						offsetY: 0,
						width: 20,
						height: 50
					}
				],
				hitboxes: [
					{
						offsetX: 30,
						offsetY: 10,
						width: 20,
						height: 20,
						activeFrame: 3,
						damage: 10
					}
				]
			}
		];

		createHurtboxes();
	}

    override public function update(elapsed:Float):Void
    {
		super.update(elapsed);
    }

    override public function destroy():Void
    {
        super.destroy();
    }
	public function createHurtboxes():Void
	{
		/*
			var test:FlxSprite = new FlxSprite(0, -32);
			test.makeGraphic(32, 32, FlxColor.RED);
			add(test);
		 */

		var currentAttack = attackData.get("idle"); // attackData.get(animation.name);

		if (currentAttack == null)
			return; // Todo: Handle missing animation data

		for (hurtboxData in currentAttack.hurtboxes)
		{
			var hurtbox = new FlxSprite(hurtboxData.offsetX, hurtboxData.offsetY);
			hurtbox.makeGraphic(hurtboxData.width, hurtboxData.height, FlxColor.GREEN);
			hurtbox.alpha = 0.5; // Make it semi-transparent for debugging
			hurtbox.exists = true;
			hurtbox.immovable = true; // Hurtboxes don't move
			hurtbox.active = true;
			add(hurtbox);
			hurtboxes.push(hurtbox);
		}
	} 
}