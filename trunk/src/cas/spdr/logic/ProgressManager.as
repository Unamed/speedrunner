package  cas.spdr.logic
{
	import cas.spdr.map.*;
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class ProgressManager
	{
		private var unlockedPowers:Array; 	//Booleans
		
		private var goldTimes:Array; 		//Numbers
		private var silverTimes:Array; 		//Numbers
		private var bronzeTimes:Array; 		//Numbers
		private var bestTimes:Array; 		//Numbers
		
		private var mySave:FlxSave;
		
		// Test:
		public var nCollectedPickups:uint = 0;
		
		public function ProgressManager() 
		{
			unlockedPowers = new Array();			
			goldTimes = new Array();
			silverTimes = new Array();
			bronzeTimes = new Array();
			bestTimes = new Array();
			
			unlockedPowers[0] = false;	//hook
			unlockedPowers[1] = false;	//walljump
			unlockedPowers[2] = false;	//slide
			unlockedPowers[3] = false;	//doublejump
			unlockedPowers[4] = false;	//TBA			
			
			goldTimes[0] = 99.0	//MainMenu
			goldTimes[1] = 13.0	//Lion
			goldTimes[2] = 13.0	//Hydra
			goldTimes[3] = 13.0	//Hind
			goldTimes[4] = 20.0	//L4
			goldTimes[5] = 25.0	//L5
			
			silverTimes[0] = 99.0	//MainMenu
			silverTimes[1] = 16.0	//Lion
			silverTimes[2] = 16.0	//Hydra
			silverTimes[3] = 16.0	//Hind
			silverTimes[4] = 25.0	//L4
			silverTimes[5] = 30.0	//L5
			
			bronzeTimes[0] = 99.0	//MainMenu
			bronzeTimes[1] = 20.0	//Lion
			bronzeTimes[2] = 20.0	//Hydra
			bronzeTimes[3] = 20.0	//Hind
			bronzeTimes[4] = 35.0	//L4
			bronzeTimes[5] = 50.0	//L5
			
			bestTimes[0] = 99.0	//MainMenu
			bestTimes[1] = 99.0	//Lion
			bestTimes[2] = 99.0	//Hydra
			bestTimes[3] = 99.0	//Hind
			bestTimes[4] = 99.0	//L4
			bestTimes[5] = 99.0	//L5
		}
		
		public function HasUnlockedHook():Boolean
		{
			return unlockedPowers[0];			
		}
		
		public function UnlockHook():Boolean
		{
			if ( HasUnlockedHook() )
				return false;
				
			unlockedPowers[0] = true;
			FlxG.saves[FlxG.save].write("unlocked0", unlockedPowers[0]);
			return true;
		}
		
		public function HasUnlockedWalljump():Boolean
		{
			return unlockedPowers[1];			
		}
		
		public function UnlockWalljump():Boolean
		{
			if ( HasUnlockedWalljump() )
				return false;
				
			unlockedPowers[1] = true;
			FlxG.saves[FlxG.save].write("unlocked1", unlockedPowers[1]);
			return true;
		}
		
		public function HasUnlockedSlide():Boolean
		{
			return unlockedPowers[2];			
		}
		
		public function UnlockSlide():Boolean
		{
			if ( HasUnlockedSlide() )
				return false;
				
			unlockedPowers[2] = true;
			FlxG.saves[FlxG.save].write("unlocked2", unlockedPowers[2]);
			return true;
		}
		
		public function HasUnlockedDoubleJump():Boolean
		{
			return unlockedPowers[3];			
		}
		
		public function UnlockDoubleJump():Boolean
		{
			if ( HasUnlockedDoubleJump() )
				return false;
				
			unlockedPowers[3] = true;
			FlxG.saves[FlxG.save].write("unlocked3", unlockedPowers[3]);
			return true;
		}
		
		
		public function FinishedLevel(levelId:int, playTime:Number):String
		{
			var sParty:String = "";	
			
			if ( getBestTime(levelId) == 0 || playTime < getBestTime(levelId) )
			{
				sParty = "New Record!";	
				setBestTime(levelId, playTime);
			}			
			
			if ( playTime < getBronzeTime(levelId) && TryUnlockPower(levelId) )
			{
				if( levelId == 1 )
					sParty = "Unlocked Grappling Hook!";
				else if ( levelId == 2 || levelId == 3 )
					sParty = "Unlocked Wall Jumping!";
				else if ( levelId == 4 )
					sParty = "Unlocked Sliding!";					
				else if ( levelId == 5 )
					sParty = "Unlocked Double Jumping!";
			}
			else
			{			
				if ( playTime > getGoldTime(levelId) )
				{
					if ( playTime > getSilverTime(levelId) )
					{
						if ( playTime < getBronzeTime(levelId) )
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
		public function TryUnlockPower(levelId:int):Boolean
		{
			if ( levelId == 1 )
				return UnlockHook();				
			else if ( levelId == 2 || levelId == 3 )
				return UnlockWalljump();
			else if ( levelId == 4 )
				return UnlockSlide();
			else if ( levelId == 5 )
				return UnlockDoubleJump();
			else 
				return false;
		}
		
		public function getGoldTime(levelId:int):Number
		{
			if( levelId < goldTimes.length )
				return goldTimes[levelId];
			else
				return 99.99;
		}
		
		public function getSilverTime(levelId:int):Number
		{
			if( levelId < silverTimes.length )
				return silverTimes[levelId];
			else
				return 99.99;
		}
		
		public function getBronzeTime(levelId:int):Number
		{
			if( levelId < bronzeTimes.length )
				return bronzeTimes[levelId];
			else
				return 99.99;
		}
		
		public function getBestTime(levelId:int):Number
		{
			if( levelId < bestTimes.length )
				return bestTimes[levelId];
			else
				return 99.99;
		}
		
		public function setBestTime(levelId:int, playTime:Number):void
		{			
			bestTimes[levelId] = playTime;			
			FlxG.saves[FlxG.save].write("best"+levelId, playTime);			
		}
		
		public function readSaveData(save:FlxSave):void
		{
			mySave = save;
			
			for ( var i:int = 0; i < unlockedPowers.length; i++ )
			{
				unlockedPowers[i] = (save.read("unlocked"+i) as Boolean);
			}
			
			for ( var j:int = 0; j < bestTimes.length; j++ )
			{
				bestTimes[j] = (save.read("best"+j) as Number);
			}			
		}
		
		public function clearSaveData():Boolean
		{
			for ( var i:int = 0; i < unlockedPowers.length; i++ )
			{
				unlockedPowers[i] = false;
			}
			
			for ( var j:int = 0; j < bestTimes.length; j++ )
			{
				bestTimes[j] = 99.99;
			}		
			
			if ( mySave != null )
			{
				return mySave.erase();
			}
			
			return false;
		}
	}
}