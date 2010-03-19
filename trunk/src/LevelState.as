package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import flash.geom.Point;
	import flash.display.Shape;
	
	import SWFStats.*;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	//import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;	
	import flash.events.*;

	
	
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
		
		public var playTime:Number;		
		private var bIsTiming:Boolean;
		private var bIsPaused:Boolean;
		
		private var maps:Array;		
		private var currentMapIndex:uint;	
		
		// LOGGING:
		private var logCntDwn:Number;
		private var logInterval:Number = 0.5;
		private var positions:String;		
		private var allPositions:Array;
		private var bShouldLog:Boolean;		
		private var colorArray:Array = new Array(0xFFFF33, 0xFFFFFF, 0x79DCF4, 0xFF3333, 0xFFCC33, 0x99CC33);
		private var bDrawMyOwn:Boolean = true; // decided whether or not I also want to see the commits from my own IP
		
		public function LevelState() 
		{	
			playTime = 0;
			bIsTiming = false;	
			
			// logging:
			logCntDwn = logInterval;
			positions = "";			
			allPositions = new Array();			
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
				
			// logging:
			if ( bShouldLog )
			{
				logCntDwn -= FlxG.elapsed;
				if ( logCntDwn <= 0 )
				{
					logCntDwn = logInterval;
					logPlayerPosition();				
				}
			}
			
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
			
			bShouldLog = true;
			
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
			
			if( bShouldLog )
				sendLogToServer();
			bShouldLog = false;		
			
			//bIsPaused = true;			
		}		
		
		private function logPlayerPosition():void
		{			
			positions += Math.round(player.x) + "," + Math.round(player.y) + "-";			
		}
		
		private function sendLogToServer():void
		{			
			var url:String = "http://www.progamestudios.com/casgames/spdr_stats/position_stats.php";
			var sendLoader:URLLoader = new URLLoader();
			var sendVars:URLVariables = new URLVariables();
			
			sendLoader.addEventListener(Event.COMPLETE, sendComplete);
			sendLoader.addEventListener(IOErrorEvent.IO_ERROR, sendError);			
			
			var track:String = FlxG.level.toString();
			var version:String = FlxG.VERSIONID.toString();
			var time:String = Math.round(playTime).toString();
			var data:String = positions;
			var hash:String = MD5.calcMD5("slowcrawler" + time + data);							
			
			var sendRequest:URLRequest = new URLRequest(url + "?action=submit"+"&track="+track+"&version="+version+"&time="+time+"&hash="+hash+"&data="+data);
			
			// now send:
			sendRequest.method = URLRequestMethod.POST;
			sendLoader.load(sendRequest);
			
			function sendComplete(evt:Event):void
			{
				trace("Message sent. Loading data..");
				
				var request:URLRequest = new URLRequest(url);
				var variables:URLVariables = new URLVariables();
				variables.action = "show";
				variables.track = FlxG.level.toString();
				variables.version = FlxG.VERSIONID.toString();
				request.data = variables;				

				var loadLoader:URLLoader = new URLLoader();
				loadLoader.addEventListener(Event.COMPLETE, loadComplete);
				request.method = URLRequestMethod.POST;
				loadLoader.load(request);				
				
				function loadComplete(event:Event):void
				{
					FlxG.log("Data Received.. ");    
					
					var i:int;
					var msg:String = event.target.data.replace("data=","");
					var arr:Array = msg.split(";");
					for (i = 0; i < arr.length-1; i+=4 )
					{
						var dbId:int = int(arr[i]);
						var userId:int = int(arr[i + 1]);
						var completionTime:int = int(arr[i + 2]); 
						var data:String = arr[i + 3];
						FlxG.log("positions[" + i/4 + "]: " + data);
						
						if ( data.indexOf("-", 0) > 0)
						{
							if( userId != 1 || bDrawMyOwn)
								allPositions.push(data);
						}
					}
				}
			}
			function sendError(evt:IOErrorEvent):void
			{
				trace("Message failed: "+evt.text);
			}			
		}
		
		// overridden to draw log-lines, if neccessary
		override public function render():void
		{		
			super.render();
			
			if ( !bShouldLog && positions.length > 0 )
			{				
				drawLog();
			}				
		}
		
		// draws all position-lines
		private function drawLog():void
		{
			var j:int;
			for (j = 0; j < allPositions.length; j++ )
			{
				var posArr:Array = allPositions[j].split("-");
				
				var colorId:int = j % colorArray.length;
				var color:int = colorArray[colorId];				
				
				var i:int;			
				for (i = 1; i < posArr.length-1; i++ )
				{
					var drawShape:Shape = new Shape();					
					drawShape.graphics.lineStyle(2, color);
					
					var locArr1:Array = posArr[i-1].split(",");
					var locArr2:Array = posArr[i].split(",");
					
					var xLoc1:Number = Number(locArr1[0]);
					var yLoc1:Number = Number(locArr1[1]);
					var xLoc2:Number = Number(locArr2[0]);
					var yLoc2:Number = Number(locArr2[1]);
					
					drawShape.graphics.moveTo(xLoc1 + FlxG.scroll.x, yLoc1 + FlxG.scroll.y);
					drawShape.graphics.lineTo(xLoc2 + FlxG.scroll.x, yLoc2 + FlxG.scroll.y);
					FlxG.buffer.draw(drawShape);				
				}				
			}
		}
	}
}
