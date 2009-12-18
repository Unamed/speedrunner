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
		
		private var swingSpeed:uint = 1.70 * runSpeed; //1.30 * runSpeed bij snel
		
		private var jumpTime:Number;
		private var maxJumpTime:Number = 0.25;
		
		private var fallAccel:Number = 32 * size;
		
		private var bWalling:Boolean;
		
		public var playState:PlayState;
		
		private var push:Point; // the force applied by input
		
		public function Player(X:int, Y:int, hooks:Array)
		{
			super(X,Y);
			loadGraphic(ImgSpaceman,true,true,16,32);
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
			
			this.hooks = hooks;			
			curHook = 0;
		}
		
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
			maxVelocity.x = runSpeed;
			
			
			
			// IF SWINGING:
			if ( hooks[prevHook].exists && hooks[prevHook].bCollided )
			{
				var hook:Hook = hooks[prevHook];
				
				var relX:Number = this.x - hook.x;
            	var relY:Number = this.y - hook.y;
				var ropeAngle:Number = Math.atan2(relY, relX);
				
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
			else if ( bWalling )
			{
				velocity.x = 0;
				velocity.y = 0;
				
				
				
				if(FlxG.keys.LEFT)
					facing = LEFT;
				else if(FlxG.keys.RIGHT)
					facing = RIGHT;				
								
				// JUMPING:
				if( FlxG.keys.justPressed("X") )
				{
					bWalling = false;					
						
					if ( facing == RIGHT )
						velocity.x += jumpPower * 8;
					else
						velocity.x -= jumpPower * 8;
				}				
			}
			else
			{				
				// "NORMAL" MOVEMENT
				// In air:
				if ( velocity.y )
				{
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
					jumpTime += FlxG.elapsed;
					
					if ( jumpTime < maxJumpTime )
						velocity.y -= ((maxJumpTime - jumpTime) / maxJumpTime) * jumpPower * FlxG.elapsed;
				}
				else if ( velocity.y)
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
			
			/* ROPE COLLISION STUFF.. COPIED..
			 * 
            if(_hook.state == _hook.LATCHED) {
            	//**********************************************************
				//ROPE CORNER COLLISIONS FOR PLAYER PHYSICS PURPOSES
				if(_hook.COLLIDE_ROPE) {
						// Eliminate old collision points
						while(_hook.cornerPoints.length > 1) {
							const USE_SPEED_SIDE:Boolean = false;
							
							// Last corner, and next-to-last corner.  The relation of these two corners determines the
							// ray we need to compare the player's position with to determine if the rope is no longer colliding.
							// Another way of looking at this is that we need to recreate the context of when the last corner
							// did not exist to redetermine if it should exist. 						
							var lastCorner:Point = _hook.cornerPoints[_hook.cornerPoints.length - 1];
							var baseCorner:Point = _hook.cornerPoints[_hook.cornerPoints.length - 2];
							
							// The angle of the last corner relative to the next-to-last.
							var cornerAngle:Number = Math.atan2(lastCorner.y - baseCorner.y, lastCorner.x - baseCorner.x);
							// The angle of the player relative to the next-to-last.  It needs to be on the same scale as the previous one.
							var playerAngle:Number = Math.atan2(this.getCenterPoint().y - baseCorner.y, this.getCenterPoint().x - baseCorner.x);

                            // Which side of the ray collides?
							var collideSide:Boolean = _hook.cornerDirs[_hook.cornerDirs.length - 1].x > 0;

							// Option to take speed into account in case position alone is flaky							
							if(USE_SPEED_SIDE) {
								// The speed angle of the player relative to the next-to-last.
								var relSpeedCornerAngle:Number = speedAngle - playerAngle;
								// Convert to cartesian in next-to-last space.
								var relSpeedCorner:Point = Point.polar(speedMagnitude, relSpeedCornerAngle - Math.PI/2);
								var speedSide:Boolean =  relSpeedCorner.x > 0;
								if(collideSide == speedSide) break;
							}

                            // Calculate angle of player relative to angle of ray representing the collision
							var angleDiff:Number = (playerAngle - cornerAngle);
							// Bring angle difference back into [-Pi,Pi] interval
							if(angleDiff < -Math.PI) { angleDiff += Math.PI*2; } else if(angleDiff > Math.PI) { angleDiff -= Math.PI*2; } 

                            // Which side of the ray is the player on?
							var playerSide:Boolean = angleDiff > 0;
							
							if(collideSide != playerSide) {
								_hook.cornerPoints.pop();
								_hook.cornerDirs.pop();
							} else {
								break;
							}
						}	
					
						// Create new collision points
						var cornerPos:Point = _hook.GetCornerPoint();
						var playerPos:Point = this.getCenterPoint();
						var ropeCollidePt:Point = _hook._tilemap.collideRope(cornerPos, playerPos, relSpeed);
						if(ropeCollidePt) {
							_hook.cornerPoints.push(ropeCollidePt);
							_hook.cornerDirs.push(relSpeed); // keep track of relSpeed at time of creation only for elimination
						}
				}
            }
			 * */
			
				
			//UPDATE POSITION AND ANIMATION
			super.update();			
		}
		
		private function hitTrigger(Contact:Trigger):Boolean 
		{
			if ( Contact is StartTrigger )
			{				
				playState.startTimer();								
			}
			
			else if ( Contact is FinishTrigger )
			{				
				playState.stopTimer();				
			}
			
			return false;
			
		}
		
		//@desc		Called when this object collides with a FlxBlock on one of its sides
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			if ( Contact is Obstacle )
			{
				FlxG.log("YEAS EEN OBSTAC");
				this.y -= Contact.height;
			}
			
			
			if ( bIsSwinging )
			{
				hooks[prevHook].breakRelease();
				velocity.y -= 8 * jumpPower;
			}
			
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
			else if ( velocity.y )
			{
				//bWalling = true;	
				
				//velocity.y = 0;
				//jumpTime = 0;
				
				/*
				this.y -= Contact.height;
				
				if ( Contact is FlxBlock )
					FlxG.log("was block");
				else if ( Contact is FlxTilemap )
					FlxG.log("was tilemap");
				else if (Contact is FlxSprite )
					FlxG.log("was sprite");
				
				FlxG.log(Contact.height);
				*/
				
			}
				
			return super.hitWall(Contact);
		}
		
		//@desc		Called when this object collides with the top of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitFloor(Contact:FlxCore = null):Boolean 
		{ 			
			jumpTime = 0;			
			
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
				
			return super.hitFloor(Contact); 
		}
		
		//@desc		Called when this object collides with the bottom of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitCeiling(Contact:FlxCore = null):Boolean 
		{ 
			if ( bIsSwinging )
				hooks[prevHook].breakRelease();
				
			if ( Contact is Trigger )
				return hitTrigger((Contact as Trigger));
				
			return super.hitCeiling(Contact);
		}
				
			
		
		override public function render():void
		{					
			super.render();	
			
			if ( hooks[prevHook].exists )
			{
				var line : Line;
				if ( hooks[prevHook].bCollided )
					line = new Line(this, hooks[prevHook], 2, 0x999999);
				else
					line = new Line(this, hooks[prevHook], 2, 0x996600);
			
				line.render();
			}			
		}
	}
}