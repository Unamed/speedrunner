package
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source="../data/temp/spaceman_new_thin.png")] private var ImgSpaceman:Class;
		private var size:uint = 32;	
		
		private var jumpPower:int;
		private var bUp:Boolean;
		private var bDown:Boolean;
		private var restart:Number;
		
		private var hooks:Array;
		private var curHook:uint;
		public var prevHook:uint;		
		
		private var bIsSwinging:Boolean;
		
		private var runSpeed:uint = 9 * size; //18*size = snel
		private var hookVel:int = 4 * runSpeed;
		
		private var swingSpeed:uint = 2.00 * runSpeed; //1.30 * runSpeed bij snel
		
		private var jumpTime:Number;
		private var maxJumpTime:Number = 0.25;
		
		private var fallAccel:Number = 32 * size;
		
		private var bWalling:Boolean;
		private var bBoosting:Boolean;
		
		private var playState:PlayState;
		
		private var push:Point; // the force applied by input
		
		
		public var bOnDownSlope:Boolean;
		
		private var trail:FlxEmitter;
		private var trail2:FlxEmitter;
		private var trailYoffset:uint;
		private var trail2Yoffset:uint;
		
		private const maxSwingVelocity:uint = 2.00 * runSpeed;
		private const maxRunVelocity:uint = runSpeed;
		private const maxBoostVelocity:uint = 2.00 * runSpeed;
		
		static public const ONGROUND:uint = 0;
		static public const ONWALL:uint = 1;
		static public const ONSLOPEDOWN:uint = 2;
		static public const ONSLOPEUP:uint = 3;
		static public const INAIR:uint = 4;
		static public const SWINGING:uint = 5;
		
		public var status:uint = INAIR;
		
		private var switchToAirCntDwn:Number = 0;
		
		public function Player(X:int, Y:int)//, hooks:Array)
		{
			super(X, Y);
			
			this.createGraphic(16, 32, 0xFF000000);
			//loadGraphic(ImgSpaceman,true,true,16,32);
			restart = 0;
			
			jumpTime = 0;
			
			//bounding box tweaks
			width = 12;
			height = 28;
			offset.x = 4;
			offset.y = 4;
			
			//basic player physics
			drag.x = runSpeed * 2;
			
			push = new Point(runSpeed * 8, 0);			
			
			acceleration.y = fallAccel;
			jumpPower = 150 * size;
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
			
			// Trail emitter
			trail = new FlxEmitter();			
			trail.width = 10;// 10;
			trail.height = 32;// 20;
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
				arr2.push(FlxG.state.add((new PlayerTrailParticle(6.0).createGraphic(16, 32, 0x220000FF))));
			}
			
			trail2Yoffset = 16;		
			
			FlxG.state.add(trail2.loadSprites(arr2));
			FlxG.state.add(trail.loadSprites(arr));
			
			
			curHook = 0;
			
			if( FlxG.state is PlayState )
				playState = FlxG.state as PlayState
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
			acceleration.y = fallAccel;	
			
			// Determine max Velocity:
			if ( bBoosting )
				maxVelocity.x = maxBoostVelocity;			
			else
				maxVelocity.x = Math.max( maxVelocity.x - FlxG.elapsed * 100, maxRunVelocity);			
				
			maxVelocity.y = 24 * size;
			drag.x = runSpeed * 2;				
			
			// EMITTERS:
			if ( velocity.length > 50 )
				trail.reset(this.x, this.y);
			else if ( trail.active )
				trail.active = false;
				
			if ( velocity.length *0.77 > maxRunVelocity )
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
				maxVelocity.x = swingSpeed;
				
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
						velocity.x -= jumpPower * 8;
					else
						velocity.x += jumpPower * 8;
						
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
						
						
						//velocity.y = Math.max( velocity.x, velocity.y );
						
						//velocity.x = -0.6 * maxVelocity.x;
						//velocity.y = -0.6 * maxVelocity.x;
						//acceleration.x -= 0.6 * push.x;
						//acceleration.y -= 0.6 * push.x;
						
						
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
						
						//acceleration.x = 0.25 * push.x;
						//acceleration.y = 0.25 * push.x;
					}
				}
				// "NORMAL" MOVEMENT
				// In air:
				else if ( velocity.y )
				{
					status = INAIR;
					if(FlxG.keys.LEFT)
					{
						facing = LEFT;
						acceleration.x -= 0.2 * push.x;
					}
					else if(FlxG.keys.RIGHT)
					{
						facing = RIGHT;
						acceleration.x += 0.2 * push.x;
					}
					else if(velocity.x )	// no direction input while jumping, so no acceleration (only drag)
					{					
						acceleration.x = 0;
					}
					
					// Finally, add a lot of drag, b/c jumping slows you down:
					if ( velocity.x && acceleration.x )
					{
						var decrease:Number = 2.0 * FlxG.elapsed;
						
						velocity.x *= (1 - decrease);						
					}
				}
				else 
				{
					if(FlxG.keys.LEFT)
					{
						facing = LEFT;
						acceleration.x -= push.x;
					}
					else if(FlxG.keys.RIGHT)
					{
						facing = RIGHT;
						acceleration.x += push.x;
					}
				}
				
				// JUMPING:
				if( FlxG.keys.pressed("X") )
				{
					status = INAIR;
					jumpTime += FlxG.elapsed;
					
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
			if ( FlxG.keys.justPressed("C")  )
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
			
			
			
							
			if ( status == ONSLOPEDOWN )			
				this.angle = 45;						
			else	
				this.angle = 0;	
			
			 
			//UPDATE POSITION AND ANIMATION
			super.update();	
			
			
			// So I;m also re-setting the trails above, so this needs to be checked/rewritten/etc:
			trail.x = this.x;// + this.width / 2;			
			trail.y = this.y + trailYoffset;// + this.height - 8;// / 2;
			
			trail2.x = this.x + this.width / 2;			
			trail2.y = this.y + trail2Yoffset;// + this.height - 8;// / 2;
			
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
		
		private function hitTrigger(Contact:Trigger):Boolean 
		{
			if ( playState )
			{
				if ( Contact is StartTrigger )							
					playState.startTimer();								
				else if ( Contact is FinishTrigger )
					playState.stopTimer();				
			}
			
			return false;			
		}
		
		public function hitSlope(Contact:FlxCore, pl:FlxCore ):void
		{				
			if ( Contact is SlopeDown )
			{
				status = ONSLOPEDOWN;
				
				jumpTime = 0;
				
				var xdiff:Number = this.x - Contact.x;
				this.y = Contact.y - this.height + xdiff - 5;
				/*
				if ( facing == LEFT )
					this.y = Contact.y - this.height - 1.0;
				else
					this.y = Contact.y - this.height + xdiff + 1.0;
					*/
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
		
		//@desc		Called when this object collides with a FlxBlock on one of its sides
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			if (Contact is BoostSection )
				return hitBoost();										
			
			if ( Contact is Obstacle )
				return hitObstacle((Contact as Obstacle));
				
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
				
			if ( bIsSwinging )
				hooks[prevHook].breakRelease();			
			
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
