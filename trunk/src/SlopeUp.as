package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SlopeUp extends FlxSprite
	{
		
		public function SlopeUp(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.fixed = true;
			
			//this.alpha = 0.70;
		}
		
	}

}