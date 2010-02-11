package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Obstacle extends FlxSprite
	{
		[Embed(source = "../data/temp/obstacle.png")] private var ObstacleIcon:Class;

		public function Obstacle(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.loadGraphic(ObstacleIcon,false,false,16,16);
			
			this.fixed = true;			
		}		
	}
}