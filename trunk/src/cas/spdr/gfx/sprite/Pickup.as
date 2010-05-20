package cas.spdr.gfx.sprite
{
	import cas.spdr.state.PlayState;
	import org.flixel.*;// FlxSprite;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Pickup extends FlxSprite
	{		
		[Embed(source = "/../data/temp/coin_pickup2.mp3")] private var PickupSound:Class;
		
		public function Pickup(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_COIN_PICKUP), false, false, 16, 16);
		}
		
		public function PickedUp(state:PlayState):void
		{
			if ( !dead )
			{
				// inform progress manager I've been picked up:
				// first, find my index:
				var index:int = state.getPickupIndex(this);
				FlxG.progressManager.pickedUp(index, FlxG.level);
				
				// play sound.. (but not now :))				
				//FlxG.play(PickupSound);
				
				// play pickup anim..		
				
			}
			
			// disable me:
			this.visible = false;
			this.dead = true;
		}	
		
		public function PreviouslyPickedUp():void
		{
			// display a different graphic:
			loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_COIN_PICKUP_ALT), false, false, 16, 16);
		}
	}
}