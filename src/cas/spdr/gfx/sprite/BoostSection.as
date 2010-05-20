package cas.spdr.gfx.sprite
{
	import org.flixel.FlxSprite;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class BoostSection extends FlxSprite
	{		
		//[Embed(source = "/../data/temp/BoostSection.png")] private var BoostImg:Class;
		
		public function BoostSection(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			
			//this.createGraphic(128, 32, 0xFF111199);
			//this.loadGraphic(BoostImg, false, false, 128, 50, false);
			this.loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_BOOST), false, false, 128, 50, false);
			this.fixed = true;
			
			this.width = 128;
			this.height = 32;
		}	
	}
}