package cas.spdr.actor
{
	import cas.spdr.gfx.sprite.*;
	import cas.spdr.state.LevelState;
	import cas.spdr.state.MainMenuState;
	import cas.spdr.state.PlayState;
	import flash.display.Graphics;
	import flash.geom.Point;
	import org.flixel.*;	
	import cas.spdr.gfx.GraphicsLibrary;
	
	import org.flixel.fefranca.debug.FlxSpriteDebug;

	public class Player extends FlxSprite//Debug
	{		
		
		
		private var size:uint = 50;	
		
		private var jumpPower:int = 6000;
		private var jumpFromWallPower:uint = 550;// 1000;
		private var bUp:Boolean;
		private var bDown:Boolean;
		private var restart:Number;
		
		private var hooks:Array;
		private var curHook:uint;
		public var prevHook:uint;	
		
		// unlocked powers:
		private var bCanHook:Boolean;
		private var bCanWalljump:Boolean;
		private var bCanSlide:Boolean;
		private var bCanDoubleJump:Boolean;
		
		private var bIsSwinging:Boolean;		
		
		private var hookVel:int = 1200;
		
		//private var swingSpeed:uint = 1.750 * runSpeed; //1.30 * runSpeed bij snel
		
		private var jumpTime:Number;
		private var bDidDoubleJump:Boolean;
		private var maxJumpTime:Number = 0.25;
		
		private var fallAccel:Number = 32 * size;
		
		private var bWalling:Boolean;
		private var bBoosting:Boolean;
		
		private var playState:PlayState;
		
		
		
		
		public var bOnDownSlope:Boolean;
		
		private var switchToLevelId:uint;
		private var bHitDoor:Boolean;
		
		private var bHitUseTrigger:Boolean;
		private var useTriggerEffect:String;
		
		private var trail:FlxEmitter;
		private var trail2:FlxEmitter;
		private var trailYoffset:int;
		private var trail2Yoffset:int;
		
		public var defaultRunVelocity:uint;// = 300;
		public var defaultSwingVelocity:uint;// = 2.00 * defaultRunVelocity;			//2.0
		public var maxRunVelocity:uint;// = 2.0 * defaultRunVelocity;			//1.5
		public var maxBoostVelocity:uint;// = 3.00 * defaultRunVelocity;			//2.0
		public var maxSwingVelocity:uint;// = maxBoostVelocity;
		public var crawlVelocity:uint;// = 300;		
		
		public const pushLevel1:Number = 500;
		public const pushLevel2:Number = 550;
		public const pushLevel3:Number = 600;
		public const pushLevel4:Number = 650;
		public const pushLevel5:Number = 700;
		public const pushLevel6:Number = 750;
		public const pushLevel7:Number = 800;
		
		public const runVelocityLevel1:uint = 250;
		public const runVelocityLevel2:uint = 275;
		public const runVelocityLevel3:uint = 300;
		public const runVelocityLevel4:uint = 325;
		public const runVelocityLevel5:uint = 350;
		public const runVelocityLevel6:uint = 375;
		public const runVelocityLevel7:uint = 400;		
		
		public var currentPush:Number; // the force applied by input
		public var defaultPush:Number = 600;		
		public const slowPush:Number = 150;
		
		static public const ONGROUND:uint = 0;
		static public const ONWALL:uint = 1;
		static public const ONSLOPEDOWN:uint = 2;
		static public const ONSLOPEUP:uint = 3;
		static public const INAIR:uint = 4;
		static public const SWINGING:uint = 5;
		private var bSliding:Boolean;
		private var bCrawling:Boolean;
		private var bStumbling:Boolean;
		private var stumbleCntDwn:Number;
		
		public var status:uint = INAIR;
		
		private var switchToAirCntDwn:Number = 0;
		private var releaseWallCntDwn:Number = 0;
		
		private var explosionEmitter:FlxEmitter;
				
		
		public function Player(X:int, Y:int)//, hooks:Array)
		{
			super(X, Y);	
			this.loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_RYU), true, true, 45, 51);			
			
			restart = 0;
			
			this._curFrame = 0;
			
			jumpTime = 0;
			
			//bounding box tweaks
			width = 21;
			height = 46;
			offset.x = 11;	//2
			offset.y = 4;
			
			//basic player physics
			drag.x = defaultRunVelocity * 2;
			
			currentPush = defaultPush;			
			
			acceleration.y = fallAccel;
			
			maxVelocity.x = defaultRunVelocity;
			maxVelocity.y = 24 * size;// 800;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("runslow", [1, 2, 3], 8);						
			addAnimation("runmedium", [1, 2, 3], 16);
			addAnimation("runfast", [1, 2, 3], 24);			
			addAnimation("grappling", [14]);			
			addAnimation("trygrappling", [15]);			
			addAnimation("jump_up", [13]);
			addAnimation("jump_forward", [4,5,10,11],12);
			addAnimation("jump_rotate", [18]);
			addAnimation("jump_down", [12]);						
			addAnimation("walling", [6]);						
			addAnimation("wallingaway", [7]);	
			addAnimation("stopslide", [8]);
			addAnimation("slide", [19]);
			addAnimation("crawl", [20,21],4);
			addAnimation("stumble", [16,17,18],8);
			addAnimation("dead", [ 22],24,false);
			
			
			curHook = 0;
			
			if( FlxG.state is PlayState )
				playState = FlxG.state as PlayState
				
			// check my unlocked powers:
			bCanHook = FlxG.progressManager.HasUnlockedHook();
			bCanWalljump = FlxG.progressManager.HasUnlockedWalljump();
			bCanSlide = FlxG.progressManager.HasUnlockedSlide();
			bCanDoubleJump = FlxG.progressManager.HasUnlockedDoubleJump();
			
			// check my speedLevel:					
			switch( FlxG.progressManager.getSpeedLevel() )
			{
				case(1):					
					defaultRunVelocity = runVelocityLevel1;
					break;
				case(2):					
					defaultRunVelocity = runVelocityLevel2;
					break;
				case(3):					
					defaultRunVelocity = runVelocityLevel3;
					break;
				case(4):					
					defaultRunVelocity = runVelocityLevel4;
					break;
				case(5):					
					defaultRunVelocity = runVelocityLevel5;
					break;
				case(6):					
					defaultRunVelocity = runVelocityLevel6;
					break;
				case(7):					
					defaultRunVelocity = runVelocityLevel7;
					break;				
				default:					
					defaultRunVelocity = runVelocityLevel1;
			}
			
			// check my Accelerarion level:					
			switch( FlxG.progressManager.getAccelLevel() )
			{
				case(1):
					defaultPush = pushLevel1;					
					break;
				case(2):
					defaultPush = pushLevel2;					
					break;
				case(3):
					defaultPush = pushLevel3;					
					break;
				case(4):
					defaultPush = pushLevel4;
					break;
				case(5):
					defaultPush = pushLevel5;
					break;
				case(6):
					defaultPush = pushLevel6;
					break;
				case(7):
					defaultPush = pushLevel7;
					break;
				default:
					defaultPush = pushLevel1;					
			}
			
			defaultSwingVelocity = 2.00 * defaultRunVelocity;			//2.0
			maxRunVelocity = 2.0 * defaultRunVelocity;			//1.5
			maxBoostVelocity = 3.00 * defaultRunVelocity;			//2.0
			maxSwingVelocity = maxBoostVelocity;
			crawlVelocity = 300;
			
			// debug:
			FlxG.log("defPush: " + defaultPush);
			FlxG.log("defVel: " + defaultRunVelocity);
		}		
		
		public function addToState(state:FlxState):void
		{		
			// Trail emitter
			trail = new FlxEmitter();			
			trail.randomized = true;
			trail.width = 19;// 10;
			trail.height = 1;// 20;
			trail.y = this.y;
			trail.x = this.x;		
			trail.setRotation(10, 20);			
			trail.delay = 0.1;
			trail.gravity = 600;
			trail.setXVelocity(0);
			trail.setYVelocity(-150, -150);					
			//trail.setRotation(45, 45);			
			var arr:Array = new Array();
			for (var i:uint = 0; i < 60; i++)
			{
				arr.push(FlxG.state.add((new PlayerTrailParticle(1.0,0,0,null,true).createGraphic(4, 4, 0xFF000000))));			
				//arr.push(FlxG.state.add((new PlayerTrailParticle(3.0).createGraphic(6, 6, 0xFFFFFFFF))));			
				//arr.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(16, 32, 0x22FFFFFF))));			
			}				
			trailYoffset = 40;
			
			// Trail2 emitter
			trail2 = new FlxEmitter();			
			trail2.width = 1;// 10;
			trail2.height = 1;// 32;// 20;
			trail2.y = this.y;
			trail2.x = this.x;		
			trail2.setRotation(0, 0);			
			trail2.delay = 0.01;
			trail2.gravity = 0;// 100;
			trail2.setXVelocity(0);
			trail2.setYVelocity(0);	
			//trail2.setRotation(45, 45);			
			var arr2:Array = new Array();
			for (var i2:uint = 0; i2 < 60; i2++)
			{
				//arr2.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(6, 6, 0x66FFFFFF))));			
				//arr2.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(6, 6, 0xFFFF0000))));
				//arr2.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(6, 6, 0x880000FF))));
				//arr.push(FlxG.state.add((new PlayerTrailParticle().createGraphic(16, 32, 0x22FFFFFF))));			
				//arr2.push(FlxG.state.add((new PlayerTrailParticle(8.0).createGraphic(4, 4, 0xFF000000))));
				arr2.push(FlxG.state.add((new PlayerTrailParticle(3.0).createGraphic(25, 5, 0xFF000000))));
			}			
			trail2Yoffset = 10;// -25;// 22;		
			
			explosionEmitter = new FlxEmitter();
			explosionEmitter.delay = -2.0;
			explosionEmitter.setXVelocity(-200, 200);
			explosionEmitter.setYVelocity( -400, -100);	
			explosionEmitter.randomized = true;
			explosionEmitter.gravity = 400;
			var arr3:Array = new Array();
			for (var i3:uint = 0; i3 < 25; i3++)
			{				
				arr3.push( FlxG.state.add( ( new PlayerTrailParticle(1.0,0,0,null,true).createGraphic(10, 10, 0xFF000000) ) ) );	
			}			
			
			state.add(trail2.loadSprites(arr2));
			state.add(trail.loadSprites(arr));
			state.add(explosionEmitter.loadSprites(arr3));
			
			state.add(this);
			
			trail.active = false;
			trail2.active = false;
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
			
			if ( bStumbling )
			{
				stumbleCntDwn -= FlxG.elapsed;
				if ( stumbleCntDwn < 0 )
					bStumbling = false;
			}
			
			// ENTERING DOORS AND USING USETRIGGERS:
			if ( bHitDoor && FlxG.state is MainMenuState)
			{				
				(FlxG.state as MainMenuState).showLevelInfo(switchToLevelId);
			}
			
			if ( FlxG.keys.justPressed("UP") )
			{
				if( bHitDoor )
					( FlxG.state as PlayState ).switchToLevel(switchToLevelId);				
				else if ( bHitUseTrigger )
					FlxG.progressManager.upgradeSetting( useTriggerEffect );				
			}
			
			checkReleaseHook();
			
			
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
				if ( bCrawling )
				{
					maxVelocity.x = crawlVelocity;					
				}
				else if ( Math.abs(velocity.x) < defaultRunVelocity )
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
			drag.x = defaultRunVelocity * 2;				
			
					
			
			// --------------------------------------------------------------------------------------------------------------------------------
			// MOVEMENT CODE: 			
			
			// IF SWINGING:
			if ( hooks[prevHook].exists && hooks[prevHook].bCollided )
			{
				var hook:Hook = hooks[prevHook];
				
				var relX:Number = this.x - hook.x;
            	var relY:Number = this.y - hook.y;
				var ropeAngle:Number = Math.atan2(relY, relX);
				
				status = SWINGING;
				maxVelocity.x = maxSwingVelocity;
				
				bOnDownSlope = false;
				bDidDoubleJump = false;
				
				// Always start swinging at a high speed				
				if ( !bIsSwinging )
				{
					//FlxG.log("curVel.x: " + velocity.x);
					
					if ( relX < 0 )
						velocity.x = Math.max(defaultSwingVelocity, velocity.x);
					else 
						velocity.x = Math.min(-defaultSwingVelocity, velocity.x);
					
					//FlxG.log("newVel.x: " + velocity.x);
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
					acceleration.x = relX * 1.5;
					acceleration.y = relY;					
					acceleration.normalize(1);					
				}
			}
			// WALL MOVEMENT:
			else if ( status == ONWALL )//bWalling )
			{
				FlxG.log("walling..");
				maxVelocity.x = defaultRunVelocity;				
				
				// make sure I stick to the wall:
				if( facing == LEFT )
					velocity.x = -50;
				else 
					velocity.x = 50;
				
				releaseWallCntDwn -= FlxG.elapsed;
				
				if( ( FlxG.keys.LEFT || FlxG.keys.RIGHT ) )
				{
					releaseWallCntDwn = 0.5;
				}
				
				// immediately release when pressing down:
				if ( FlxG.keys.DOWN )
					releaseWallCntDwn = -1;
				
				if ( releaseWallCntDwn <= 0 )
				{
					// release wall!
					if ( facing == LEFT )
					{
						velocity.x = 50;
						facing = RIGHT;
					}
					else 
					{
						velocity.x = -50;
						facing = LEFT;
					}						
					status - INAIR;					
				}
				
				// no velocity..
				velocity.y = 0;	
				acceleration.y = 0;
								
				// JUMPING:
				if( FlxG.keys.justPressed("Z") )
				{		
					if ( facing == RIGHT )
					{
						velocity.x -= jumpFromWallPower;
						facing = LEFT;
					}
					else
					{
						velocity.x += jumpFromWallPower;
						facing = RIGHT;
					}
						
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
					
					// DOUBLE JUMPING:
					if( FlxG.keys.justPressed("Z") && !bDidDoubleJump && bCanDoubleJump )
					{	
						FlxG.log("Double jump!");
						this.velocity.y = 0;// -= 100;
						this.jumpTime = 0;
						bDidDoubleJump = true;
					}	
					
					if ( FlxG.keys.DOWN && bCanSlide )
					{
						if ( !bSliding )
							this.y += 26;
							
						bSliding = true;
						this.offset.y = 26;
						this.height = 20;
					}
					else
					{		
						// if I was sliding..
						if ( bSliding || bCrawling )
						{
							if ( tryStandUp() )
							{
								bCrawling = false;
								
								this.y -= 26;
								
							}
							else
							{
								bCrawling = true;
							}							
						}
							
						bSliding = false;												
						
						if ( !bCrawling )
						{
							this.offset.y = 4;
							this.height = 46;								
						}
					}
				}
				else // ON GROUND
				{
					if ( FlxG.keys.DOWN && bCanSlide )
					{
						if ( !bCrawling && Math.abs( velocity.x ) > 10 )
						{
							if ( !(bSliding || bCrawling) )
								this.y += 26;
								
							bSliding = true;
							bCrawling = false;
							
						}
						else
						{
							if ( !(bSliding || bCrawling) )
								this.y += 26;
								
							bSliding = false;
							bCrawling = true;
						}
						
						this.offset.y = 26;
						this.height = 20;
					}
					else
					{		
						// if I was sliding..
						if ( bSliding || bCrawling )
						{
							if ( tryStandUp() )
							{
								bCrawling = false;								
								this.y -= 26;								
							}
							else
							{
								bCrawling = true;
							}							
						}
							
						bSliding = false;												
						
						if ( !bCrawling )
						{
							this.offset.y = 4;
							this.height = 46;								
						}
					}
					
					if(FlxG.keys.LEFT)
					{
						facing = LEFT;
						if( bSliding )
							acceleration.x = Math.min( acceleration.x + currentPush, 0 );
						else if ( bCrawling )
						{
							//?
							acceleration.x -= currentPush;
						}
						else
							acceleration.x -= currentPush;
					}
					else if(FlxG.keys.RIGHT)
					{
						facing = RIGHT;
						if( bSliding )
							acceleration.x = Math.max( acceleration.x - currentPush, 0 );
						else if ( bCrawling )
						{
							//?
							acceleration.x += currentPush;
						}
						else
							acceleration.x += currentPush;
					}
				}
				
				// JUMPING:
				if( FlxG.keys.pressed("Z") )
				{
					status = INAIR;
					bStumbling = false;
					jumpTime += FlxG.elapsed;
					acceleration.y = fallAccel;
					
					if ( jumpTime < maxJumpTime )
						velocity.y -= ((maxJumpTime - jumpTime) / maxJumpTime) * jumpPower * FlxG.elapsed;					
				}
				else if ( status == INAIR )
				{
					jumpTime = maxJumpTime;					
				}
			}
			// END MOVEMENT CODE!
			// --------------------------------------------------------------------------------------------------------------------------------
			
			//AIMING
			bUp = false;
			bDown = false;
			if(FlxG.keys.UP) bUp = true;
			else if (FlxG.keys.DOWN && velocity.y) bDown = true;
			
			// ANIMATING:
			playAnimation();			
			
			// SHOOT HOOK:
			if ( FlxG.keys.justPressed("X") && bCanHook )
				shootHook();
			
			// ROTATING:
			doRotation(ropeAngle);			
			 
			// UPDATE POSITION AND ANIMATION 
			// (but save current data for future reference..
			// because update automatically sets velocity.y bcause of gravity)
			var velocityBeforeUpdate:Point = new Point(velocity.x, velocity.y);			
			super.update();	
			
			// THEN, update trails (we want to use the new location):
			updateTrails(velocityBeforeUpdate);			
			
			// CLEAN UP: 
			bBoosting = false;				
			
			// still neccessary???
			if ( switchToAirCntDwn > 0 && status != SWINGING)
			{
				switchToAirCntDwn -= FlxG.elapsed;
				if ( switchToAirCntDwn <= 0 )
				{
					status = INAIR;
				}
			}
		}		
		
		// UPDATE HELPER FUNCTIONS:
		// only to be called during update loop!
		
		private function checkReleaseHook():void
		{
			if ( hooks[prevHook].exists && !FlxG.keys.pressed("X") )
				hooks[prevHook].release();				
			
			if ( !hooks[prevHook].bCollided )
				bIsSwinging = false;				
		}
		
		private function tryStandUp():Boolean
		{
			var hitPoint:Point = new Point();
			var hit1:Boolean = playState.flanmap.mainLayer.ray(x, y, x, y - 26, hitPoint);
			var hit2:Boolean = playState.flanmap.mainLayer.ray(x + width, y, x + width, y - 26, hitPoint);
			
			if ( hit1 || hit2 )
				return false;
			// else..
			return true;
			
		}
		
		// finds out which animation should be played
		private function playAnimation():void
		{
			if (hooks[prevHook].exists )
			{
				if( hooks[prevHook].bCollided )
					play("grappling");					
				else
					play("trygrappling");
			}
			else if(velocity.y != 0)
			{
				if ( bSliding )
					play("slide");
				else if (velocity.y > 0 && velocity.y > Math.abs(velocity.x)) 
					play("jump_down");
				else if ( bDidDoubleJump )
					play("jump_rotate");
				else if ( Math.abs(velocity.x) > 0 )
					play("jump_forward");				
				else 
					play("jump_up");				
			}
			else if ( status == ONWALL )
			{
				if ( facing == RIGHT && FlxG.keys.LEFT || facing == LEFT && FlxG.keys.RIGHT )
					play("wallingaway");
				else
					play("walling");
			}			
			else
			{
				if ( bStumbling )				
					play("stumble");
				else if ( bSliding )
					play("slide");
				else if ( bCrawling )
					play("crawl");
				else if ( facing == RIGHT && velocity.x < 0 || facing == LEFT && velocity.x > 0 )				
					play("stopslide");
				else if ( Math.abs(velocity.x) > maxRunVelocity )
					play("runfast");
				else if ( Math.abs(velocity.x) > defaultRunVelocity )				
					play("runmedium");
				else if(velocity.x == 0)
					play("idle");
				else	
					play("runslow");
			}				
		}
		
		private function explode():void
		{
			if ( ! FlxG.state is LevelState )
				return;
			
			explosionEmitter.setXVelocity(this.velocity.x -100, this.velocity.x + 100);
			//explosionEmitter.setXVelocity(this.velocity.x -100, this.velocity.x + 100);
			explosionEmitter.reset(x + this.width/2, y + height/2);
			explosionEmitter.restart();
			
			play("dead");
			
			(FlxG.state as LevelState).endLevel();
			
			FlxG.quake(0.01, 0.25);
			
		}
		
		private function shootHook():void
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
		
		// Finds out and sets the correct rotation
		private function doRotation(ropeAngle:Number):void
		{
			if (hooks[prevHook].exists && !hooks[prevHook].bCollided )
				this.angle = 0;			
			else if ( status == ONSLOPEDOWN )			
				this.angle = 45;
			else if ( status == ONSLOPEUP )
				this.angle = -45;
			else if ( status == INAIR && bDidDoubleJump )
			{					
				if ( FlxG.keys.Z && Math.abs(this.velocity.x) > 0)
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
			else if ( status == SWINGING )
			{
				this.angle = (ropeAngle * (180 / Math.PI)) - 90;
				//this.angle = Math.max( -45, Math.min( 45, this.angle ) );					
			}
			else if ( status == ONGROUND )
			{
				if ( bSliding )
					this.angle = 0;
				else
					this.angle = (this.velocity.x / maxBoostVelocity) * 20;				
			}
			else
				this.angle = 0;
			
		}
		
		private function updateTrails(oldVelocity:Point):void 
		{
			// Sliding effect:
			if (( facing == RIGHT && velocity.x < 0 
				|| facing == LEFT && velocity.x > 0 )
				&& status == ONGROUND )
			{				
				if ( velocity.x > 0 )
				{
					trail.reset(this.x + this.width, this.y + trailYoffset);	
					trail.setXVelocity(200, 300);
				}
				else
				{
					trail.reset(this.x - this.width, this.y + trailYoffset);	
					trail.setXVelocity( -300, -200);
				}
					
			}
			else
				trail.active = false;				
				
			// "Q-music" effect:
			var velToRot:Number;
			if ( velocity.length > 0 )
			{				
				velToRot = (( Math.asin( velocity.x / velocity.length ) / Math.PI ) * 180 ) - 90;
								
				// wierdness... :|
				if ( velocity.y > 0 )
					velToRot *= -1;				
			}
			else
				velToRot = 0;	
				
			if ( oldVelocity.y )
			{
				trail2.reset(this.x + this.width / 2, this.y + this.height / 2);
				trail2.setRotation(velToRot, velToRot);
			}
			else if ( trail2.active )
			{
				trail2.active = false;
				trail2.setRotation(0, 0);
			}				
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		// COLLISION HANDLING: 
		// (Performed AFTER update() is called!
		// hitXXX..
		
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
			
			// if the dot product of my distance to the door and my velocity is negative, then I'm moving towards the door
			// otherwise, I'm moving away from the door
			
			// if I'm moving away from the door, un-show the message dialog, 
			// but only if I'm at the very edge of the door
			
			var dist:Point = new Point(x - Contact.x, y - Contact.y );			
			var dotProduct:Number = (dist.x * velocity.x) + (dist.y * velocity.y);
			
			if( dotProduct < 0 )
				bHitDoor = true;
			else if ( this.x > Contact.x + Contact.width - 5 
				|| this.x < Contact.x - this.width + 5 )
				bHitDoor = false;
			
			return false;			
		}
		
		
		private function hitTrigger(Contact:Trigger):Boolean 
		{
			if ( Contact is FinishTrigger && playState is LevelState )
			{		
				(playState as LevelState).stopTimer();											
			}
			else if ( Contact is UseTrigger )
			{
				bHitUseTrigger = true;
				useTriggerEffect = (Contact as UseTrigger).effect;
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
				bDidDoubleJump = false;
				
				xdiff = this.x - Contact.x;
				this.y = Contact.y - this.height + xdiff - 2;
			}
			else if ( Contact is SlopeUp )
			{
				status = ONSLOPEUP;
				
				jumpTime = 0;
				bDidDoubleJump = false;
				
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
			this.velocity.x *= 0.5;				
			this.velocity.y = 0;
			
			bStumbling = true;
			stumbleCntDwn = 0.5;
			//this.flicker(2);
			
			explode();
			
			if ( bIsSwinging )
				hooks[prevHook].breakRelease();
			
			return false;			
		}
		
		public function hitPickup(Contact:Pickup):Boolean
		{
			Contact.PickedUp(FlxG.state as PlayState);			
			
			return false;
		}
		
		//@desc		Called when this object collides with a FlxBlock on one of its sides
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			if (Contact is Door )
				return hitDoor((Contact as Door));
				
			if (Contact is BoostSection )
				return hitBoost();	
				
			if (Contact is Pickup )
				return hitPickup((Contact as Pickup));
			
			if ( Contact is Obstacle )
				return hitObstacle((Contact as Obstacle));
				
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
				
			if ( bIsSwinging )
			{
				FlxG.log("HitWall while swinging");
				hooks[prevHook].breakRelease();	
			}
				
			if ( playState )
			{					
				var contactXtile:uint = Contact.x / 16;
				var contactYtile:uint = Contact.y / 16;
				
				// top one only used for testing:
				var tileIndex:uint = playState.flanmap.mainLayer.getTile(contactXtile, contactYtile);
				var tileIndexAbove:uint = playState.flanmap.mainLayer.getTile(contactXtile, contactYtile - 1);
				var tileIndexBelow:uint = playState.flanmap.mainLayer.getTile(contactXtile, contactYtile + 1);
				
				//FlxG.log("hitWall ("+contactXtile+", "+contactYtile+"), index: "+tileIndex+" iAbove: "+tileIndexAbove+" iBelow:"+tileIndexBelow+" (y = "+y+")");
				
				// MMMMmmaybe there was this weird case where I'm hitting a wall, but above it is a slope.
				// In that case, I should prob. be on top of that slope, right? 
				if ( tileIndexAbove == 32 || tileIndexAbove == 33 )						
				{
					//playState.flanmap.mainLayer.setTile(contactXtile, contactYtile, 34);
					this.y -= 3 * Contact.height;
					this.last.y = this.y;	// this line is needed, otherwise a hitCeiling will be detected (which messes up this hack)
					
					return false;
				}					
					
				// Otherwise, start walling when there are tiles both below AND above the collided tile
				else if ( tileIndexAbove >= playState.flanmap.mainLayer.collideIndex + 3
					&& tileIndexBelow >= playState.flanmap.mainLayer.collideIndex + 3
					&& bCanWalljump )
				{		
					//if ( velocity.x > 0 && FlxG.keys.RIGHT 
					//	|| velocity.x < 0 && FlxG.keys.LEFT )						
					if ( FlxG.keys.RIGHT || FlxG.keys.LEFT )
					{
						status = ONWALL;
						
						// make sure I'm now looking at the wall:
						if ( velocity.x > 0 )
							facing = RIGHT;
						else
							facing = LEFT;
					}
					else
						FlxG.log("huh..");
					
						
					velocity.x = 0;						
					velocity.y = 0;
					jumpTime = 0;
					bDidDoubleJump = false;
				}
				// if there is a tile above the collided tile -> regular collision
				else if ( tileIndexAbove >= playState.flanmap.mainLayer.collideIndex  )					
				{
					// regular collision.
					return super.hitWall(Contact);
					
					
				}						
				// if I've hit a single tile (no tile above it) -> glide over it (conditions apply!!!)
				else if ( tileIndexAbove < playState.flanmap.mainLayer.collideIndex ) 
				{
					// WARNING! RATHER UGLY HACKING CODE:
					// There are 3 scenarios in which this (tileIndexAbove != collisionTile) might happen:
					// 1 - while in air
					// 2 - a bug when coming from slope, but missing the last slopeTile
					// 3 - walking against a wall that is just as high as me 					
					// In the first two cases, I want to apply a nice piece of gliding over code. However, 
					// in case 3, I want regular collision! This ugly code will identify which case we're dealing with:
					
					var bPossiblyInCaseThree:Boolean = true;
					
					if ( status == INAIR )
						bPossiblyInCaseThree = false;
						
					if ( bPossiblyInCaseThree )
					{
						var tileIndexLeft:uint = playState.flanmap.mainLayer.getTile(contactXtile-1, contactYtile);
						var tileIndexLeft2:uint = playState.flanmap.mainLayer.getTile(contactXtile-2, contactYtile);
						var tileIndexRight:uint = playState.flanmap.mainLayer.getTile(contactXtile + 1, contactYtile);
						var tileIndexRight2:uint = playState.flanmap.mainLayer.getTile(contactXtile + 2, contactYtile);
						
						if ( playState.flanmap.mainLayer.floorRightSlopes.indexOf(tileIndexRight) > -1 
							|| playState.flanmap.mainLayer.floorRightSlopes.indexOf(tileIndexRight2) > -1 
							|| playState.flanmap.mainLayer.floorLeftSlopes.indexOf(tileIndexLeft) > -1 
							|| playState.flanmap.mainLayer.floorLeftSlopes.indexOf(tileIndexLeft2) > -1 )
						{
							bPossiblyInCaseThree = false;
						}								
					}
					
					if ( !bPossiblyInCaseThree )
					{
						//playState.flanmap.mainLayer.setTile(contactXtile, contactYtile, 36);
						this.y -= 1 * Contact.height;
						this.last.y = this.y;	// this line is needed, otherwise a hitCeiling will be detected (which messes up this hack)
						
						return false;
					}
				}				
			}	
			
			//playState.flanmap.mainLayer.setTile(contactXtile, contactYtile, 35);
			return super.hitWall(Contact);
		}
		
		//@desc		Called when this object collides with the top of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitFloor(Contact:FlxCore = null):Boolean 
		{ 	
			if (Contact is Door )
				return hitDoor((Contact as Door));
				
			if (Contact is BoostSection )
				return hitBoost();			
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
			if (Contact is Pickup )
				return hitPickup((Contact as Pickup));
			
			if (Contact is Obstacle )
				return hitObstacle((Contact as Obstacle));
			
			var contactXtile:uint = Contact.x / 16;
			var contactYtile:uint = Contact.y / 16;			
			var tileIndex:uint = playState.flanmap.mainLayer.getTile(contactXtile, contactYtile);			
						
			if ( bIsSwinging )
			{	
				FlxG.log("hitFloor (" + tileIndex + ")");
				
				if ( tileIndex == 32 || tileIndex == 33 )
				{
					FlxG.log("hitFloor on slope..");
					hooks[prevHook].breakRelease();							
					bIsSwinging = false;
				}
				
				// bounce:
				//velocity.x = 0;
			}		
				
			status = ONGROUND;			
			jumpTime = 0;
			bDidDoubleJump = false;
			
			return super.hitFloor(Contact); 
		}
		
		//@desc		Called when this object collides with the bottom of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitCeiling(Contact:FlxCore = null):Boolean 
		{ 
			if (Contact is Door )
				return hitDoor((Contact as Door));
				
			if (Contact is BoostSection )
				return hitBoost();	
			
			if (Contact is Pickup )
				return hitPickup((Contact as Pickup));
			
			if ( Contact is Obstacle )
				return hitObstacle((Contact as Obstacle));
				
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
				
			FlxG.log("hitCeiling");
			
			if ( bIsSwinging )
			{
				//hooks[prevHook].breakRelease();
				
				this.velocity.x *= -1;
				this.velocity.y *= -1;
				this.acceleration.x *= -1;
				this.acceleration.y *= -1;
				
				return true;				
			}
				
			return super.hitCeiling(Contact);
		}
		
		
		// ugly hackish function, clean up:
		public function setHooks(hooks:Array):void
		{
			this.hooks = hooks;			
		}		
		
		public function isStumbling():Boolean
		{
			return bStumbling;
		}
	}
}
