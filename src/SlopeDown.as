package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SlopeDown extends FlxSprite
	{
		[Embed(source = "../data/temp/tile_slope_down.png")] private var SlopeTile:Class;
				
		public function SlopeDown(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.loadGraphic(SlopeTile, false, false, 16, 16, false);
			
			this.fixed = true;
			
			//this.alpha = 0.70;
		}
		
	}

}