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
		private var collectedPickups:Array;	//Strings
		private var nCollectedPickups:int;		
		
		private var nUsedPickups:int;
		private var speedLevel:int;
		private var accelLevel:int;
		
		private var mySave:FlxSave;
		
		private var saveQueueItems:Array;	//Used to store the first part of save orders until the level is finished
		private var saveQueueObjects:Array;	//Used to store the second part of save orders until the level is finished		
		
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
			goldTimes[1] = 09.0	//Lion
			goldTimes[2] = 14.0	//Hydra
			goldTimes[3] = 13.0	//Hind
			goldTimes[4] = 20.0	
			goldTimes[5] = 25.0	
			goldTimes[6] = 20.0	
			goldTimes[7] = 20.0	
			
			silverTimes[0] = 99.0	//MainMenu
			silverTimes[1] = 13.0	//Lion
			silverTimes[2] = 18.0	//Hydra
			silverTimes[3] = 16.0	//Hind
			silverTimes[4] = 25.0	
			silverTimes[5] = 30.0	
			silverTimes[6] = 30.0	
			silverTimes[7] = 30.0	
			
			bronzeTimes[0] = 99.0	//MainMenu
			bronzeTimes[1] = 20.0	//Lion
			bronzeTimes[2] = 25.0	//Hydra
			bronzeTimes[3] = 20.0	//Hind
			bronzeTimes[4] = 35.0	
			bronzeTimes[5] = 50.0	
			bronzeTimes[6] = 40.0	
			bronzeTimes[7] = 40.0	
			
			bestTimes[0] = 99.0	//MainMenu
			bestTimes[1] = 99.0	//Lion
			bestTimes[2] = 99.0	//Hydra
			bestTimes[3] = 99.0	//Hind
			bestTimes[4] = 99.0	
			bestTimes[5] = 99.0	
			bestTimes[6] = 99.0	
			bestTimes[7] = 99.0	
			
			nCollectedPickups = 0;
			nUsedPickups = 0;
			collectedPickups = new Array();
			collectedPickups[0] = "0";
			collectedPickups[1] = "00000000000000000000000000000000000000000000000000";
			collectedPickups[2] = "00000000000000000000000000000000000000000000000000";
			collectedPickups[3] = "00000000000000000000000000000000000000000000000000";
			collectedPickups[4] = "00000000000000000000000000000000000000000000000000";
			collectedPickups[5] = "00000000000000000000000000000000000000000000000000";
			collectedPickups[6] = "00000000000000000000000000000000000000000000000000";
			collectedPickups[7] = "00000000000000000000000000000000000000000000000000";
			
			saveQueueItems = new Array();
			saveQueueObjects = new Array();
			
			speedLevel = 1;
			accelLevel = 1;
			
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
			queueSave("unlocked0", unlockedPowers[0]);
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
			queueSave("unlocked1", unlockedPowers[1]);
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
			queueSave("unlocked2", unlockedPowers[2]);
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
			queueSave("unlocked3", unlockedPowers[3]);
			return true;
		}
		
		public function pickedUp(index:int, levelId:int):void
		{						
			// retreive data for specified level
			var oldStr:String = (collectedPickups[levelId] as String);
			
			// only continue if this pickup wasn't already collected
			if ( int(oldStr.charAt( index )) > 0 )
				return;
			
			// replace char at index:
			var newStr:String = oldStr.substring(0, index);
			newStr += "1";
			newStr += oldStr.substring(index + 1, oldStr.length);			
			
			// store
			collectedPickups[levelId] = newStr;	
			nCollectedPickups++;
			
			// save to file:
			queueSave("pickups" + levelId, collectedPickups[levelId] );
			queueSave("nPickups", nCollectedPickups);
		}		
		
		public function getCollectedPickups(levelId:int):String
		{
			return collectedPickups[levelId];			
		}
		
		public function getCredits():int
		{
			return nCollectedPickups - nUsedPickups;
		}
		
		public function getSpeedLevel():int
		{			
			return speedLevel;
		}
		
		public function getAccelLevel():int
		{			
			return accelLevel;
		}
		
		// Saves the best time, if it was set
		// returns true if a new power was unlocked
		public function FinishedLevel(levelId:int, playTime:Number):Boolean
		{	
			// first set the best time
			if ( getBestTime(levelId) == 0 || playTime < getBestTime(levelId) )
				setBestTime(levelId, playTime);
			
			// then see if this unlocks a new power
			if ( playTime < getBronzeTime(levelId) && TryUnlockPower(levelId) )
				return true;
			
			return false;			
		}
		
		
		public function getFinishedMessage(levelId:int, playTime:Number, bUnlockedAPower:Boolean):String
		{
			var msg:String = "Level Complete!";	
			
			if ( getBestTime(levelId) == 0 || playTime < getBestTime(levelId) )
				msg = "New Record!";					
			
			if ( bUnlockedAPower )
			{				
				if( levelId == 1 )
					msg = "Unlocked Magnet Swing!";
				else if ( levelId == 2 || levelId == 3 )
					msg = "Unlocked Magnet Gloves!";
				else if ( levelId == 4 || levelId == 5 )
					msg = "Unlocked Sliding!";					
				else if ( levelId == 6 )
					msg = "Unlocked Double Jumping!";
			}
			else
			{	
				if ( playTime < getGoldTime(levelId) )
					msg = "Gold Medal!";
				else if( playTime < getSilverTime(levelId) )
					msg = "Silver Medal!";
				else if ( playTime < getBronzeTime(levelId) )
					msg = "Bronze Medal!";
			}
			
			return msg;		
		}
		
		public function getUnlockedPowerMessageForLevel(levelId:int):String
		{
			var msg:String = "";
						
			if( levelId == 1 )
				msg = "Shoot the magnet at white surfaces by holding X and swing!";
			else if ( levelId == 2 || levelId == 3 )
				msg = "Jump onto white walls to hold on, and jump away again with Z";
			else if ( levelId == 4 || levelId == 5 )
				msg = "Slide under obstacles by holding DOWN";					
			else if ( levelId == 6 )
				msg = "Cross large gaps by double jumping, press Z while in the air";
			
			return msg;		
		}
		
		// Tries to unlock a power, corresponding to the finished level
		// returns true if something was unlocked
		public function TryUnlockPower(levelId:int):Boolean
		{
			switch( levelId ) 
			{
				case (1):
					return UnlockHook();				
					break;
				case (2):
				case (3):
					if( hasFinishedLevel(2) && hasFinishedLevel(3) )
						return UnlockWalljump();
					break;
				case (4):
				case (5):
					if( hasFinishedLevel(4) && hasFinishedLevel(5) )
						return UnlockSlide();
					break;
				case (6):
					return UnlockDoubleJump();
					break;
				default:
					return false;
			}
			
			return false;
		}
		
		// Returns whether or not a bronze medal was achieved on level<levelId> 
		public function hasFinishedLevel(levelId:int):Boolean
		{
			return ( getBestTime(levelId) < getBronzeTime(levelId) );
		}
		
		public function upgradeSetting(effect:String):void
		{
			FlxG.log("speedLevel was: " + speedLevel);
			FlxG.log("accelLevel was: " + accelLevel);
			
			switch( effect )
			{
				case "speed":
					if ( deductCredits(10) )
						speedLevel++;
					break;
				case "accel":
					if ( deductCredits(10) )
						accelLevel++;
					break;				
			}
			
			FlxG.log("speedLevel is now: " + speedLevel);
			FlxG.log("accelLevel is now: " + accelLevel);
			
			
			queueSave("speedLevel", speedLevel);
			queueSave("accelLevel", accelLevel);
			queueSave("nUsedPickups", nUsedPickups);
		}
		
		public function deductCredits( amount:int = 0 ):Boolean
		{
			if ( nUsedPickups + amount <= nCollectedPickups )
			{
				nUsedPickups += amount;
				return true;
			}
			
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
		
		public function getBestResult(levelId:int):String
		{
			if ( levelId < bestTimes.length )
			{
				if ( bestTimes[levelId] < goldTimes[levelId] )
					return "Gold";
				else if( bestTimes[levelId] < silverTimes[levelId] )
					return "Silver";
				else if( bestTimes[levelId] < bronzeTimes[levelId] )
					return "Bronze";
				else
					return " - ";
			}
			else
				return " - ";
		}
		
		public function setBestTime(levelId:int, playTime:Number):void
		{			
			bestTimes[levelId] = playTime;			
			queueSave("best"+levelId, playTime);			
		}		
		
		public function queueSave(FieldName:String,FieldValue:Object):void
		{
			saveQueueItems.push(FieldName);
			saveQueueObjects.push(FieldValue);
		}
		
		public function executeSaves():void
		{
			for ( var i:int = 0; i < saveQueueItems.length; i++ )
			{
				FlxG.saves[FlxG.save].write(saveQueueItems[i], saveQueueObjects[i] );					
			}
			
			saveQueueItems = new Array();
			saveQueueObjects = new Array();
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
				var bTime:Number = (save.read("best" + j) as Number);
				if( bTime > 0.00 )
					bestTimes[j] = bTime;
			}
			
			for ( var k:int = 0; k < collectedPickups.length; k++ )
			{
				var data:String = (save.read("pickups" + k) as String);
				if ( data != null )
					collectedPickups[k] = data;
			}
			
			nCollectedPickups = (save.read("nPickups") as int);
			nUsedPickups = (save.read("nUsedPickups") as int);
			speedLevel = Math.max( (save.read("speedLevel") as int), 1);
			accelLevel = Math.max( (save.read("accelLevel") as int), 1);
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
			
			for ( var k:int = 0; k < collectedPickups.length; k++ )
			{
				collectedPickups[k] = "00000000000000000000000000000000000000000000000000";
			}
			
			nCollectedPickups = 0;
			nUsedPickups = 0;
			speedLevel = 1;
			accelLevel = 1;			
			
			if ( mySave != null )
			{
				return mySave.erase();
			}
			
			return false;
		}
	}
}