﻿package cas.spdr.state
{	
	import cas.spdr.actor.*;
	import cas.spdr.gfx.sprite.Pickup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import flash.geom.Point;
	import flash.display.Shape;
	
	import cas.spdr.gfx.GraphicsLibrary;
	
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
		
		private var finishDialog:MessageDialog;
		private var startDialog:MessageDialog;
		
		public var playTime:Number;		
		private var bIsTiming:Boolean;
		
		private var maps:Array;		
		private var currentMapIndex:uint;	
		
		// LOGGING:
		private var bDisableLogging:Boolean = true;
		private var logCntDwn:Number;
		private var logInterval:Number = 0.1;
		private var positions:String;		
		private var allPositions:Array;
		private var bShouldLog:Boolean;		
		private var colorArray:Array = new Array(0xFFFF33, 0xFFFFFF, 0x79DCF4, 0xFF3333, 0xFFCC33, 0x99CC33);
		private var bDrawMyOwn:Boolean = false; // decided whether or not I also want to see the commits from my own IP		
		private var logDrawIndex:int = 0;
		private var logDrawCnt:int = 1;
		
		private var logTxt1:FlxText;
		private var logTxt2:FlxText;		
				
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
			
			setPickupsFromSaveData(FlxG.progressManager.getCollectedPickups(FlxG.level));
			
			startDialog.playMessage("Go!");			
			player.active = false;
		}
		
		
		
		public function restartLevel():void
		{			
			FlxG.switchState(LevelState);			
		}		
		
		override public function addHUDElements():void
		{		
			super.addHUDElements();
			
			finishDialog = new FinishMessageDialog();
			finishDialog.setOnFinishCallback( this.endLevel );
			finishDialog.addMeToState(this);
			
			startDialog = new StartMessageDialog();			
			startDialog.setOnFinishCallback( this.startTimer );					
			startDialog.addMeToState(this);
			
			// TEXTS:
			timerTxt = new FlxText(500, 10, 200, "Timer");
			timerTxt.size = 15;							
			timerTxt.scrollFactor = new Point(0, 0);				
			this.add(timerTxt);	
			
			// goals:
			//gTxt = new FlxText(10, 10, 400, "Gold: " + FlxG.progressManager.getGoldTime(flanmap).toFixed(2));			
			gTxt = new FlxText(10, 10, 400, "Gold: " + FlxG.progressManager.getGoldTime(FlxG.level).toFixed(2));			
			gTxt.size = 15;							
			gTxt.scrollFactor = new Point(0, 0);				
			this.add(gTxt);	
			
			//sTxt = new FlxText(10, 35, 400, "Silver: " + FlxG.progressManager.getSilverTime(flanmap).toFixed(2));			
			sTxt = new FlxText(10, 35, 400, "Silver: " + FlxG.progressManager.getSilverTime(FlxG.level).toFixed(2));			
			sTxt.size = 15;							
			sTxt.scrollFactor = new Point(0, 0);				
			this.add(sTxt);	
			
			//bTxt = new FlxText(10, 60, 400, "Bronze: " + FlxG.progressManager.getBronzeTime(flanmap).toFixed(2));			
			bTxt = new FlxText(10, 60, 400, "Bronze: " + FlxG.progressManager.getBronzeTime(FlxG.level).toFixed(2));			
			bTxt.size = 15;							
			bTxt.scrollFactor = new Point(0, 0);				
			this.add(bTxt);	
			
			//bestTxt = new FlxText(10, 100, 400, "Best: " + FlxG.progressManager.getBestTime(flanmap).toFixed(2));			
			bestTxt = new FlxText(10, 100, 400, "Best: " + FlxG.progressManager.getBestTime(FlxG.level).toFixed(2));			
			bestTxt.size = 15;							
			bestTxt.scrollFactor = new Point(0, 0);				
			this.add(bestTxt);	
			
			
			
			logTxt1 = new FlxText(10, 200, 400, "");			
			logTxt1.size = 12;							
			logTxt1.scrollFactor = new Point(0, 0);				
			this.add(logTxt1);	
			
			logTxt2 = new FlxText(10, 250, 400, "");			
			logTxt2.size = 12;							
			logTxt2.scrollFactor = new Point(0, 0);				
			this.add(logTxt2);
			
			
		}	
		
		// test:
		public function setPickupsFromSaveData(data:String):void
		{			
			for ( var i:int = 0; i < pickups.length; i++ )
			{
				var bChar:String = data.charAt(i);								
				if ( bChar == "1" )
				{
					(pickups[i] as Pickup).PreviouslyPickedUp();
				}
			}			
		}
		
		override public function update():void
		{			
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
			if ( FlxG.keys.justPressed("SPACE") )
			{
				restartLevel();
			}
			else if ( FlxG.keys.justPressed("L") )
			{
				retreiveLogsFromServer("http://www.progamestudios.com/casgames/spdr_stats/position_stats.php");
			}
			else if ( FlxG.keys.justPressed("U") )
			{
				logDrawIndex += logDrawCnt;
				logDrawIndex %= allPositions.length;
				
				//if ( logDrawIndex > allPositions.length -1 )
				//	logDrawIndex = 0;
			}
			else if ( FlxG.keys.justPressed("J") )
			{
				logDrawIndex -= logDrawCnt;				
				if ( logDrawIndex < 0 )
					logDrawIndex = allPositions.length +logDrawIndex;
			}
			else if ( FlxG.keys.justPressed("I") )
			{
				logDrawCnt = Math.min( logDrawCnt + 1, allPositions.length );				
			}
			else if ( FlxG.keys.justPressed("K") )
			{
				logDrawCnt = Math.max( logDrawCnt-1, 0);				
			}
			
			if ( allPositions.length > 0 )
			{
				if ( logDrawCnt > 1 )
					logTxt1.text = "DrawingIndices: " + logDrawIndex + " to " + (logDrawIndex + logDrawCnt - 1) + " (of " + (allPositions.length - 1) + ")";
				else
					logTxt1.text = "DrawingIndex: " + logDrawIndex + " (of " + (allPositions.length - 1) + ")";					
				
			}
			else
				logTxt1.text = "";
			
			
		}
		
		public function startTimer():void
		{			
			player.active = true;
			playTime = 0;
			bIsTiming = true;	
			
			bShouldLog = true;
			
			//tracker.trackPageview("/started");// "/FisherGirl");
			//tracker.trackEvent("Timing Events", "Started", "Label", playTime );	
			
			
			
		}
		
		public function stopTimer():void
		{
			if ( bIsTiming )
			{
				bIsTiming = false;
				
				//var bNeedsAddMsg:Boolean = FlxG.progressManager.FinishedLevel(FlxG.level, playTime);
				var recCredits:int = FlxG.progressManager.FinishedLevel(FlxG.level, playTime);
				var msg:String = FlxG.progressManager.getFinishedMessage(FlxG.level, playTime);
				if ( recCredits > 0 )
				{
					var addMsg:String = "+"+recCredits+ " Credits!";// FlxG.progressManager.getUnlockedPowerMessageForLevel(FlxG.level);
					finishDialog.playMessage(msg, addMsg);
				}
				else
					finishDialog.playMessage(msg);
			}
			
			//tracker.trackEvent("Timing Events", "Finished", "Label", playTime );				
			
			//SWFStats.LevelMetrics.Log("Finished", currentMapIndex+1);
			//SWFStats.LevelMetrics.LogRanged("CompletionTime", currentMapIndex+1, playTime);				
						
			//finTxt.text = FlxG.progressManager.FinishedLevel(flanmap, playTime);
			
			//finTxt.text = FlxG.progressManager.FinishedLevel(FlxG.level, playTime);
			//finTxt.visible = true;
			
			
			
			
					
		}	
		
		public function endLevel(bSaveData:Boolean = true):void
		{
			//bIsPaused = true;
			player.active = false;
			
			if ( bSaveData )
			{
				FlxG.log("Saving..");
				FlxG.progressManager.executeSaves();
				FlxG.log("Done.");
			}
			
			if( bShouldLog && !bDisableLogging)			
				sendLogToServer("http://www.progamestudios.com/casgames/spdr_stats/position_stats.php");
			bShouldLog = false;	
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
			var version:String = FlxG.LIBRARY_MAJOR_VERSION.toString() + ":"+ FlxG.LIBRARY_MINOR_VERSION.toString();
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
			variables.version = FlxG.LIBRARY_MAJOR_VERSION.toString() + ":"+ FlxG.LIBRARY_MINOR_VERSION.toString();
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
							
							pointArray.push(userId);
							pointArray.push(completionTime);
							
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
				FlxG.log("..received " + allPositions.length + " lines");
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
			
			var ids:String = "UserIds: ";
			var times:String = "CompletionTimes: ";
			
			
			
			for ( i = logDrawIndex; i < logDrawIndex+logDrawCnt; i++ )
			{			
				var t:int = i % allPositions.length;
								
				pArr = allPositions[t];
				
				drawShape = new Shape();
				drawShape.graphics.lineStyle(2,colorArray[t % colorArray.length]);
						
				ids += pArr[0] + " ";
				times += pArr[1] + " ";
				
				//logTxt2.text += "UserId: " + pArr[0] +"\n";
				//logTxt2.text += "CompletionTime: " + pArr[1] +"\n";
				
				for ( j = 3; j < pArr.length; j++ )
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
			
			logTxt2.text = ids + "\n" + times;
		}
	}
}