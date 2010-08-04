package cas.spdr.gfx.sprite 
{
	import cas.spdr.gfx.sprite.Trigger;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class UseTrigger extends Trigger
	{
		public var effect:String;
		
		public function UseTrigger(X:int = 0, Y:int = 0, SimpleGraphic:Class = null)
		{
			super(X, Y, SimpleGraphic);
			loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_USETRIGGER), false, false, 32, 64);
			effect = "";
			this.visible = true;
		}		
	}

}