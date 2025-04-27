package entities;

import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxAsepriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.utils.Assets;

typedef ColBoxData = {
    var offsetX:Int;
    var offsetY:Int;
    var width:Int;
    var height:Int;
    var frame:Int; // The frame this hitbox/hurtbox is active on.  Renamed from activeFrame
    var damage:Int;
};

typedef AttackData = {
    var hurtboxes:Array<ColBoxData>;
    var hitboxes:Array<ColBoxData>;
};

class Character extends FlxSpriteGroup {
    // Sprites
	public var fighterSprite:FlxSprite;

	// Animations
    var animNames:Array<String>;

    // Collision boxes
    public var hurtboxes:Array<FlxSprite>; // These will now be created *once*
    public var hitboxes:Array<FlxSprite>;   // and their visibility toggled.

    // Attack data.  Use a Map (Dictionary) for efficient lookup.
    public var attackData:Map<String, AttackData>;

    // Current attack name
    public var currentAttackName:String;

    //Added state machine
    public var state:CharacterState;

    // A map to store the actual FlxSprite objects for the collision boxes,
    // so we can easily show/hide them.  Key is a combination of
    // animation name and frame number and box type (e.g., "Idle_0_hurtbox_0").
    var collisionBoxSprites:Map<String, FlxSprite>;

    public function new(X:Float, Y:Float) {
        super(X, Y);

        // Initialize sprites
		fighterSprite = new FlxSprite(0, 0);
		add(fighterSprite);

		// Initialize data structures
		hurtboxes = [];
		hitboxes = [];
		attackData = new Map<String, AttackData>();
        animNames = [];
        collisionBoxSprites = new Map<String, FlxSprite>(); // Initialize the map!

        //Set default state
        state = CharacterState.IDLE;

        // Initialize animations and attack data.
        init();
    }

    private function init():Void {
        loadAnims();
        loadAttackData();
        createCollisionBoxes(); // Create ALL collision boxes up front.
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        updateCollisionBoxes();
    }

    override public function destroy():Void {
		fighterSprite = FlxDestroyUtil.destroy(fighterSprite);
        for (box in hurtboxes)
            FlxDestroyUtil.destroy(box);
        for (box in hitboxes)
            FlxDestroyUtil.destroy(box);
        // Iterate through the keys of the map, and use the keys to get values.
        for (key in collisionBoxSprites.keys()) {
            FlxDestroyUtil.destroy(collisionBoxSprites.get(key));
        }
        hurtboxes = null;
        hitboxes = null;
		attackData = null;
        animNames = null;
        collisionBoxSprites = null; // Clear the map.
        super.destroy();
    }

    function loadAnims() {
        if (!Assets.exists("assets/images/aseprite/gbFighter.png") || !Assets.exists("assets/images/aseprite/gbFighter.json")) {
            trace("Error: gbFighter assets not found!");
            return;
        }

        FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(fighterSprite, "assets/images/aseprite/gbFighter.png", "assets/images/aseprite/gbFighter.json");

		animNames = fighterSprite.animation.getNameList();

		playAnimation("B Move");
    }

    public function playAnimation(name:String, ?force:Bool = false):Void {
        if (animNames.indexOf(name) != -1) {
            fighterSprite.animation.play(name, force);
            fighterSprite.animation.timeScale = 0.5;
            currentAttackName = name;
        } else {
            trace('Animation "$name" not found.');
        }
    }

    function loadAttackData():Void {
        attackData["Idle"] = {
            hurtboxes: [
				{
					offsetX: 0,
					offsetY: 0,
					width: 5,
					height: 5,
					frame: 1,
					damage: 0
				},
            ],
            hitboxes: []
        };
        attackData["Walk"] = {
            hurtboxes: [
                {offsetX: 0, offsetY: 0, width: 30, height: 50, frame: 1, damage: 0},
            ],
            hitboxes: []
        };
        attackData["Punch"] = {
            hurtboxes: [
                {offsetX: 0, offsetY: 0, width: 30, height: 50, frame: 1, damage: 0},
            ],
            hitboxes: [
                {offsetX: 30, offsetY: 10, width: 20, height: 20, frame: 2, damage: 10}
            ]
        };
        attackData["B Move"] = {
                hurtboxes: [
                    {
					offsetX: 0,
					offsetY: 0,
					width: 5,
					height: 5,
					frame: 42,
					damage: 10
                    }
                ],
                hitboxes: [
                    {
					offsetX: 10,
					offsetY: 10,
					width: 5,
					height: 5,
					frame: 42,
					damage: 10
                    }
                ]
            };
    }

    function createCollisionBoxes():Void {
        // Clear any existing collision boxes (though this should be empty the first time)
        for (box in hurtboxes) {
            remove(box);
            FlxDestroyUtil.destroy(box);
        }

        hurtboxes = [];
        hitboxes = [];
        collisionBoxSprites.clear(); // Clear the map

        // Iterate through all attack data and create sprites for all defined boxes.
        for (animName => data in attackData) {
            for (i => hurtboxData in data.hurtboxes) {
                createCollisionBoxSprite(animName, hurtboxData, FlxColor.GREEN, "hurtbox", i);
            }
            for (i => hitboxData in data.hitboxes) {
                createCollisionBoxSprite(animName, hitboxData, FlxColor.RED, "hitbox", i);
            }
        }
    }

    function createCollisionBoxSprite(animName:String, data:ColBoxData, color:FlxColor, type:String, index:Int):Void {
        var key = getCollisionBoxKey(animName, data.frame, type, index); // Unique key
        var box = new FlxSprite(data.offsetX, data.offsetY);
        box.makeGraphic(data.width, data.height, color);
		box.alpha = 0.0;
        box.exists = true;
        box.immovable = true;
        box.active = false; // Start as inactive.
        add(box);
        collisionBoxSprites[key] = box; // Store in the map
        if (type == "hurtbox")
            hurtboxes.push(box);
        else
            hitboxes.push(box);
    }

    function updateCollisionBoxes():Void {
        var currentFrame = fighterSprite.animation.frameIndex;
        var currentAnimName = currentAttackName;

        // Hide all collision boxes first.
        for (key in collisionBoxSprites.keys()) { // Changed to iterate over keys
            collisionBoxSprites.get(key).active = false;
			collisionBoxSprites.get(key).alpha = 0.0; // Hide it.

        }

        // Then, show only the relevant ones for the current animation and frame.
        if (attackData.exists(currentAnimName)) { // Check if the current animation has attack data.
            var data = attackData.get(currentAnimName);

            // Show hurtboxes
            for (i => hurtboxData in data.hurtboxes) {
                if (hurtboxData.frame == currentFrame) {
                    var key = getCollisionBoxKey(currentAnimName, currentFrame, "hurtbox", i);
                    if (collisionBoxSprites.exists(key)) {
                        var box = collisionBoxSprites.get(key);
                         box.x = fighterSprite.x + hurtboxData.offsetX;
                         box.y = fighterSprite.y + hurtboxData.offsetY;
                        box.active = true; // Show it.
						box.alpha = 0.5; // Set alpha to 0.5 for visibility.
                    }
                }
            }
            //show hitboxes
             for (i => hitboxData in data.hitboxes) {
                if (hitboxData.frame == currentFrame) {
                    var key = getCollisionBoxKey(currentAnimName, currentFrame, "hitbox", i);
                    if (collisionBoxSprites.exists(key)) {
                        var box = collisionBoxSprites.get(key);
                        box.x = fighterSprite.x + hitboxData.offsetX;
                        box.y = fighterSprite.y + hitboxData.offsetY;
                        box.active = true; // Show it.
						box.alpha = 0.5; // Set alpha to 0.5 for visibility.
                    }
                }
            }
        }
    }

    function getCollisionBoxKey(animName:String, frame:Int, type:String, index:Int):String {
        return animName + "_" + frame + "_" + type + "_" + index;
    }

    //Added an enum for character states
}

enum CharacterState {
    IDLE;
    WALK;
    PUNCH;
}
