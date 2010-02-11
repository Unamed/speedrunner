/*

SWFStats tracking code is (c) SWFStats (www.swfstats.com)
--------------------------------------------------------------------------------------------------------------------------------
Version 1.3 - 1/18/2010

The tracking code is provided as-is and with no warranty.  Failsafes are in place that should ensure your game will continue
to function should SWFStats be unavailable.

You may modify this code as you see fit but if you make changes to the core logic it may not provide any or 
accurate analytics.



HighScores.as
--------------------------------------------------------------------------------------------------------------------------------
Returns and saves high scores.  The returned collections are arrays of the top 20 as Score objects sent as a parameter to
the method of your choice (callback).

The 'global' trigger determines whether to return results for the specific site you are on (global = false) or the top 
scores overall.



Example usage:
--------------------------------------------------------------------------------------------------------------------------------
Your high score 'screen' opens up, in your constructor you request the highscores from SWFStats and pass it your method
that will display them on screen:

function HighScoreScreen()
{
	SWFStats.HighScores.List(true, "Easy", this.ShowScores);
}

function ShowScores(scores:Array)
{
	for(var i:int=0; i<scores.length; i++)
	{
		this["Name" + i].text = scores[i].Name;
		this["Points" + i].text = scores[i].Points;
	}
}



To save a highscore you use the Save method:

eg:
SWFStats.HighScores.Submit(playername, score, "Easy");



Facebook apps:
--------------------------------------------------------------------------------------------------------------------------------
SWFStats leaderboards can be used directly for Facebook applications and natively show only Facebook users' scores, including
the player's friends scores.

To get scores for a Facebook application use ListFacebook, and otionally pass the facebook user's friends in an array to show
only the friends' scores.

Important:
Facebook appends a lot of querystring variables to iframes and stuff.  For your Facebook version it is better if you 
manually override the SourceUrl in the Tracker class to your Facebook application url.

eg when you initialise:
Tracker.Initialise(loaderInfo.loaderUrl);
Tracker.SourceUrl = "http://apps.facebook.com/colorfill-two/"

eg:
SWFStats.HighScores.ListFacebook("Easy", this.ShowScores, fbuserid, [friend_ids]);

To save scores just use the Facebook userid as the username and pass 'true' as the final parameter:
eg:
SWFStats.HighScores.Submit(fbuserid, score, "Easy", true);

*/

package SWFStats
{
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import flash.net.URLLoader;

	public class HighScores
	{
		private static var DataLoader:URLLoader;
		private static var CallBack:Function;

		public static function List(global:Boolean, table:String, callback:Function):void
		{
			if(!SWFStats.Tracker.Initialised)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR YOU MUST INITIALISE SWFSTATS BEFORE YOU CAN LOG ANYTHING **");
					trace("    You are trying to use SWFStats without initialising it.");
					trace("    Solution:");
					trace("      1) Go to your document class, eg Main");
					trace("      2) Find the constructor, eg public function Main");
					trace("      3) Add SWFStats.Tracker.Initialise(loaderInfo.loaderURL) to your constructor");
				}
				return;
			}

			if(SWFStats.Tracker.SourceUrl == null)
			{
				if(callback != null)
					callback(new Array());
				else
					return;
			}
			
			if(Tracker.DebugMode)
				trace("SWFStats.HighScores.List Global " + global + ", Table '" + table + "', CallBack " + callback);
				
			if(Config.ScoreTables[table] == null)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR INVALID SCORE TABLE **");
					trace("    You passed an invalid score table called \"" + table + "\".  This table does not exist in your Config.as");
					trace("    Solutions:");
					trace("      1) Check that you have pasted in your game configuration into Config.as");
					trace("      2) Check that you have configured this score table at http://my.swfstats.com/");
				}
				return;
			}
			
			var groupid:int = Config.ScoreTables[table] as int;					
				
			CallBack = callback;

			DataLoader = new URLLoader();
			DataLoader.addEventListener(Event.COMPLETE, DataLoaded);
			DataLoader.addEventListener(IOErrorEvent.IO_ERROR, Tracker.ErrorHandler);
			DataLoader.load(new URLRequest("http://utils.swfstats.com/leaderboards/get.aspx?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&url=" + (global ? "global" : SWFStats.Tracker.SourceUrl) + "&groupid=" + groupid + "&" + Math.random()));
		}

		public static function ListFacebook(table:String, callback:Function, fbuserid:String, friendlist:Array = null):void
		{
			if(!SWFStats.Tracker.Initialised)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR YOU MUST INITIALISE SWFSTATS BEFORE YOU CAN LOG ANYTHING **");
					trace("    You are trying to use SWFStats without initialising it.");
					trace("    Solution:");
					trace("      1) Go to your document class, eg Main");
					trace("      2) Find the constructor, eg public function Main");
					trace("      3) Add SWFStats.Tracker.Initialise(loaderInfo.loaderURL) to your constructor");
				}
				return;
			}

			if(SWFStats.Tracker.SourceUrl == null)
			{
				if(callback != null)
					callback(new Array());
				else
					return;
			}
			
			if(Tracker.DebugMode)
				trace("SWFStats.HighScores.ListFacebook Table '" + table + "', CallBack '" + callback + "' FriendsList '" + friendlist + "'");
				
			if(Config.ScoreTables[table] == null)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR INVALID SCORE TABLE **");
					trace("    You passed an invalid score table called \"" + table + "\".  This table does not exist in your Config.as");
					trace("    Solutions:");
					trace("      1) Check that you have pasted in your game configuration into Config.as");
					trace("      2) Check that you have configured this score table at http://my.swfstats.com/");
				}
				return;
			}
			
			var groupid:int = Config.ScoreTables[table] as int;					
			var friendsliststr = friendlist != null ? friendlist.join(",") : "";
				
			CallBack = callback;

			DataLoader = new URLLoader();
			DataLoader.addEventListener(Event.COMPLETE, DataLoaded);
			DataLoader.addEventListener(IOErrorEvent.IO_ERROR, Tracker.ErrorHandler);
			DataLoader.load(new URLRequest("http://utils.swfstats.com/leaderboards/getfb.aspx?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&groupid=" + groupid + "&friendlist=" + friendsliststr + "&" + Math.random()));
		}

		public static function Submit(name:String, score:int, table:String, facebook:Boolean = false):void
		{
			if(!SWFStats.Tracker.Initialised)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR YOU MUST INITIALISE SWFSTATS BEFORE YOU CAN LOG ANYTHING **");
					trace("    You are trying to use SWFStats without initialising it.");
					trace("    Solution:");
					trace("      1) Go to your document class, eg Main");
					trace("      2) Find the constructor, eg public function Main");
					trace("      3) Add SWFStats.Tracker.Initialise(loaderInfo.loaderURL) to your constructor");
				}
				return;
			}

			if(SWFStats.Tracker.SourceUrl == null)
				return;
				
			if(Tracker.DebugMode)
				trace("SWFStats.HighScores.Submit Player '" + name + "', Score " + score + ", Table '" + table + "'");
				
			if(Config.ScoreTables[table] == null)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR INVALID SCORE TABLE **");
					trace("    You passed an invalid score table called \"" + table + "\".  This table does not exist in your Config.as");
					trace("    Solutions:");
					trace("      1) Check that you have pasted in your game configuration into Config.as");
					trace("      2) Check that you have configured this score table at http://my.swfstats.com/")
				}
				return;
			}
			
			var groupid:int = Config.ScoreTables[table] as int;							

			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, Tracker.ErrorHandler);
			sendaction.load(new URLRequest("http://utils.swfstats.com/leaderboards/save.aspx?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&url=" + SWFStats.Tracker.SourceUrl + "&groupid=" + groupid + "&name=" + name + "&score=" + score + "&auth=" + MD5.calcMD5(SWFStats.Tracker.SourceUrl + score.toString()) + "&fb=" + (facebook ? "1" : "0") + "&r=" + Math.random()));
		}

		private static function DataLoaded(e:Event):void
		{
			if(Tracker.DebugMode)
				trace("SWFStats.HighScores.DataLoaded");			
			
			var data:XML = XML(DataLoader.data);
			var counter:int = 0;
			var entries:XMLList = data.entry;
			var results:Array = new Array();
			
			if(Tracker.DebugMode)
				trace("#\tName\tScore\tDate\tWebsite");
			
			
			for each(var item:XML in entries) 
			{
				var score:Score = new Score();
				score.Name = item.name;
				score.Points = item.points;
				score.Website = item.website;
				score.Rank = results.length + 1;
				
				var datestring = item.sdate;				
				var year:int = int(datestring.substring(datestring.lastIndexOf("/") + 1));
				var month:int = int(datestring.substring(0, datestring.indexOf("/")));
				var day:int = int(datestring.substring(datestring.indexOf("/" ) +1).substring(0, 2));
				score.SDate = new Date();
				score.SDate.setFullYear(year, month, day);
				
				if(Tracker.DebugMode)
					trace(score.Rank + "\t" + score.Name + "\t" + score.Points + "\t" + item.sdate + "\t" + score.Website);

				results.push(score);
			}

			CallBack(results);
		}
	}
}