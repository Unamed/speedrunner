package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class PlayerStart extends FlxSprite
	{
		
		public function PlayerStart(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			
			this.visible = false;
			this.dead = true;
		}
		
	}

}