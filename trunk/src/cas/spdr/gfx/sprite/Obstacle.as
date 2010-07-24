package cas.spdr.gfx.sprite
{
	import flash.geom.Point;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import cas.spdr.gfx.GraphicsLibrary;
	import org.flixel.fefranca.debug.FlxSpriteDebug;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Obstacle extends FlxSprite//Debug
	{
		private var bHit:Boolean;

		public function Obstacle(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y-8, SimpleGraphic);			
			this.loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_OBSTACLE), false, false, 24, 24);
			
			this.offset.x = 3;
			this.offset.y = 8;
			
			this.width = 16;
			this.height = 16;
			
			this.fixed = true;	
		}		
		
		public function onHit( playerVelocity:Point ):void
		{
			velocity.y = -250;
			velocity.x = playerVelocity.x;
			acceleration.y = 700;
			angle = -30;
			
			bHit = true;
			dead = true;
			
		}
		
		override public function update():void
		{
			super.update();
			
			if ( bHit )
			{
				this.alpha = Math.max(0, alpha - FlxG.elapsed * 1);
				
			}
		
		}
	}
}