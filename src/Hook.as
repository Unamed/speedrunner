package  
{
	import flash.geom.Point;
	import org.flixel.FlxSprite;
	import org.flixel.FlxCore;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Hook extends FlxSprite
	{		
		[Embed(source = "../data/temp/hook.png")] private var ImgHook:Class;
		
		public var bCollided:Boolean;
		public var playerAccel:Point;
		
		public var ropeLength:uint;
		
		
		public var ropeAngle:Number;
		public var angularSpeed:Number;
			
		public function Hook()
		{
			super();
			loadGraphic(ImgHook);	
			exists = false;
			bCollided = false;
			
			playerAccel = new Point(0, 0);
		}
		
		public function shoot(X:int, Y:int, VelocityX:int, VelocityY:int):void
		{			
			super.reset(X, Y);
			
			bCollided = false;
			
			velocity.x = VelocityX;
			velocity.y = VelocityY;	
			exists = true;
		}	
		
		//@desc		Called when this object collides with a FlxBlock on one of its sides
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitWall(Contact:FlxCore=null):Boolean { return collided(); }
		
		//@desc		Called when this object collides with the top of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitFloor(Contact:FlxCore=null):Boolean { return collided(); }
		
		//@desc		Called when this object collides with the bottom of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		override public function hitCeiling(Contact:FlxCore = null):Boolean { return collided(); }
		
		private function collided():Boolean
		{
			velocity.x = 0;
			velocity.y = 0;	
			bCollided = true;	
			
			playerAccel.x = 500;
			return true;			
		}
		
		public function release():void 
		{
			super.reset(0, 0);
			
			bCollided = false;
			
			velocity.x = 0;
			velocity.y = 0;	
			exists = false;			
		}
		
		/*
		 
		// Calls f(p, [more args...]) on each pixel p in a line between the points 'first' and 'last'.
		// If f returns an object, then terminates immediately and return that; if f returns null, then continues.
		public function doForLinePoints(first:Point, last:Point, f:Function, argArray:Array):* 
		{			
			var dx:Number = last.x - first.x;
			var dy:Number = last.y - first.y;
			var dist:Number = Math.sqrt((dx * dx) + (dy * dy));
			
			argArray.unshift(null);
			
			for (var i:Number = 0; i <= 1; i += 1 / dist) 
			{
				var xDiff:int = (dx < 0) ? Math.ceil(dx * i) : Math.floor(dx * i);
				var yDiff:int = (dy < 0) ? Math.ceil(dy * i) : Math.floor(dy * i);

				argArray[0] = new Point(first.x + xDiff - this.x, first.y + yDiff - this.y);
				var r:* = f.apply(this, argArray);
				
				if (r) 
					return r; 				
			}
			
			return null;
		}

		// Collide straight rope with obstacles for purposes of player physics/straight rope drawing.
		public function collideRope(first:Point, last:Point, relSpeed:Point) : Point 
		{
			function collideRopePoint(p:Point, relSpeed:Point, dx:Number, dy:Number) : Point 
			{
				var ix:uint = Math.floor(p.x/_tileSize);
				var iy:uint = Math.floor(p.y/_tileSize);

				if(isCollideTile(ix, iy)) 
				{
					var xpos:uint = ix*_tileSize;
					var ypos:uint = iy*_tileSize;

					function hasTopLeftCorner():Boolean { return !isCollideTile(ix-1,iy) && !isCollideTile(ix,iy-1); }
					function hasTopRightCorner():Boolean { return !isCollideTile(ix+1,iy) && !isCollideTile(ix,iy-1); }
					function hasBottomLeftCorner():Boolean { return !isCollideTile(ix-1,iy) && !isCollideTile(ix,iy+1); }
					function hasBottomRightCorner():Boolean { return !isCollideTile(ix+1,iy) && !isCollideTile(ix,iy+1); }

					// Use the orientation of the rope (NW,NE,SW or SE) and the direction of player velocity to logically
					// deduce which corner of a rope must be hitting.
					if (relSpeed && relSpeed.x < 0) 
					{
						if(dx < 0 && dy > 0 && hasTopLeftCorner()) { xpos--; ypos--; }
						else if(dx < 0 && dy < 0 && hasTopRightCorner()) { xpos += _tileSize; ypos--; }
						else if(dx > 0 && dy > 0 && hasBottomLeftCorner()) { xpos--; ypos += _tileSize; }
						else if(dx > 0 && dy < 0 && hasBottomRightCorner()) { xpos += _tileSize; ypos += _tileSize; }
						else return null;
					} 
					else 
					{
						if(dx > 0 && dy < 0 && hasTopLeftCorner()) { xpos--; ypos--; }
						else if(dx > 0 && dy > 0 && hasTopRightCorner()) { xpos += _tileSize; ypos--; }
						else if(dx < 0 && dy < 0 && hasBottomLeftCorner()) { xpos--; ypos += _tileSize; }
						else if(dx < 0 && dy > 0 && hasBottomRightCorner()) { xpos += _tileSize; ypos += _tileSize; }
						else return null;
					}
					return new Point(xpos, ypos);
				}
				
				return null;
			}
			
			var dx:Number = last.x - first.x;
			var dy:Number = last.y - first.y;
			
			return doForLinePoints(first, last, collideRopePoint, [relSpeed, dx, dy]);
		}
		*/
	}

}