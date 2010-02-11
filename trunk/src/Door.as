package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Door extends FlxSprite
	{
		[Embed(source = "../data/temp/door.png")] private var DoorIcon:Class;
		
		public var levelId:uint;
		
		public function Door(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			
			loadGraphic(DoorIcon,false, false,16,32);
		}		
	}
}