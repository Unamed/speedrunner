package cas.spdr.gfx.sprite 
{
	import cas.spdr.gfx.sprite.Trigger;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SuperBoostTrigger extends Trigger
	{		
		// 0: RIGHT
		// 1: DOWN RIGHT
		// 2: DOWN
		// 3: DOWN LEFT
		// 4: LEFT
		// 5: UP LEFT
		// 6: UP
		// 7: UP RIGHT
		public var boostDir:int;
		
		public function SuperBoostTrigger(X:int=0,Y:int=0,SimpleGraphic:Class=null)
		{
			super(X, Y);			
		}
		
	}

}