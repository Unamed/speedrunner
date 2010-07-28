package cas.spdr.actor 
{
	import org.flixel.FlxSprite;
	import cas.spdr.gfx.GraphicsLibrary;
	import org.flixel.fefranca.debug.FlxSpriteDebug;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Deathwall extends FlxSprite//Debug
	{
		
		public function Deathwall(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			loadGraphic( GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL), false, false, 2400, 600, false);
			
			width = 2400;
			height = 600;
		}
		
	}

}