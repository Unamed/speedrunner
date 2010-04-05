package cas.spdr.gfx.sprite
{
	import org.flixel.*;// FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Pickup extends FlxSprite
	{
		[Embed(source = "/../data/temp/pickup.png")] private var PickupIcon:Class;
		[Embed(source = "/../data/temp/coin_pickup2.mp3")] private var PickupSound:Class;
		
		public function Pickup(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			
			loadGraphic(PickupIcon,false, false,16,16);
			
		}
		
		public function PickedUp():void
		{
			this.visible = false;
			this.dead = true;
			
			// play sound.. (but not now :))
			//FlxG.play(PickupSound);
			
			// play pickup anim..	
		}	
	}
}