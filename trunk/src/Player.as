package
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import org.flixel.*;
	//import org.flixel.fefranca.debug.FlxSpriteDebug;

	public class Player extends FlxSprite
	{
		[Embed(source = "../data/temp/spaceman_new_thin.png")] private var ImgSpaceman:Class;
		[Embed(source="../data/temp/player.png")] private var ImgPlayer:Class;
		
		private var size:uint = 50;	
		
		private var jumpPower:int = 6000;
		private var jumpFromWallPower:uint = 550;// 1000;
		private var bUp:Boolean;
		private var bDown:Boolean;
		private var restart:Number;
		
		private var hooks:Array;
		private var curHook:uint;
		public var prevHook:uint;	
		private var bCanHook:Boolean;
		
		private var bIsSwinging:Boolean;
		
		private var runSpeed:uint = 6 * size; //18*size = snel
		private var hookVel:int = 4 * runSpeed;
		
		//private var swingSpeed:uint = 1.750 * runSpeed; //1.30 * runSpeed bij snel
		
		private var jumpTime:Number;
		private var maxJumpTime:Number = 0.25;
		
		private var fallAccel:Number = 32 * size;
		
		private var bWalling:Boolean;
		private var bBoosting:Boolean;
		
		private var playState:PlayState;
		
		
		
		
		public var bOnDownSlope:Boolean;
		
		private var switchToLevelId:uint;
		private var bHitDoor:Boolean;
		
		private var trail:FlxEmitter;
		private var trail2:FlxEmitter;
		private var trailYoffset:uint;
		private var trail2Yoffset:uint;
		
		public const maxSwingVelocity:uint = 2.00 * runSpeed;
		public const maxRunVelocity:uint = 1.50 * runSpeed;
		public const maxBoostVelocity:uint = 2.00 * runSpeed;		
		public const defaultRunVelocity:uint = runSpeed;
		
		public var currentPush:Number; // the force applied by input
		public const defaultPush:Number = 20 * size;
		public const slowPush:Number = 1.0 * size;
		
		static public const ONGROUND:uint = 0;
		static public const ONWALL:uint = 1;
		static public const ONSLOPEDOWN:uint = 2;
		static public const ONSLOPEUP:uint = 3;
		static public const INAIR:uint = 4;
		static public const SWINGING:uint = 5;
		
		public var status:uint = INAIR;
		
		private var switchToAirCntDwn:Number = 0;
		
		//public var progressManager:ProgressManager;
		
		//private var eyeSpr:FlxSprite;
		//private var eyeOffsetX:uint;
		//private var eyeOffsetY:uint;
		
		public function Player(X:int, Y:int)//, hooks:Array)
		{
			super(X, Y);			
			
			//this.createGraphic(16, 32, 0xFF000000);
			
			//eyeOffsetX = 7;
			//eyeOffsetY = 2;
			//eyeSpr = new FlxSprite(X + eyeOffsetX, Y + eyeOffsetY, null);
			//eyeSpr.createGraphic(4, 4, 0xFFFFFFFF);
			
			//this.createGraphic(4, 4, 0x00FFFFFF);
			//loadGraphic(ImgSpaceman,true,true,16,32);
			this.loadGraphic(ImgPlayer, false, true, 25, 50, false);
			restart = 0;
			
			this._curFrame = 0;
			
			jumpTime = 0;
			
			//bounding box tweaks
			width = 21;
			height = 46;
			offset.x = 2;
			offset.y = 4;
			
			//basic player physics
			drag.x = runSpeed * 2;
			
			currentPush = defaultPush;			
			
			acceleration.y = fallAccel;
			
			maxVelocity.x = runSpeed;
			maxVelocity.y = 24 * size;// 800;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("idle_up", [5]);
			addAnimation("run_up", [6, 7, 8, 5], 12);
			addAnimation("jump_up", [9]);
			addAnimation("jump_down", [10]);						
			
			curHook = 0;
			
			if( FlxG.state is PlayState )
				playState = FlxG.state as PlayState
				
			bCanHook = FlxG.progressManager.bUnlockedHook;
		}
		
		public function addToState(state:FlxState):void
		{		
			// Trail emitter
			trail = new FlxEmitter();			
			trail.width = 19;// 10;
			trail.height = 50;// 20;
			trail.y = this.y;
			trail.x = this.x;		
			trail.setRotation(0, 0);			
			trail.delay = 0.01;
			trail.gravity = 100;
			trail.setXVelocity(0);
			trail.setYVelocity(0);					
			//trail.setRotation(45, 45);			
			var arr:Array = new Array();
			for (var i:uint = 0; i < 60; i++)
			{
				arr.push(FlxG.state.add((new PlayerTrailParticle(3.0).createGraphic(6, 6, 0xFF000000))));			
				//arr.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(16, 32, 0x22FFFFFF))));			
			}	
			
			trailYoffset = 0;
			
			// Trail2 emitter
			trail2 = new FlxEmitter();			
			trail2.width = 1;// 10;
			trail2.height = 1;// 32;// 20;
			trail2.y = this.y;
			trail2.x = this.x;		
			trail2.setRotation(0, 0);			
			trail2.delay = 0.01;
			trail2.gravity = 100;
			trail2.setXVelocity(0);
			trail2.setYVelocity(0);					
			//trail2.setRotation(45, 45);			
			var arr2:Array = new Array();
			for (var i2:uint = 0; i2 < 30; i2++)
			{
				//arr2.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(6, 6, 0x66FFFFFF))));			
				//arr2.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(6, 6, 0xFFFF0000))));
				//arr2.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(6, 6, 0x880000FF))));
				//arr.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(16, 32, 0x22FFFFFF))));			
				//arr2.push(FlxG.state.add((new PlayerTrailParticle(8.0).createGraphic(4, 4, 0xFF000000))));
				arr2.push(FlxG.state.add((new PlayerTrailParticle(6.0).createGraphic(25, 50, 0x220000FF))));
			}
			
			trail2Yoffset = 22;		
			state.add(trail2.loadSprites(arr2));
			state.add(trail.loadSprites(arr));
			
			state.add(this);
			//state.add(eyeSpr);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		// UPDATE
		// (called BEFORE collision checks are done)
		override public function update():void
		{				
			//game restart timer
			if(dead)
			{
				restart += FlxG.elapsed;
				if(restart > 2)
					FlxG.switchState(PlayState);
				return;
			}		
			
			// ENTERING DOORS:
			if ( FlxG.keys.justPressed("UP") && bHitDoor )
			{
				( FlxG.state as PlayState ).switchToLevel(switchToLevelId);				
			}
			
			// release swing?
			if ( hooks[prevHook].exists && !FlxG.keys.pressed("C") )
			{
				hooks[prevHook].release();				
			}
			
			if ( !hooks[prevHook].bCollided )
			{
				bIsSwinging = false;				
			}
			
			//MOVEMENT
			// first, set defaults:		
			acceleration.x = 0;
			
			// this is to force the player to "stick" to the ground, you know, with slopes and such.
			if( status == ONGROUND )
				acceleration.y = 4 * fallAccel;	
			else
				acceleration.y = fallAccel;	
						
			// Determine max Velocity:
			currentPush = defaultPush;
			
			if ( bBoosting )
				maxVelocity.x = maxBoostVelocity;			
			else  
			{
				if ( Math.abs(velocity.x) < defaultRunVelocity )
				{		
					maxVelocity.x = Math.max( maxVelocity.x - FlxG.elapsed * 100, defaultRunVelocity);			
				}
				else // gelijk..
				{
					if (velocity.x < 0 && FlxG.keys.LEFT 
						|| velocity.x > 0 && FlxG.keys.RIGHT )
					{
						currentPush = slowPush;
					}
					maxVelocity.x = Math.max( maxVelocity.x - FlxG.elapsed * 100, maxRunVelocity);					
				}
			}
				
			maxVelocity.y = 24 * size;
			drag.x = runSpeed * 2;				
			
			// EMITTERS:
			if ( velocity.length > 50 )
				trail.reset(this.x, this.y);
			else if ( trail.active )
				trail.active = false;
				
			if ( Math.abs(velocity.x) * 0.85 > maxRunVelocity )
				trail2.reset(this.x, this.y);
			else if ( trail2.active )
				trail2.active = false;
				
			trail.gravity = Math.max(0, maxRunVelocity - Math.abs(this.velocity.x));			
			trail2.gravity = trail.gravity;
			
			
			// IF SWINGING:
			if ( hooks[prevHook].exists && hooks[prevHook].bCollided )
			{
				var hook:Hook = hooks[prevHook];
				
				var relX:Number = this.x - hook.x;
            	var relY:Number = this.y - hook.y;
				var ropeAngle:Number = Math.atan2(relY, relX);
				
				status = SWINGING;
				
				bOnDownSlope = false;
				
				// swinging is faster than walking:
				maxVelocity.x = maxSwingVelocity; // Math.min( maxVelocity.x + FlxG.elapsed * 100, maxSwingVelocity );
				
				// Always start swinging at a high speed				
				if ( !bIsSwinging )
				{	
					if ( relX < 0 )
						velocity.x = maxVelocity.x;
					else 
						velocity.x = -maxVelocity.x;
					
					bIsSwinging = true;
				}				
				
				// calculate velocity based on swing physics
				// (copied and edited from flixel.org, original author: Broco)
				if ( ropeAngle < 0 && ( ropeAngle > (0.90 * -Math.PI) && ropeAngle < (0.10 * -Math.PI) ) )
					hook.release();
				else
				{				
					// Convert player velocity to polar coordinates.
					var speedAngle:Number = Math.atan2(this.velocity.y, this.velocity.x);
					var speedMagnitude:Number = Point.distance(new Point(), this.velocity);
					// Convert to polar coordinates relative to the rope instead of the origin.
					var relSpeedAngle:Number = speedAngle - ropeAngle;
					// Convert to cartesian in rope space.  Apply 90-degree rotation to think in terms of rope hanging downward.
					var relSpeed:Point = Point.polar(speedMagnitude, relSpeedAngle - Math.PI/2);					
					
					// Actually perform the transformation here.  The rope nullifies any speed directly pulling against it.
					if (relSpeed.y < 0 )
						relSpeed.y = 0;		
					
					this.angle = (ropeAngle * (180 / Math.PI)) - 90;
					this.angle = Math.min( 45, this.angle );
					this.angle = Math.max( -45, this.angle );
					
					// Convert back to polar in rope coordinate space.
					relSpeedAngle = Math.atan2(relSpeed.y, relSpeed.x);
					speedMagnitude = Point.distance(new Point(), relSpeed);
					// polar in main coordinate space
					speedAngle = relSpeedAngle + ropeAngle;
					// Cartesian in main coordinate space.
					this.velocity = Point.polar(speedMagnitude, speedAngle + Math.PI / 2);
					
					// set acceleration in the direction of hook:
					acceleration.x = relX;
					acceleration.y = relY;					
					acceleration.normalize(1);					
				}
			}
			// WALL MOVEMENT:
			else if ( status == ONWALL )//bWalling )
			{
				maxVelocity.x = defaultRunVelocity;
				
				if( facing == LEFT )
					velocity.x = -50;
				else
					velocity.x = 50;
				velocity.y = 0;
				
				
				
			//	if(FlxG.keys.LEFT)
			//		facing = LEFT;
			//	else if(FlxG.keys.RIGHT)
			//		facing = RIGHT;				
								
				// JUMPING:
				if( FlxG.keys.justPressed("X") )
				{		
					if ( facing == RIGHT )
						velocity.x -= jumpFromWallPower;
					else
						velocity.x += jumpFromWallPower;
						
					status = INAIR;
				}				
			}
			else
			{	
				if ( status == ONSLOPEDOWN )
				{						
					acceleration = new Point(0, 0);
					drag = new Point(0, 0);						
					
					maxVelocity.y = maxVelocity.x;
					
					if(FlxG.keys.LEFT)
					{
						facing = LEFT;
						velocity.x = -0.65 * maxVelocity.x;
						velocity.y = -0.65 * maxVelocity.x;
						
					}
					else if(FlxG.keys.RIGHT)
					{
						facing = RIGHT;
						
						if( FlxG.keys.DOWN )
						{
							// higher maxVelocity?
							velocity.x = 1.0 * maxVelocity.x;
							velocity.y = 1.0 * maxVelocity.x;
						}
						else
						{
							velocity.x = 0.75 * maxVelocity.x;
							velocity.y = 0.75 * maxVelocity.x;
						}
					}	
					else
					{
						// no input also slides (slowly)
						velocity.x = 0.15 * maxVelocity.x;
						velocity.y = 0.15 * maxVelocity.x;
					}
				}
				else if ( status == ONSLOPEUP )
				{
					acceleration = new Point(0, 0);
					drag = new Point(0, 0);						
					
					maxVelocity.y = maxVelocity.x;
					
					if(FlxG.keys.RIGHT)
					{
						facing = RIGHT;
						velocity.x = 0.65 * maxVelocity.x;
						velocity.y = 0.65 * maxVelocity.x;
						
					}
					else if(FlxG.keys.LEFT)
					{
						facing = LEFT;
						
						if( FlxG.keys.DOWN )
						{
							// higher maxVelocity?
							velocity.x = -1.0 * maxVelocity.x;
							velocity.y = -1.0 * maxVelocity.x;
						}
						else
						{
							velocity.x = -0.75 * maxVelocity.x;
							velocity.y = -0.75 * maxVelocity.x;
						}
					}	
					else
					{
						// no input also slides (slowly)
						velocity.x = -0.15 * maxVelocity.x;
						velocity.y = -0.15 * maxVelocity.x;
					}
					
					
				}
				// "NORMAL" MOVEMENT
				// IN AIR:
				else if ( velocity.y )
				{
					status = INAIR;
					acceleration.y = fallAccel;
					if(FlxG.keys.LEFT)
					{
						facing = LEFT;
						acceleration.x -= 0.2 * currentPush;
					}
					else if(FlxG.keys.RIGHT)
					{
						facing = RIGHT;
						acceleration.x += 0.2 * currentPush;
					}
					else if(velocity.x )	// no direction input while jumping, so no acceleration (only drag)
					{					
						acceleration.x = 0;
					}
					
					// Finally, add a lot of drag, b/c jumping slows you down:
					//if ( velocity.x && acceleration.x )
					//{
					//	var decrease:Number = 2.0 * FlxG.elapsed;
					//	
					//	velocity.x *= (1 - decrease);						
					//}
				}
				else // ON GROUND
				{
					if(FlxG.keys.LEFT)
					{
						facing = LEFT;
						acceleration.x -= currentPush;
					}
					else if(FlxG.keys.RIGHT)
					{
						facing = RIGHT;
						acceleration.x += currentPush;
					}
				}
				
				// JUMPING:
				if( FlxG.keys.pressed("X") )
				{
					status = INAIR;
					jumpTime += FlxG.elapsed;
					acceleration.y = fallAccel;
					
					// hmm gaat nog niet echt lekker :(
					if ( jumpTime < maxJumpTime )
						velocity.y -= ((maxJumpTime - jumpTime) / maxJumpTime) * jumpPower * FlxG.elapsed;
				}
				else if ( status == INAIR )
				{
					jumpTime = maxJumpTime;					
				}
			}
			
			//AIMING
			bUp = false;
			bDown = false;
			if(FlxG.keys.UP) bUp = true;
			else if(FlxG.keys.DOWN && velocity.y) bDown = true;
			
			//ANIMATION
			if (hooks[prevHook].exists && hooks[prevHook].bCollided)
				play("jump_up");					
			else if(velocity.y != 0)
			{
				if(bUp) play("jump_up");
				else if(bDown) play("jump_down");
				else play("jump");
			}
			else if(velocity.x == 0)
			{
				if(bUp) play("idle_up");
				else play("idle");
			}
			else
			{
				if (bUp) play("run_up");
				else play("run");
			}	
			
			// SHOOT HOOK:
			if ( FlxG.keys.justPressed("C") && bCanHook )
			{
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;	
				
				bY -= hooks[curHook].height - 4;
				bYVel = -hookVel;
				
				if(facing == RIGHT)
				{
					bX += width - 4;
					bXVel = hookVel;
				}
				else
				{
					bX -= hooks[curHook].width - 4;
					bXVel = -hookVel;
				}			
				
				hooks[curHook].shoot(bX, bY, bXVel, bYVel);
				
				prevHook = curHook;
				if(++curHook >= hooks.length)
					curHook = 0;
			}
			
			
			
			// ROTATING:				
			if ( status == ONSLOPEDOWN )			
				this.angle = 45;
			else if ( status == ONSLOPEUP )
				this.angle = -45;
			else if ( status == INAIR )
			{					
				if ( FlxG.keys.X && Math.abs(this.velocity.x) > 0)
				{	
					if ( facing == RIGHT )					
						this.angle =  this.angle + FlxG.elapsed * 675;	
					else
						this.angle =  this.angle + FlxG.elapsed * -675;	
				}
				else
				{					
					var maxRot:Number = Math.ceil( Math.abs(this.angle) / 360 ) * 360;
					
					if ( this.angle < 0 )
						this.angle = Math.min(0, Math.max(this.angle - FlxG.elapsed*475, -maxRot));	
					else
						this.angle = Math.max(0, Math.min(this.angle + FlxG.elapsed*475, maxRot));	
				}				
				
				
				// original, this rotates slowly towards straight up:
				//if ( this.angle < 0 )
				//	this.angle = Math.min(0, this.angle + FlxG.elapsed*75);	
				//else
				//	this.angle = Math.max(0, this.angle - FlxG.elapsed*75);	
			}
			else if( status != SWINGING )
				this.angle = 0;
				
				
			
			 
			//UPDATE POSITION AND ANIMATION
			super.update();	
			
			//if ( facing == LEFT )
			//	this._flipped = 1;
			//else
			//	this._flipped = 0;
			
			
			// So I;m also re-setting the trails above, so this needs to be checked/rewritten/etc:
			trail.x = this.x;// + this.width / 2;			
			trail.y = this.y + trailYoffset;// + this.height - 8;// / 2;
			
			trail2.x = this.x + this.width / 2;			
			trail2.y = this.y + trail2Yoffset;// + this.height - 8;// / 2;
			
			//if( facing == RIGHT )
			//	eyeSpr.x = this.x + eyeOffsetX;
			//else
			//	eyeSpr.x = this.x + (eyeOffsetX - this.width)+1;
			//eyeSpr.y = this.y + eyeOffsetY;
			
			// RESET SOME STUFF:
			//if ( status == ONWALL )//|| status == ONSLOPEDOWN)
				//status = INAIR;
			
			
			//bOnDownSlope = false;
			//bWalling = false;
			bBoosting = false;		
			
			if ( switchToAirCntDwn > 0 && status != SWINGING)
			{
				switchToAirCntDwn -= FlxG.elapsed;
				if ( switchToAirCntDwn <= 0 )
				{
					status = INAIR;
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		// COLLISION HANDLING: 
		// (Performed AFTER update() is called!
		// hitTrigger
		// hitSlope
		// hitBoost
		// hitObstacle
		// hitWall
		// hitFloor
		// hitCeiling
		
		public function hitNothing():void
		{	
			bHitDoor = false;
			
			if ( status == ONSLOPEDOWN )
			{	
				if( switchToAirCntDwn <= 0 )
					switchToAirCntDwn = 0.25;
			}
			else
			{
				if( switchToAirCntDwn <= 0 )
					switchToAirCntDwn = 0.01;
			}
		}
		
		private function hitDoor(Contact:Door):Boolean 
		{
			switchToLevelId = Contact.levelId;
			bHitDoor = true;
			
			return false;			
		}
		
		
		private function hitTrigger(Contact:Trigger):Boolean 
		{
			if ( playState is LevelState )
			{
				var lState:LevelState = playState as LevelState;
				
				if ( Contact is StartTrigger )							
					lState.startTimer();								
				else if ( Contact is FinishTrigger )
					lState.stopTimer();				
			}
			
			return false;			
		}
		
		public function hitSlope(Contact:FlxCore, pl:FlxCore ):void
		{		
			var xdiff:Number;
			if ( Contact is SlopeDown )
			{
				status = ONSLOPEDOWN;
				
				jumpTime = 0;
				
				xdiff = this.x - Contact.x;
				this.y = Contact.y - this.height + xdiff - 2;
			}
			else if ( Contact is SlopeUp )
			{
				status = ONSLOPEUP;
				
				jumpTime = 0;
				
				xdiff = (Contact.x + Contact.width) - (this.x + this.width);
				this.y = Contact.y - this.height + xdiff - 2;				
			}
		}
		
		public function hitBoost():Boolean
		{
			bBoosting = true;
			return false;
		}
		
		public function hitObstacle(Contact:Obstacle):Boolean
		{
			this.velocity.x = 0;				
			this.velocity.y = 0;
			this.flicker(2);
			
			if ( bIsSwinging )
				hooks[prevHook].breakRelease();
			
			return false;			
		}
		
		public function hitPickup(Contact:Pickup):Boolean
		{
			Contact.PickedUp();			
			
			return false;
		}
		
		//@desc		Called when this object collides with a FlxBlock on one of its sides
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			if (Contact is BoostSection )
				return hitBoost();	
				
			if (Contact is Pickup )
				return hitPickup((Contact as Pickup));
				
			if (Contact is Door )
				return hitDoor((Contact as Door));
			
			if ( Contact is Obstacle )
				return hitObstacle((Contact as Obstacle));
				
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
				
			if ( bIsSwinging )
				hooks[prevHook].breakRelease();			
			
				
			if ( playState )
			{					
				var contactXtile:uint = Contact.x / 16;
				var contactYtile:uint = Contact.y / 16;
				
				var tileIndexAbove:uint = playState.flanmap.mainLayer.getTile(contactXtile, contactYtile + 1);
				var tileIndexBelow:uint = playState.flanmap.mainLayer.getTile(contactXtile, contactYtile - 1);
				
				if ( tileIndexAbove >= playState.flanmap.mainLayer.collideIndex 
					|| tileIndexBelow >= playState.flanmap.mainLayer.collideIndex )
				{					
					status = ONWALL;
					velocity.x = 0;
					
					/*
					if ( velocity.x > 0 )
						facing = LEFT;
					else	
						facing = RIGHT;
					*/
						
					velocity.y = 0;
					jumpTime = 0;		
				}
				else
				{
					var yDiff:Number = this.y - (Contact.y + Contact.height / 2);
					
					// I've hit a single tile.. slide over or under it:
					if ( yDiff > 0 )
					{
						//slide over..
						this.y += (Contact.height + yDiff );						
						return false;
					}
					else
					{
						// slide under..
						this.y -= (Contact.height + yDiff );						
						return false;
					}
				}
			}	
				
			return super.hitWall(Contact);
		}
		
		//@desc		Called when this object collides with the top of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitFloor(Contact:FlxCore = null):Boolean 
		{ 	
			if (Contact is BoostSection )
				return hitBoost();			
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
			if (Contact is Pickup )
				return hitPickup((Contact as Pickup));
			if (Contact is Door )
				return hitDoor((Contact as Door));
				
			status = ONGROUND;			
			jumpTime = 0;			
			
			return super.hitFloor(Contact); 
		}
		
		//@desc		Called when this object collides with the bottom of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitCeiling(Contact:FlxCore = null):Boolean 
		{ 
			if (Contact is BoostSection )
				return hitBoost();	
			
			if (Contact is Pickup )
				return hitPickup((Contact as Pickup));
				
			if (Contact is Door )
				return hitDoor((Contact as Door));
			
			if ( Contact is Obstacle )
				return hitObstacle((Contact as Obstacle));
				
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
				
			if ( bIsSwinging )
				hooks[prevHook].breakRelease();
				
			return super.hitCeiling(Contact);
		}
		
		
		// ugly hackish function, clean up:
		public function setHooks(hooks:Array):void
		{
			this.hooks = hooks;			
		}		
	}
}
