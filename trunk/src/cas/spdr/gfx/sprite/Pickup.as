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
		
		private var value:int = 1;
		public var colorVal:String = "bronze";
		
		public function Pickup(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_COIN_PICKUP), true, false, 16, 64);
			
			this.offset.y = 48;
			this.height = 16;
			this.y -= 48;
			
			this.addAnimation("idle", [0], 0, false);
			this.addAnimation("pickedUp", [1, 2, 3,4,5,6,7], 24, false);
			
			play("idle");
			
			//value = Math.round(Math.random() * 2) + 1;
		}
		
		public function PickedUp(state:PlayState):void
		{
			if ( !dead )
			{
				// inform progress manager I've been picked up:
				// first, find my index:
				var index:int = state.getPickupIndex(this);
				FlxG.progressManager.pickedUp(index, FlxG.level, value);
				
				// play sound.. 			
				FlxG.play(PickupSound);
				
				// play pickup anim..
				play("pickedUp");
				
			}
			
			// disable me:
			//this.visible = false;
			this.dead = true;
		}	
		
		public function SetColorAndValue():void
		{
			switch( colorVal )
			{
				case "bronze":
					this.color = 0xDD4444;
					this.value = 1;
					break;
				case "silver": 
					this.color = 0xFFFFFF;
					this.value = 2;
					break;
				case "gold":
					this.color = 0xFFFF00;
					this.value = 4;
					break;
			}
		}
		
		public function PreviouslyPickedUp():void
		{
			// display a different graphic:
			//loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_COIN_PICKUP_ALT), false, false, 16, 16);
			
			this.alpha = 0;
			this.dead = true;
			//this.color = 0xFF0000;
			
			
			//this.color = 0x0000FF;
			//this.color = 0x0000FF;
			//this.color = 0x00FF00;
			
			//this.y += 48;
			//this.offset.y = 0;
		}		
	}
}