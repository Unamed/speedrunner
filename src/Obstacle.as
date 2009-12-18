package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Obstacle extends FlxSprite
	{
		
		public function Obstacle(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.fixed = true;
			
		}
		
	}

}