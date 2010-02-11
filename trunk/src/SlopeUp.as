package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SlopeUp extends FlxSprite
	{
		[Embed(source = "../data/temp/tile_slope_up.png")] private var SlopeTile:Class;
		
		public function SlopeUp(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.loadGraphic(SlopeTile, false, false, 16, 16, false);
			this.fixed = true;
			
			//this.alpha = 0.70;
		}
		
	}

}