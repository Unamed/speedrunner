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
		
		public function Deathwall(X:int, Y:int, W:int, H:int, SimpleGraphic:Class) 
		{
			super(X, Y, SimpleGraphic);
			loadGraphic( SimpleGraphic, false, false, W, H, false);
			
			width = W;
			height = H;
		}
		
	}

}