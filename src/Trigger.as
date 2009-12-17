package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Trigger extends FlxSprite
	{
		
		public function Trigger(X:int=0,Y:int=0,SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			fixed = true;
		}
		
	}

}