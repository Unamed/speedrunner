package cas.spdr.state
{	
	import cas.spdr.actor.LevelInfoDialog;
	import cas.spdr.actor.MessageDialog;
	import cas.spdr.gfx.sprite.Door;
	import cas.spdr.gfx.sprite.Gate;
	import cas.spdr.map.MapMainMenu;
	import org.flixel.*;
	import flash.geom.Point;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class MainMenuState extends PlayState
	{		
		private var levelInfoMessage:MessageDialog;
		
		
		public function MainMenuState() 
		{
			flanmap = new MapMainMenu();	
			super();
			
			// Display best results over each level door
			for ( var i:uint = 0; i < this._layer.children().length; i++ )
			{
				if ( this._layer.children()[i] is Door )
				{
					var door:Door = ( this._layer.children()[i] as Door );	
					var bestResult:String = FlxG.progressManager.getBestResult(door.levelId);					
					var bestTime:int = FlxG.progressManager.getBestTime(door.levelId);					
					var tTxt:FlxText;
					
					if ( door.levelId == 4 || door.levelId == 8 || door.levelId == 12 || door.levelId == 13 )
					{
						if( FlxG.progressManager.hasFinishedChallenge(door.levelId) )
							tTxt = new FlxText(door.x - 20, door.y - 20, 100, "Completed");
						else
							tTxt = new FlxText(door.x - 20, door.y - 20, 100, "Challenge");
					}
					else
					{
						tTxt = new FlxText(door.x - 25, door.y - 20, 100, "Race " + door.levelId + ": " + bestResult);	
						
						if ( bestTime < FlxG.progressManager.getGoldTime(door.levelId) )
							tTxt.color = 0xFDD017;
						else if( bestTime < FlxG.progressManager.getSilverTime(door.levelId) )
							tTxt.color = 0xC0C0C0;
						else if( bestTime < FlxG.progressManager.getBronzeTime(door.levelId) )
							tTxt.color = 0xA67D3D;
						else 
							tTxt.color = 0x000000;
						
						
					}
					
					tTxt.size = 12;							
					tTxt.scrollFactor = new Point(1, 1);				
					this.add(tTxt);						
				}
			}
			
			
			// open any gates that should be opened:
			for ( var j:int = 0; j < this.gates.length; j++)
			{
				var g:Gate = (this.gates[j] as Gate);				
				switch( g.gateId )
				{
					case (1):
						if ( FlxG.progressManager.hasFinishedLevel(2) && FlxG.progressManager.hasFinishedLevel(3) )
							g.openGate();					
						break;					
					case (2):
						if ( FlxG.progressManager.hasFinishedLevel(5) && FlxG.progressManager.hasFinishedLevel(6) && FlxG.progressManager.hasFinishedLevel(7) )
							g.openGate();					
						break;
					case (3):
						if ( FlxG.progressManager.hasFinishedLevel(9) && FlxG.progressManager.hasFinishedLevel(10) && FlxG.progressManager.hasFinishedLevel(11) )
							g.openGate();					
						break;			
					case (4):
						if ( FlxG.progressManager.hasFinishedChallenge(4) )
							g.openGate();					
						break;			
					case (5):
						if ( FlxG.progressManager.hasFinishedChallenge(8) )
							g.openGate();					
						break;			
					case (6):
						if ( FlxG.progressManager.hasFinishedChallenge(12) )
							g.openGate();					
						break;				
				}
			}			
		}
		
		override public function addHUDElements():void
		{		
			super.addHUDElements();
			
			var gTxt:FlxText = new FlxText(910, 940, 500, 
				"Welcome to SpeedRunner Prototype v0.7" + "\n \n" + 
				"Controls: " + "\n" +
				"LEFT, RIGHT to move" + "\n" +
				"Z - (Double) Jump (when unlocked)" + "\n" +
				"X - Shoot Grappling Hook (when unlocked)" + "\n" +
				"DOWN - Slide" + "\n" +				
				"UP to enter door" + "\n" +
				"ESC to main menu" + "\n" +
				"SPACE to restart level" + "\n\n\n\n\n\n\n\n\n\n\n\n" +
				"Comments? Send them to: \ncaspervanest [at] gmail [dot] com"
				);			
			gTxt.size = 12;							
			gTxt.scrollFactor = new Point(1, 1);				
			this.add(gTxt);	
			
			
			var lTxt:FlxText = new FlxText(1480, 1250, 1000, 
				"The goal is to complete each race as quickly as possible \n"
				+ "Complete challenge levels to unlock new abilities!"								
				);			
			lTxt.size = 12;							
			lTxt.scrollFactor = new Point(1, 1);				
			this.add(lTxt);	
			
			
			var oTxt:FlxText = new FlxText(1960, 900, 500, "Use the grappling hook here, to reach levels 2 and 3    ->");			
			oTxt.size = 12;							
			oTxt.scrollFactor = new Point(1, 1);							
			this.add(oTxt);	
			
			var wTxt:FlxText = new FlxText(3300, 1270, 500, "     /\\ \n      |\n\nUnlock \nwalljumping \nto reach \nlevels 5 \nand beyond");			
			wTxt.size = 12;							
			wTxt.scrollFactor = new Point(1, 1);							
			this.add(wTxt);	
			
			var dTxt:FlxText = new FlxText(4660, 1010, 500, "Can't get on this platform? \nMake sure to complete the second challenge level!");			
			dTxt.size = 12;							
			dTxt.scrollFactor = new Point(1, 1);							
			this.add(dTxt);	
			
			/*
			var cTxt:FlxText = new FlxText(30, 170, 500, "Currency: " + FlxG.progressManager.getCredits());				
			cTxt.size = 12;							
			cTxt.scrollFactor = new Point(0, 0);				
			this.add(cTxt);	
			*/
			
			levelInfoMessage = new LevelInfoDialog();
			levelInfoMessage.addMeToState(this);
			levelInfoMessage.visible = true;
		}
		
		override public function addGameElements():void
		{	
			// re-define playerStart, if coming from a level:
			if ( FlxG.prevLevel > 0 )
			{
				for ( var i:uint = 0; i < this._layer.children().length; i++ )
				{
					if ( this._layer.children()[i] is Door )
					{
						var door:Door = ( this._layer.children()[i] as Door );	
						
						if ( door.levelId == FlxG.prevLevel )
						{
							// this is the door next to which the player should start
							playerStartX = door.x - 25;
							playerStartY = door.y;							
						}						
					}
				}				
			}
			
			super.addGameElements();
		}
		
		public function showLevelInfo( levelId:int):void
		{	
			// dont show popup if already showing
			if ( levelInfoMessage.bPlaying )
				return;
			
			switch( levelId )
			{
				case 4:
					levelInfoMessage.playMessage( " Challenge", 
						"Use your grappling hook \nto stay ahead of the Wall of Doom" );
					break;
				case 8:
					levelInfoMessage.playMessage( " Challenge", 
						"Use your walljumping abilities \nto stay ahead of the Floor of Doom" );
					break;
				case 12:
					levelInfoMessage.playMessage( " Challenge", 
						"Use your doublejumping skills \nto stay ahead of the Wall of Doom" );
					break;
				case 13:
					levelInfoMessage.playMessage( "Final Challenge", 
						"Use all your skills \nin an ultimate test" );
					break;
				default:
					levelInfoMessage.playMessage(
						"    Race " + levelId, 
						" Best time: " + FlxG.progressManager.getBestTime(levelId).toFixed(2) + "\n" +
						" Needed for gold: " + FlxG.progressManager.getGoldTime(levelId).toFixed(2));
					break;				
			}			
		}
		
		public function showUseTriggerInfo( triggerEffect:String ):void
		{			
			if ( !levelInfoMessage.bPlaying )
			{
				switch( triggerEffect )
				{
					case "Hook":
						if ( !FlxG.progressManager.HasUnlockedHook() )
						{
							levelInfoMessage.playMessage(
								"Unlock Grappling Hook",
								"Costs: " + FlxG.progressManager.GetCost(0));					
						}
						else
						{
							levelInfoMessage.playMessage("Grappling Hook is Unlocked", "Use X to shoot Hook at white surfaces"); 
						}	
						break;
						
					case "Wall":
						if ( !FlxG.progressManager.HasUnlockedWalljump() )
						{
							levelInfoMessage.playMessage(
								"Unlock Walljumping",
								"Costs: " + FlxG.progressManager.GetCost(1));					
						}
						else
						{
							levelInfoMessage.playMessage("Walljumping Unlocked", "Jump at white surface to stick"); 
						}	
						break;
						
					case "Slide":
						if ( !FlxG.progressManager.HasUnlockedSlide() )
						{
							levelInfoMessage.playMessage(
								"Unlock Sliding",
								"Costs: " + FlxG.progressManager.GetCost(2));					
						}
						else
						{
							levelInfoMessage.playMessage("Sliding is Unlocked", "Press DOWN to Slide"); 
						}	
						break;
						
					case "DoubleJump":
						if ( !FlxG.progressManager.HasUnlockedDoubleJump() )
						{
							levelInfoMessage.playMessage(
								"Unlock Doublejump",
								"Costs: " + FlxG.progressManager.GetCost(3));					
						}
						else
						{
							levelInfoMessage.playMessage("Doublejump is Unlocked", "Press Z in the air to Doublejump"); 
						}	
						break;
						
					case "Reverse":				
						//if ( !FlxG.progressManager.HasUnlockedHook() )
						//{
						//	levelInfoMessage.playMessage(
						//		"Unlock Grappling Hook",
						//		"Costs: " + FlxG.progressManager.getCost(0));					
						//}
						//else
						//{
							levelInfoMessage.playMessage("Bonus: Reverse Mode", "Play all levels in reverse"); 
						//}	
						break;
						
					
					
				}
				
			}			
		}
	}
}