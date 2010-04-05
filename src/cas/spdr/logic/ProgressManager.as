package  cas.spdr.logic
{
	import cas.spdr.map.MapBase;
	import cas.spdr.map.MapTheHind;
	import cas.spdr.map.MapTheHydra;
	import cas.spdr.map.MapTheLion;
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
		
		private var lionGold:Number = 13.0;
		private var lionSilver:Number = 16.0;
		private var lionBronze:Number = 20.0;
		public var lionBest:Number;// = 99.99;
		
		private var hydraGold:Number = 13.0;
		private var hydraSilver:Number = 16.0;
		private var hydraBronze:Number = 20.0;
		public var hydraBest:Number;// = 99.99;
		
		private var hindGold:Number = 13.0;
		private var hindSilver:Number = 16.0;
		private var hindBronze:Number = 20.0;
		public var hindBest:Number;// = 99.99;
		
		public function ProgressManager() 
		{
			lionBest = 99.99;
			hydraBest = 99.99;
			hindBest = 99.99;
		}
		
		// Returns a party reason string value if finishing the level in playTime is worthy of throwing a party
		public function FinishedLevel(finishedLevel:MapBase, playTime:Number):String
		{			
			var sParty:String = "";	
			
			if ( getBestTime(finishedLevel) == 0 || playTime < getBestTime(finishedLevel) )
			{
				sParty = "New Record!";	
				setBestTime(finishedLevel, playTime);
			}			
			
			if ( playTime < getBronzeTime(finishedLevel) && UnlockPower(finishedLevel) )
			{
				if( finishedLevel is MapTheLion )
					sParty = "Unlocked Grappling Hook!";
			}
			else
			{			
				if ( playTime > getGoldTime(finishedLevel) )
				{
					if ( playTime > getSilverTime(finishedLevel) )
					{
						if ( playTime < getBronzeTime(finishedLevel) )
							sParty = "Bronze Medal!";						
					}
					else
						sParty = "Silver Medal!";
				}
				else 
					sParty = "Gold Medal!";
			}
			
			return sParty;
		}
		
		// Tries to unlock a power, corresponding to the finished level
		// returns true if something was unlocked
		public function UnlockPower(level:MapBase):Boolean
		{
			if ( level is MapTheLion && !bUnlockedHook )
			{
				// throw a party!
				bUnlockedHook = true;
				FlxG.saves[FlxG.save].write("bUnlockedHook", bUnlockedHook);
				return true;
			}				
			else 
				return false;
		}
		
		public function getGoldTime(level:MapBase):Number
		{
			if ( level is MapTheLion )
				return lionGold;
			else if ( level is MapTheHydra )
				return hydraGold;
			else if ( level is MapTheHind )
				return hindGold;
			else
				return 99;
			
		}
		
		public function getSilverTime(level:MapBase):Number
		{
			if ( level is MapTheLion )
				return lionSilver;
			else if ( level is MapTheHydra )
				return hydraSilver;
			else if ( level is MapTheHind )
				return hindSilver;
			else
				return 99;
		}
		
		public function getBronzeTime(level:MapBase):Number
		{
			if ( level is MapTheLion )
				return lionBronze;
			else if ( level is MapTheHydra )
				return hydraBronze;
			else if ( level is MapTheHind )
				return hindBronze;
			else
				return 99;
		}
		
		public function getBestTime(level:MapBase):Number
		{
			if ( level is MapTheLion )
				return lionBest;
			else if ( level is MapTheHydra )
				return hydraBest;
			else if ( level is MapTheHind )
				return hindBest;
			else
				return 99;
		}
		
		public function setBestTime(level:MapBase, playTime:Number):void
		{
			if ( level is MapTheLion )
			{
				lionBest = playTime;
				FlxG.saves[FlxG.save].write("lionBest", lionBest);
			}
			else if ( level is MapTheHydra )
			{
				hydraBest = playTime;
				FlxG.saves[FlxG.save].write("hydraBest", hydraBest);
			}
			else if ( level is MapTheHind )
			{
				hindBest = playTime;
				FlxG.saves[FlxG.save].write("hindBest", hindBest);				
			}			
		}
	}

}