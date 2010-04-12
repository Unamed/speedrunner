package cas.spdr.state
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
		private var logInterval:Number = 0.1;
		private var positions:String;		
		private var allPositions:Array;
		private var bShouldLog:Boolean;		
		private var colorArray:Array = new Array(0xFFFF33, 0xFFFFFF, 0x79DCF4, 0xFF3333, 0xFFCC33, 0x99CC33);
		private var bDrawMyOwn:Boolean = false; // decided whether or not I also want to see the commits from my own IP
		
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
			else if ( FlxG.keys.justPressed("L") )
			{
				retreiveLogsFromServer("http://www.progamestudios.com/casgames/spdr_stats/position_stats.php");
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
				sendLogToServer("http://www.progamestudios.com/casgames/spdr_stats/position_stats.php");
			bShouldLog = false;		
			
			bIsPaused = true;			
		}	
		
		private function logPlayerPosition():void
		{			
			positions += Math.round(player.x) + "," + Math.round(player.y) + "-";			
		}
		
		private function sendLogToServer(url:String):void
		{	
			var sendLoader:URLLoader = new URLLoader();
			var sendVars:URLVariables = new URLVariables();
			
			sendLoader.addEventListener(Event.COMPLETE, sendComplete);
			sendLoader.addEventListener(IOErrorEvent.IO_ERROR, sendError);			
			
			var track:String = FlxG.level.toString();
			var version:String = FlxG.VERSIONID.toString();
			var time:String = Math.round(playTime).toString();
			var data:String = positions;
			var hash:String = HighScores.MD5("slowcrawler" + time + data);							
			
			var sendRequest:URLRequest = new URLRequest(url + "?action=submit"+"&track="+track+"&version="+version+"&time="+time+"&hash="+hash+"&data="+data);
			
			// now send:
			sendRequest.method = URLRequestMethod.POST;
			sendLoader.load(sendRequest);
			
			function sendComplete(evt:Event):void
			{
				trace("Message sent. Loading data..");				
			}
			function sendError(evt:IOErrorEvent):void
			{
				trace("Message failed: "+evt.text);
			}			
		}
		
		private function retreiveLogsFromServer(url:String):void
		{
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
				allPositions = new Array();
				
				var i:int;
				var j:int;
				var pointArray:Array;
				
				var msg:String = event.target.data.replace("data=","");
				var arr:Array = msg.split(";");				
				
				for (i = 0; i < arr.length-1; i+=4 )
				{					
					var dbId:int = int(arr[i]);
					var userId:int = int(arr[i + 1]);						
					var completionTime:int = int(arr[i + 2]); 
					var data:String = arr[i + 3];
				
					if ( data.indexOf("-", 0) > 0)
					{
						if ( userId > 2 || bDrawMyOwn )
						{							
							var dataArray:Array = data.split("-");
							pointArray = new Array();
							
							for (j = 0; j < dataArray.length-1; j++ )
							{
								var tempLocArr:Array = dataArray[j].split(",");
								var loc:Point = new Point(Number(tempLocArr[0]), Number(tempLocArr[1]));							
								
								pointArray.push(loc);
							}
							
							allPositions.push(pointArray);		
						}
					}					
				}
			}
		}
		
		// overridden to draw log-lines, if neccessary
		override public function render():void
		{		
			super.render();			
			
			if ( allPositions.length > 0 )
			{				
				drawLog();
			}				
		}
		
		// draws all position-lines
		private function drawLog():void
		{
			var i:int;		
			var j:int;
			var pArr:Array;
			var colorId:int;
			var color:uint;
			
			var drawShape:Shape;// = new Shape();			
			var xLoc1:Number;
			var yLoc1:Number;
			var xLoc2:Number;
			var yLoc2:Number;
			
			var p1:Point;
			var p2:Point;
			
			for ( i = 0; i < Math.min(allPositions.length,10); i++ )
			{				
				pArr = allPositions[i];
				
				drawShape = new Shape();
				drawShape.graphics.lineStyle(2,colorArray[i % colorArray.length]);
				
				for ( j = 1; j < pArr.length; j++ )
				{					
					p1 = Point(pArr[j - 1]);					
					xLoc1 = p1.x + FlxG.scroll.x;
					yLoc1 = p1.y + FlxG.scroll.y;
					
					p2 = Point(pArr[j]);
					xLoc2 = p2.x + FlxG.scroll.x;
					yLoc2 = p2.y + FlxG.scroll.y;
					
					if((xLoc1 < -100) || (xLoc2 > FlxG.width+100) || (yLoc1 < -100) || (yLoc2 > FlxG.height+100))
					{
						// no drawing..							
					}
					else
					{					
						drawShape.graphics.moveTo(xLoc1, yLoc1);
						drawShape.graphics.lineTo(xLoc2, yLoc2);
						FlxG.buffer.draw(drawShape);				
					}
				}	
			}
		}
	}
}
