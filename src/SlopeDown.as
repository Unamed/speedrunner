package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SlopeDown extends FlxSprite
	{
		
		public function SlopeDown(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.fixed = true;
			
			//this.alpha = 0.70;
		}
		
	}

}