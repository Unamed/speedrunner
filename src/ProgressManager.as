package  
{
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class ProgressManager
	{
		public var bUnlockedHook:Boolean;
		public var bUnlockedWallJump:Boolean;
		public var bUnlockedSlide:Boolean;
		public var bUnlockedSuperJump:Boolean;
		
		public var nCollectedPickups:uint = 0;
		
		private var lionGold:Number = 16.0;
		private var lionSilver:Number = 19.0;
		private var lionBronze:Number = 25.0;
		
		
		
		public function ProgressManager() 
		{
			
		}
		
		// Returns true if finishing the level in playTime is worthy of throwing a party
		public function FinishedLevel(finishedLevel:MapBase, playTime:Number):Boolean
		{			
			var bThrowParty:Boolean = false;
			
			
			if ( finishedLevel is MapTheLion )
			{
				if ( playTime < lionBronze )
				{
					bThrowParty = UnlockHook();
				}
				
			}
			
			return bThrowParty;
		}
		
		public function UnlockHook():Boolean
		{
			if ( !bUnlockedHook )
			{
				// throw a party!
				bUnlockedHook = true;
				
				return true;
			}
			return false;
			
		}
		
	}

}