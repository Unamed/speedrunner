package  cas.spdr.logic
{
	import cas.spdr.map.*;
	import cas.spdr.state.PlayState;
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class ProgressManager
	{
		private var unlockedPowers:Array; 	//Booleans
		private var unlockCosts:Array; 		//Ints
		
		private var goldRewards:Array; 		//Ints
		private var silverRewards:Array; 	//Ints
		private var bronzeRewards:Array; 	//Ints
		
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
		
		private static var defaultPickupString:String = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
		
		public function ProgressManager() 
		{
			unlockedPowers = new Array();			
			unlockCosts = new Array();			
			goldTimes = new Array();
			silverTimes = new Array();
			bronzeTimes = new Array();
			goldRewards = new Array();
			silverRewards = new Array();
			bronzeRewards = new Array();			
			bestTimes = new Array();
			
			unlockedPowers[0] = false;	//hook
			unlockedPowers[1] = false;	//walljump
			unlockedPowers[2] = false;	//slide
			unlockedPowers[3] = false;	//doublejump
			unlockedPowers[4] = false;	//reverse-mode	
			
			unlockCosts[0] = 50;	//hook
			unlockCosts[1] = 100;	//walljump
			unlockCosts[2] = 300;	//slide
			unlockCosts[3] = 300;	//doublejump
			unlockCosts[4] = 1000;	//reverse-mode	
			
			goldTimes[0] = 1.0;	//MainMenu
			goldTimes[1] = 15.0;	//Lion
			goldTimes[2] = 13.0;	//Hydra
			goldTimes[3] = 15.0;	//Hind
			goldTimes[4] = 1.0;	
			goldTimes[5] = 20.0;	
			goldTimes[6] = 16.0;	
			goldTimes[7] = 16.0;	
			goldTimes[8] = 1.0;	
			goldTimes[9] = 25.0;	
			goldTimes[10] = 18.0;	
			goldTimes[11] = 34.0;	
			goldTimes[12] = 1.0;	
			goldTimes[13] = 1.0;	
			goldTimes[14] = 1.0;	
			goldTimes[15] = 1.0;	
			
			silverTimes[0] = 1.0;	//MainMenu
			silverTimes[1] = 17.0;	//Lion
			silverTimes[2] = 15.0;	//Hydra
			silverTimes[3] = 17.0;	//Hind
			silverTimes[4] = 1.0;	
			silverTimes[5] = 23.0;	
			silverTimes[6] = 19.0;	
			silverTimes[7] = 19.0;	
			silverTimes[8] = 1.0;	
			silverTimes[9] = 30.0;	
			silverTimes[10] = 21.0;	
			silverTimes[11] = 42.0;	
			silverTimes[12] = 1.0;	
			silverTimes[13] = 1.0;	
			silverTimes[14] = 1.0;	
			silverTimes[15] = 1.0;	
			
			bronzeTimes[0] = 1.0;	//MainMenu
			bronzeTimes[1] = 20.0;	//Lion
			bronzeTimes[2] = 18.0;	//Hydra
			bronzeTimes[3] = 20.0;	//Hind
			bronzeTimes[4] = 1.0;	
			bronzeTimes[5] = 28.0;	
			bronzeTimes[6] = 24.0;	
			bronzeTimes[7] = 24.0;	
			bronzeTimes[8] = 1.0;	
			bronzeTimes[9] = 40.0;	
			bronzeTimes[10] = 26.0;	
			bronzeTimes[11] = 50.0;	
			bronzeTimes[12] = 1.0;	
			bronzeTimes[13] = 1.0;	
			bronzeTimes[14] = 1.0;	
			bronzeTimes[15] = 1.0;	
			
			goldRewards[0] = 0;	//MainMenu
			goldRewards[1] = 25;	//Lion
			goldRewards[2] = 25;	//Hydra
			goldRewards[3] = 25;	//Hind
			goldRewards[4] = 25;	
			goldRewards[5] = 25;	
			goldRewards[6] = 25;	
			goldRewards[7] = 25;	
			goldRewards[8] = 25;	
			goldRewards[9] = 25;	
			goldRewards[10] = 25;	
			goldRewards[11] = 25;	
			goldRewards[12] = 25;	
			goldRewards[13] = 25;	
			goldRewards[14] = 25;	
			goldRewards[15] = 25;	
			
			silverRewards[0] = 0;	//MainMenu
			silverRewards[1] = 25;	//Lion
			silverRewards[2] = 25;	//Hydra
			silverRewards[3] = 25;	//Hind
			silverRewards[4] = 25;	
			silverRewards[5] = 25;	
			silverRewards[6] = 25;	
			silverRewards[7] = 25;	
			silverRewards[8] = 25;	
			silverRewards[9] = 25;	
			silverRewards[10] = 25;	
			silverRewards[11] = 25;	
			silverRewards[12] = 25;	
			silverRewards[13] = 25;	
			silverRewards[14] = 25;	
			silverRewards[15] = 25;	
			
			bronzeRewards[0] = 0;	//MainMenu
			bronzeRewards[1] = 50;	//Lion
			bronzeRewards[2] = 60;	//Hydra
			bronzeRewards[3] = 60;	//Hind
			bronzeRewards[4] = 70;	
			bronzeRewards[5] = 70;	
			bronzeRewards[6] = 80;	
			bronzeRewards[7] = 80;	
			bronzeRewards[8] = 80;	
			bronzeRewards[9] = 80;	
			bronzeRewards[10] = 80;	
			bronzeRewards[11] = 80;	
			bronzeRewards[12] = 80;	
			bronzeRewards[13] = 80;	
			bronzeRewards[14] = 80;	
			bronzeRewards[15] = 80;	
			
			bestTimes[0] = 99.0;	//MainMenu
			bestTimes[1] = 99.0;	//Lion
			bestTimes[2] = 99.0;	//Hydra
			bestTimes[3] = 99.0;	//Hind
			bestTimes[4] = 99.0;	
			bestTimes[5] = 99.0;	
			bestTimes[6] = 99.0;	
			bestTimes[7] = 99.0;	
			bestTimes[8] = 99.0;	
			bestTimes[9] = 99.0;	
			bestTimes[10] = 99.0;	
			bestTimes[11] = 99.0;	
			bestTimes[12] = 99.0;	
			bestTimes[13] = 99.0;	
			bestTimes[14] = 99.0;	
			bestTimes[15] = 99.0;	
			
			nCollectedPickups = 0;
			nUsedPickups = 0;
			collectedPickups = new Array();
			collectedPickups[0] = "0";
			collectedPickups[1] = defaultPickupString;
			collectedPickups[2] = defaultPickupString;
			collectedPickups[3] = defaultPickupString;
			collectedPickups[4] = defaultPickupString;
			collectedPickups[5] = defaultPickupString;
			collectedPickups[6] = defaultPickupString;
			collectedPickups[7] = defaultPickupString;
			collectedPickups[8] = defaultPickupString;
			collectedPickups[9] = defaultPickupString;
			collectedPickups[10] = defaultPickupString;
			collectedPickups[11] = defaultPickupString;
			collectedPickups[12] = defaultPickupString;
			collectedPickups[13] = defaultPickupString;
			collectedPickups[14] = defaultPickupString;
			collectedPickups[15] = defaultPickupString;
			
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
		
		public function GetCost(powerId:int):int
		{
			return unlockCosts[powerId];
		}
		
		public function pickedUp(index:int, levelId:int, value:int):void
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
			nCollectedPickups+=value;
			
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
		
		// Saves the best time, if it was set
		// returns true if a new power was unlocked
		public function FinishedLevel(levelId:int, playTime:Number):Boolean
		{	
			//var receivedCredits:int = 0;
			
			// if the new time is better than the previous best, 
			// find out how much money I get for this time, 
			// using previous best result:
			if ( getBestTime(levelId) == 0 || playTime < getBestTime(levelId) )
			{
				/*
				if ( playTime < getGoldTime(levelId) )
				{					
					receivedCredits += getBestTime(levelId) > getGoldTime(levelId) ? goldRewards[levelId] : 0;
					receivedCredits += getBestTime(levelId) > getSilverTime(levelId) ? silverRewards[levelId] : 0;
					receivedCredits += getBestTime(levelId) > getBronzeTime(levelId) ? bronzeRewards[levelId] : 0;					
				}
				else if ( playTime < getSilverTime(levelId) )
				{
					receivedCredits += getBestTime(levelId) > getSilverTime(levelId) ? silverRewards[levelId] : 0;
					receivedCredits += getBestTime(levelId) > getBronzeTime(levelId) ? bronzeRewards[levelId] : 0;	
				}
				else if ( playTime < getBronzeTime(levelId) )
				{					
					receivedCredits += getBestTime(levelId) > getBronzeTime(levelId) ? bronzeRewards[levelId] : 0;					
				}*/
									
				// finally, set new best time:
				setBestTime(levelId, playTime);
			}
			
			// add to credits:
			//nCollectedPickups += receivedCredits;
			//return receivedCredits;	
			
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
					msg = "Unlocked Grappling Hook!";
				else if ( levelId == 4 )
					msg = "Unlocked WallJump!";								
				else if ( levelId == 8 )
					msg = "Unlocked DoubleJump!";
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
			else if ( levelId == 4 )
				msg = "Jump onto white walls to hold on, and jump away again with Z";
			//else if ( levelId == 4 || levelId == 5 )
			//	msg = "Slide under obstacles by holding DOWN";					
			else if ( levelId == 8 )
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
				case (4):
					return UnlockWalljump();
					break;
				case (8):
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
		
		// returns whether or not the level<levelId>, which should be a challenge level, was completed at least once
		public function hasFinishedChallenge(levelId:int):Boolean
		{
			return ( getBestTime(levelId) < 99 );
		}
		
		public function upgradeSetting(effect:String):void
		{			
			switch( effect )
			{
				/*
				case "speed":
					if ( deductCredits(10) )
						speedLevel++;
					break;
				case "accel":
					if ( deductCredits(10) )
						accelLevel++;
					break;
					*/
				case "Hook":
					if ( !HasUnlockedHook() && deductCredits(unlockCosts[0]) )
						UnlockHook();
					break;				
				case "Wall":
					if ( !HasUnlockedWalljump() && deductCredits(unlockCosts[1]) )
						UnlockWalljump();
					break;
				case "Slide":
					if ( !HasUnlockedSlide() && deductCredits(unlockCosts[2]) )
						UnlockSlide();
					break;
				case "DoubleJump":
					if ( !HasUnlockedDoubleJump() && deductCredits(unlockCosts[3]) )
						UnlockDoubleJump();
					break;
				case "Reverse":				
					FlxG.log("Heyyoo");
					break;
			}
			
			//queueSave("speedLevel", speedLevel);
			//queueSave("accelLevel", accelLevel);
			queueSave("nUsedPickups", nUsedPickups);
			(FlxG.state as PlayState).switchToMainMenu();
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
		
		public function getPickedUp(levelId:int):int
		{
			var pickupStr:String = collectedPickups[levelId];
			
			var cnt:int = 0;
			for ( var i:int = 0; i < pickupStr.length; i++ )
			{
				if ( pickupStr.charAt(i) == "1" )
					cnt++;				
			}
			
			return cnt;
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
				collectedPickups[k] = defaultPickupString;
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
		
		
		
		// OBSOLETE:
		public function getSpeedLevel():int
		{			
			return speedLevel;
		}
		
		public function getAccelLevel():int
		{			
			return accelLevel;
		}
	}
}