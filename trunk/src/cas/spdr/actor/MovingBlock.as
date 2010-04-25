package cas.spdr.actor
{
	import org.flixel.*;	
	
	public class MovingBlock extends Platform
	{
		protected static const SNAP_TO_DISTANCE:Number = 0.5;
		
		protected var verticalMovementDirection:int;
		protected var horizontalMovementDirection:int;
		protected var maxVerticalMovement:Number;
		protected var maxHorizontalMovement:Number;
		protected var verticalMovementSpeed:Number;
		protected var horizontalMovementSpeed:Number;				
		
		
		protected var xDir:int;		// 1 or -1 
		protected var yDir:int;		// 1 or -1
		
		
		protected var movementSpeed:Number;				
		protected var startX:Number;
		protected var startY:Number;
		protected var endY:Number;
		protected var endX:Number;
		
		protected var bMoving:Boolean;
		protected var bBounce:Boolean;
		
		//public function MovingBlock(maxVerticalMovement:Number, verticalMovementSpeed:Number, maxHorizontalMovement:Number, horizontalMovementSpeed:Number, X:int, Y:int, Width:uint, Height:uint, TileGraphic:Class, Empties:uint=0)
		public function MovingBlock(startX:int, startY:int, endX:int, endY:int, Width:uint, Height:uint, movementSpeed:Number, bBounce:Boolean, TileGraphic:Class, Empties:uint=0)
		{
			super(startX, startY, Width, Height);
			this.loadGraphic(TileGraphic, Empties);	
			
			this.startX = this.x;
			this.startY = this.y;
			this.endX = endX;
			this.endY = endY;
			
			if ( endY == startY )
				yDir = 0;
			else if ( endY > startY )
				yDir = 1;
			else	
				yDir = -1;
				
			if ( endX == startX )
				xDir = 0;
			else if ( endX > startX )
				xDir = 1;
			else	
				xDir = -1;
			
			this.movementSpeed = movementSpeed;
			this.bBounce = bBounce;
			
			this.bMoving = false;
			doMove();
		}
		
		public function doMove():void
		{
			this.bMoving = true;
			
		}
		
		public override function update():void
		{
			super.update();
			
			if ( !bMoving )
				return;
			
			this.x += xDir * movementSpeed * FlxG.elapsed;
			this.y += yDir * movementSpeed * FlxG.elapsed;
						
			if (this.x  >= this.endX )
			{
				this.x = this.endX;
				
				if( bBounce )
					xDir *= -1;
				else
					bMoving = false;
			}
			else if (this.x <= this.startX)
			{
				this.x = this.startX;
				if( bBounce )
					xDir *= -1;
				else
					bMoving = false;
			}
			
			if (this.y >= this.endY)
			{
				this.y = this.endY;
				if( bBounce )
					yDir *= -1;
				else
					bMoving = false;				
			}
			else if (this.startY <= this.y)
			{
				this.y = this.startY;
				if( bBounce )
					yDir *= -1;
				else
					bMoving = false;
			}			
		}
		
		/*
		override public function collide(Core:FlxCore):Boolean
		{			
			//Basic overlap check
			if( (Core.x + Core.width <= this.x) ||
				(Core.x >= this.x + this.width) ||
				(Core.y + Core.height + SNAP_TO_DISTANCE <= this.y) ||
				(Core.y >= this.y + this.height) )
				return false;
				
			// check to see from what direction we moved into the block
			var contactFromLeft:Boolean = Core.last.x + Core.width <= this.last.x && Core.x + Core.width > this.x;
			var contactFromRight:Boolean = Core.last.x >= this.last.x + this.width && Core.x < this.x + this.width;
			var contactFromBottom:Boolean = Core.last.y >= this.last.y + this.height && Core.y < this.y + this.height;
			var contactFromTop:Boolean = Core.last.y + Core.height <= this.last.y && Core.y + Core.height + SNAP_TO_DISTANCE > this.y;
			
			if (contactFromLeft || contactFromRight)
			{
				if (Core.hitWall(this))
				{
					if (contactFromLeft)
						Core.x = this.x - Core.width;
					else
						Core.x = this.x + this.width;
					
					Core.last.x = Core.x;
					return true;
				}
			}
			
			if (contactFromBottom)
			{
				if (Core.hitFloor(this))
				{
					Core.y = this.y + this.height;
					Core.last.y = Core.y;
					return true;
				}
			}
			
			if (contactFromTop)
			{
				if (Core.hitCeiling(this))
				{
					Core.y = this.y - Core.height;
					Core.last.y = Core.y;
					return true;
				}	
			}
			
			return false;
		}
		*/
	}
}