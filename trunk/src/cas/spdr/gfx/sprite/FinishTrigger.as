package cas.spdr.gfx.sprite
{
	
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class FinishTrigger extends Trigger
	{
		public function FinishTrigger(X:int=0,Y:int=0,SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_FINISH), false, false, 32, 64);
		}	
	}
}