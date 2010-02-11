package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class BoostSection extends FlxSprite
	{		
		public function BoostSection(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			
			this.createGraphic(128, 32, 0xFF111199);
			this.fixed = true;
			
			this.width = 128;
			this.height = 32;
		}
		
	}

}