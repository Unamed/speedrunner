package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import flash.geom.Point;
	
	import SWFStats.*;
	
	
	/**
	 * LevelState is a PlayState in which stuff like timers are present. They are not present in the main menu
	 * @author Casper van Est
	 */
	public class LevelState extends PlayState
	{			
		private var timerTxt:FlxText;	
		private var finTxt:FlxText;	
		
		private var gTxt:FlxText;	
		private var sTxt:FlxText;	
		private var bTxt:FlxText;			
		private var bestTxt:FlxText;
		
		private var playTime:Number;		
		private var bIsTiming:Boolean;
		private var bIsPaused:Boolean;
		
		private var maps:Array;		
		private var currentMapIndex:uint;	
		
		
		public function LevelState() 
		{	
			playTime = 0;
			bIsTiming = false;			
			
			super();					
		}
		
		override public function initLevel():void
		{	
			flanmap = new FlxG.levels[FlxG.level];
			super.initLevel();			
		}
		
		public function switchToMainMenu():void 
		{
			FlxG.switchState(MainMenuState);				
		}
		
		public function restartLevel():void
		{			
			FlxG.switchState(LevelState);			
		}		
		
		override public function addHUDElements():void
		{		
			super.addHUDElements();
			
			// TEXTS:
			timerTxt = new FlxText(500, 10, 200, "Timer");
			timerTxt.size = 15;							
			timerTxt.scrollFactor = new Point(0, 0);				
			this.add(timerTxt);	
			
			finTxt = new FlxText(250, 250, 500, "Congratulations!");			
			finTxt.size = 25;							
			finTxt.scrollFactor = new Point(0, 0);
			finTxt.visible = false;
			this.add(finTxt);
			
			// goals:
			gTxt = new FlxText(10, 10, 400, "Gold: " + FlxG.progressManager.getGoldTime(flanmap).toFixed(2));			
			gTxt.size = 15;							
			gTxt.scrollFactor = new Point(0, 0);				
			this.add(gTxt);	
			
			sTxt = new FlxText(10, 35, 400, "Silver: " + FlxG.progressManager.getSilverTime(flanmap).toFixed(2));			
			sTxt.size = 15;							
			sTxt.scrollFactor = new Point(0, 0);				
			this.add(sTxt);	
			
			bTxt = new FlxText(10, 60, 400, "Bronze: " + FlxG.progressManager.getBronzeTime(flanmap).toFixed(2));			
			bTxt.size = 15;							
			bTxt.scrollFactor = new Point(0, 0);				
			this.add(bTxt);	
			
			bestTxt = new FlxText(10, 100, 400, "Best: " + FlxG.progressManager.getBestTime(flanmap).toFixed(2));			
			bestTxt.size = 15;							
			bestTxt.scrollFactor = new Point(0, 0);				
			this.add(bestTxt);	
		}	
		
		override public function update():void
		{
			if( !bIsPaused )
				super.update();
			
			if( bIsTiming )
				playTime += FlxG.elapsed;		
			
			timerTxt.text = "Timer: " + playTime.toFixed(2);	
			
			// Various Input
			if ( FlxG.keys.justPressed("ESC") )
			{
				switchToMainMenu();	
			}	
			else if ( FlxG.keys.justPressed("SPACE") )
			{
				restartLevel();
			}
		}
		
		public function startTimer():void
		{
			playTime = 0;
			bIsTiming = true;			
			
			//tracker.trackPageview("/started");// "/FisherGirl");
			//tracker.trackEvent("Timing Events", "Started", "Label", playTime );	
			
			
		}
		
		public function stopTimer():void
		{
			bIsTiming = false;
			//tracker.trackEvent("Timing Events", "Finished", "Label", playTime );				
			
			//SWFStats.LevelMetrics.Log("Finished", currentMapIndex+1);
			//SWFStats.LevelMetrics.LogRanged("CompletionTime", currentMapIndex+1, playTime);				
						
			finTxt.text = FlxG.progressManager.FinishedLevel(flanmap, playTime);
			finTxt.visible = true;
			
			bIsPaused = true;			
		}		
	}
}
