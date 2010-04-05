package cas.spdr.gfx.sprite
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Obstacle extends FlxSprite
	{
		[Embed(source = "/../data/temp/obstacle.png")] private var ObstacleIcon:Class;

		public function Obstacle(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y-8, SimpleGraphic);
			this.loadGraphic(ObstacleIcon, false, false, 24, 24);
			
			this.offset.x = 4;
			this.offset.y = 8;
			
			this.fixed = true;			
		}		
	}
}