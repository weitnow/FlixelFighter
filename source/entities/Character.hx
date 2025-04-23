package entities;

import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxAsepriteUtil;
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

	// animations
	var animList:Array<FlxAnimation>;

	// collisionboxes
	public var hurtboxes:Array<FlxSprite>;
	public var hitboxes:Array<FlxSprite>;
	public var attackData:Map<String, {hurtboxes:Array<HurtboxData>, hitboxes:Array<HitboxData>}>; 

    public function new(X:Float, Y:Float)
    {
        super(X, Y);

        // Load the player sprite
		fighterSprite = new FlxSprite(0, 0); // Placeholder for player sprite, will be loaded with loadAnims()
        add(fighterSprite);

		// Load the weapon sprite
		weaponSprite = new FlxSprite(32, 0);
		weaponSprite.makeGraphic(16, 16, FlxColor.RED); // Placeholder for weapon sprite
		add(weaponSprite);

		// Initialize the collisionboxes
		hurtboxes = [];
		hitboxes = [];
		attackData = [
			"Idle" => {
				hurtboxes: [
					{
						offsetX: 0,
						offsetY: -32,
						width: 32,
						height: 32
					},
					{
						offsetX: 32,
						offsetY: 0,
						width: 32,
						height: 32
					}
				],
				hitboxes: []
			},
			"B Move" => {
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

		loadAnims();
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
		var currentAttack = attackData.get(fighterSprite.animation.name);
		
		if (currentAttack == null)
			return; // No attack data for this animation

		for (hurtboxData in currentAttack.hurtboxes)
		{
			var hurtbox = new FlxSprite(hurtboxData.offsetX, hurtboxData.offsetY);
			hurtbox.makeGraphic(hurtboxData.width, hurtboxData.height, FlxColor.GREEN);
			hurtbox.alpha = 0.5; // Make it semi-transparent for debugging
			hurtbox.exists = true;
			hurtbox.immovable = true; // Hurtboxes don't move
			hurtbox.active = true;
			add(hurtbox); // add to the group for updating position(!) and debug draw
			hurtboxes.push(hurtbox);
		}
	}
	function loadAnims()
	{
		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(fighterSprite, "assets/images/aseprite/gbFighter.png", "assets/images/aseprite/gbFighter.json");

		animList = fighterSprite.animation.getAnimationList();

		var animNames:Array<String> = fighterSprite.animation.getNameList();

		// Set the default animation to "Idle"
		fighterSprite.animation.play("Idle");
	}
}