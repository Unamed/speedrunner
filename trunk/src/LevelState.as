package  
{
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
		private var playTime:Number;		
		private var bIsTiming:Boolean;
		
		private var maps:Array;		
		private var currentMapIndex:uint;		
		
		public function LevelState() 
		{			
			maps = new Array();		
			// 0 - The Lion
			// 1 - The Hydra
			// 2 - The The Hind
			maps.push(MapTheLion);
			maps.push(MapTheHydra);
			maps.push(MapTheHydra);
			
			currentMapIndex = 0;
			
			flanmap = new maps[currentMapIndex];
			super();
			
			playTime = 0;		
		}
		
		override public function initLevel():void
		{	
			flanmap = new maps[currentMapIndex];
			super.initLevel();			
		}
		
		public function switchToMap(mapIndex:uint):void
		{
			currentMapIndex = mapIndex;
			resetLevel();	
			
			SWFStats.LevelMetrics.Log("Started", currentMapIndex+1);
		}
		
		public function switchToMainMenu():void 
		{
			FlxG.switchState(MainMenuState);				
		}
		
		
		override public function addHUDElements():void
		{		
			super.addHUDElements();
			
			// TEXTS:
			timerTxt = new FlxText(300, 100, 200, "Timer");
			timerTxt.scrollFactor = new Point(0, 0);	
			timerTxt.size = 15;				
			
			this.add(timerTxt);			
		}	
		
		override public function update():void
		{
			super.update();
			
			if( bIsTiming )
				playTime += FlxG.elapsed;		
			
			timerTxt.text = "Timer: " + playTime.toFixed(2);	
			
			// Various Input
			if ( FlxG.keys.justPressed("ESC") )
			{
				switchToMainMenu();	
				
				// test, deze hoort eigelijk bij de finish..
				SWFStats.LevelMetrics.LogRanged("CompletionTime", currentMapIndex+1, playTime);		

			}
			
			
		}
		
		public function startTimer():void
		{
			FlxG.log("Start Timer");
			playTime = 0;
			bIsTiming = true;			
			
			//tracker.trackPageview("/started");// "/FisherGirl");
			//tracker.trackEvent("Timing Events", "Started", "Label", playTime );	
			
			
		}
		
		public function stopTimer():void
		{
			bIsTiming = false;
			//tracker.trackEvent("Timing Events", "Finished", "Label", playTime );	
			
			SWFStats.LevelMetrics.Log("Finished", currentMapIndex+1);
		}	
		
		override public function resetLevel():void 
		{
			super.resetLevel();
			bIsTiming = false;
			playTime = 0;
		}
		
	}
}
