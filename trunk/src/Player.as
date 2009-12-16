package
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source="../data/temp/spaceman_new.png")] private var ImgSpaceman:Class;
		
		private var jumpPower:int;
		private var bUp:Boolean;
		private var bDown:Boolean;
		private var restart:Number;
		
		private var hooks:Array;
		private var curHook:uint;
		public var prevHook:uint;
		private var hookVel:int;
		
		public function Player(X:int, Y:int, hooks:Array)
		{
			super(X,Y);
			loadGraphic(ImgSpaceman,true,true,32);
			restart = 0;
			
			//bounding box tweaks
			width = 24;
			height = 28;
			offset.x = 4;
			offset.y = 4;
			
			//basic player physics
			var runSpeed:uint = 320;
			drag.x = runSpeed * 8;
			
			acceleration.y = 1680;
			jumpPower = 800;
			maxVelocity.x = runSpeed;
			maxVelocity.y = jumpPower;
			
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
			hookVel = 600;			
		}
		
		override public function update():void
		{
			
			var bUsedButtonForJump:Boolean = false;
			
			//game restart timer
			if(dead)
			{
				restart += FlxG.elapsed;
				if(restart > 2)
					FlxG.switchState(PlayState);
				return;
			}
			
			if ( hooks[prevHook].exists && !FlxG.keys.pressed("X") && !FlxG.keys.pressed("C") )
			{
				hooks[prevHook].release();				
			}
			
			//MOVEMENT
			acceleration.x = 0;			
			
			if ( hooks[prevHook].exists && hooks[prevHook].bCollided )
			{
				var hook:Hook = hooks[prevHook];
				
				var relX:Number = this.x - hook.x;
            	var relY:Number = this.y - hook.y;
            	var ropeAngle:Number = Math.atan2(relY, relX);
            	
				FlxG.log("ropAnge: " + ropeAngle);
				
				if ( ropeAngle < 0 )
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
					if (relSpeed.y < 0 )// {&& hook.isRopeTaut())
					{				
						relSpeed.y = 0;
					}
					//_relSpeed = relSpeed;
					
					// Convert back to polar in rope coordinate space.
					relSpeedAngle = Math.atan2(relSpeed.y, relSpeed.x);
					speedMagnitude = Point.distance(new Point(), relSpeed);
					// polar in main coordinate space
					speedAngle = relSpeedAngle + ropeAngle;
					// Cartesian in main coordinate space.
					this.velocity = Point.polar(speedMagnitude, speedAngle + Math.PI / 2);
					
					this.velocity.x *= 20;
					//this.velocity.y *= 1.5;
					
					//FlxG.log("Vel: " + velocity);
				}
				
				
				
				
			
			/*
				var hook:Hook = hooks[prevHook];
				
				var pPos:Point = new Point(x, y);
				var hPos:Point = new Point(hook.x, hook.y);
				
				var diff:Point = hPos.subtract(pPos);
				
				FlxG.log("DiffX: " + diff.x);
				
				if(FlxG.keys.LEFT)
				{
					facing = LEFT;
					
					if ( diff.x > 0 )
					{
						//hook.playerAccel.x += drag.x * 1.5 * Math.abs(diff.x / 50);
						//acceleration.x = hook.playerAccel.x;
						acceleration.x = drag.x * 0.5 * Math.abs(diff.x / 10);
					}
					else
					{
						//hook.playerAccel.x -= drag.x * 1.5;// 0.25 * Math.abs(diff.x / 500);
						//acceleration.x = hook.playerAccel.x;
						
						acceleration.x = drag.x * -1.5 * Math.abs(diff.x / 10);
					}				

				}
				if(FlxG.keys.RIGHT)
				{
					facing = RIGHT;
					
					if ( diff.x > 0 )
					{
						//hook.playerAccel.x += drag.x * 1.5 * Math.abs(diff.x / 50);
						//acceleration.x = hook.playerAccel.x;
						acceleration.x = drag.x * 1.5 * Math.abs(diff.x / 10);
					}
					else
					{
						//hook.playerAccel.x -= drag.x * 1.5;// 0.25 * Math.abs(diff.x / 500);
						//acceleration.x = hook.playerAccel.x;
						
						acceleration.x = drag.x * -0.5 * Math.abs(diff.x / 10);
					}			
				}
				
				
				
				
				velocity.y = 0;
				/*
				
				
				
				var pPos:Point = new Point(x, y);
				var hPos:Point = new Point(hook.x, hook.y);
				
				var diff:Point = hPos.subtract(pPos);
				
				hook.ropeLength = diff.length;
				
				
				//FlxG.log("rAngle: "+hook.ropeAngle);
			
				//hook.Length -= dT * 300.0f * grapplingPower;
                FlxG.log("ropeLength: "+ hook.ropeLength);
				
                var angularAccel:Number = -(40 / hook.ropeLength) * Math.sin(hook.ropeAngle);

                hook.angularSpeed += angularAccel * FlxG.elapsed;

                hook.ropeAngle += hook.angularSpeed;

                var diffX:Number = Math.sin(hook.ropeAngle) * -hook.ropeLength;
                var diffY:Number = Math.cos(hook.ropeAngle) * hook.ropeLength;

                var nPos:Point = hPos.add(new Point(diffX, diffY));
				
				var Position:Point = new Point(x, y);

                velocity = (nPos.subtract(Position));
				
				velocity.x /= FlxG.elapsed;
				velocity.y /= FlxG.elapsed;
				*/
				
			}
			else
			{				
				if(FlxG.keys.LEFT)
				{
					facing = LEFT;
					acceleration.x -= drag.x;
				}
				else if(FlxG.keys.RIGHT)
				{
					facing = RIGHT;
					acceleration.x += drag.x;
				}
				if(FlxG.keys.justPressed("X") && !velocity.y)
				{
					velocity.y = -jumpPower;
					bUsedButtonForJump = true;
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
			
			
			if ( FlxG.keys.justPressed("X") && velocity.y && !bUsedButtonForJump 
					|| FlxG.keys.justPressed("C")  )
			{
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;				
				
				//if(bUp)
				//{
					bY -= hooks[curHook].height - 4;
					bYVel = -hookVel;
				//}
				//else if(bDown)
				//{
				//	bY += height - 4;
				//	bYVel = hookVel;
				//	velocity.y -= 36;
				//}
				//else
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
			
			/* ROPE STUFF.. COPIED..
			 * 
			 *            //PLAYER PHYSICS WHEN AT END OF TAUT ROPE         
            if(_hook.state == _hook.LATCHED) {
            	// Calculate angle of rope relative to player.
            	var relX:Number = this.getCenterPoint().x - _hook.GetCornerPoint().x;
            	var relY:Number = this.getCenterPoint().y - _hook.GetCornerPoint().y;
            	var ropeAngle:Number = Math.atan2(relY, relX);
            	
            	// Convert player velocity to polar coordinates.
            	var speedAngle:Number = Math.atan2(this.velocity.y, this.velocity.x);
            	var speedMagnitude:Number = Point.distance(new Point(), this.velocity);
            	// Convert to polar coordinates relative to the rope instead of the origin.
            	var relSpeedAngle:Number = speedAngle - ropeAngle;
            	// Convert to cartesian in rope space.  Apply 90-degree rotation to think in terms of rope hanging downward.
            	var relSpeed:Point = Point.polar(speedMagnitude, relSpeedAngle - Math.PI/2);
            	
            	// Actually perform the transformation here.  The rope nullifies any speed directly pulling against it.
            	if (relSpeed.y < 0 && _hook.isRopeTaut()) {
            		relSpeed.y = 0;
            	}
				_relSpeed = relSpeed;
            	
            	// Convert back to polar in rope coordinate space.
            	relSpeedAngle = Math.atan2(relSpeed.y, relSpeed.x);
            	speedMagnitude = Point.distance(new Point(), relSpeed);
            	// polar in main coordinate space
            	speedAngle = relSpeedAngle + ropeAngle;
            	// Cartesian in main coordinate space.
            	this.velocity = Point.polar(speedMagnitude, speedAngle + Math.PI/2);            	            	

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
		
		override public function render():void
		{					
			super.render();	
			
			if ( hooks[prevHook].exists )
			{
				var line : Line;
				line = new Line(this, hooks[prevHook],2, 0x996600);
			
				line.render();
			}			
		}
	}
}