﻿package cas.spdr.gfx.sprite 
{
	import cas.spdr.gfx.sprite.SuperBoostTrigger;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SuperBoostTriggerDL extends SuperBoostTrigger
	{
		
		public function SuperBoostTriggerDL(X:int=0,Y:int=0,SimpleGraphic:Class=null)
		{
			super(X, Y);	
			boostDir = 3;
		}
		
	}

}