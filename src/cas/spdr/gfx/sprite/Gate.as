package cas.spdr.gfx.sprite 
{
	import org.flixel.FlxSprite;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * Used to allow ro disallow access to a certain area.
	 * @author ...
	 */
	public class Gate extends FlxSprite
	{
		public var gateId:uint;
		
		public function Gate(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y + 8, SimpleGraphic);
			
			loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_GATE), true, false, 16, 96);
			this.fixed = true;
			
			this.addAnimation("open", [0, 0, 0, 0, 0, 1, 2, 3, 4, 5], 24, false);
			
		}
		
		public function openGate():void
		{
			//this.visible = false;
			//this.active = false; 
			this.dead = true;
			
			
			play("open");
			
		}
		
	}

}