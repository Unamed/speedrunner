package cas.spdr.gfx.sprite 
{
	import cas.spdr.gfx.sprite.Trigger;
	
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
			effect = "";
		}		
	}

}