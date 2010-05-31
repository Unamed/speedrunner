package cas.spdr.gfx.sprite
{
	import org.flixel.FlxSprite;
	import cas.spdr.gfx.GraphicsLibrary;
	import org.flixel.fefranca.debug.FlxSpriteDebug;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Obstacle extends FlxSprite//Debug
	{
		

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
	}
}