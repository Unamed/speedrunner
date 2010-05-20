package cas.spdr.gfx.sprite
{
	import org.flixel.FlxSprite;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Door extends FlxSprite
	{
		public var levelId:uint;
		
		public function Door(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
		
			loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DOOR), false, false, 32, 64);
		}		
	}
}