package SWFStats
{
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.SharedObject;
	import flash.system.Security;
	import flash.utils.Timer;

	public final class Log
	{
		// API settings
		private static const Random:Number = Math.random();
		private static var Enabled:Boolean = false;
		
		// SWF settings
		public static var SWFID:int = 0;
		public static var GUID:String = "";
		public static var SourceUrl:String;
	
		// play timer, goal tracking etc
		private static const PingF:Timer = new Timer(60000);
		private static const PingR:Timer = new Timer(30000);
		private static var FirstPing:Boolean = true;
		private static var Pings:int = 0;
		private static var Plays:int = 0;
		private static var HighestGoal:int = 0;		

		// ------------------------------------------------------------------------------
		// View
		// Logs a view and initialises the SWFStats API
		// ------------------------------------------------------------------------------
		public static function View(swfid:int = 0, guid:String = "", defaulturl:String = ""):void
		{
			SWFID = swfid;
			GUID = guid;
			Enabled = true;

			if((SWFID == 0 || GUID == ""))
			{
				Enabled = false;
				return;
			}

			// Check the URL is http		
			if(defaulturl.indexOf("http://") != 0 && Security.sandboxType != "localWithNetwork" && Security.sandboxType != "localTrusted")
			{
				Enabled = false;
				return;
			}
			
			SourceUrl = GetUrl(defaulturl);

			if(SourceUrl == null || SourceUrl == "")
			{
				Enabled = false;
				return;
			}

			// Load the security context
			Security.allowDomain("http://tracker.swfstats.com/");
			Security.allowInsecureDomain("http://tracker.swfstats.com/");
			Security.loadPolicyFile("http://tracker.swfstats.com/crossdomain.xml");
						
			Security.allowDomain("http://utils.swfstats.com/");
			Security.allowInsecureDomain("http://utils.swfstats.com/");
			Security.loadPolicyFile("http://utils.swfstats.com/crossdomain.xml");

			// Log the view (first or repeat visitor)
			var views:int = GetCookie("views");
			views++;
			SaveCookie("views", views);

			Send("View", "views=" + views);

			// Start the play timer
			PingF.addEventListener(TimerEvent.TIMER, PingServer);
			PingF.start();
		}

		// ------------------------------------------------------------------------------
		// Play
		// Logs a play.
		// ------------------------------------------------------------------------------
		public static function Play():void
		{						
			if(!Enabled)
				return;
				
			Plays++;
			Send("Play", "plays=" + Plays);
		}

		// ------------------------------------------------------------------------------
		// Goal
		// Logs a progress goal.
		// ------------------------------------------------------------------------------
		public static function Goal(n:int, name:String):void
		{
			if(!Enabled)
				return;
			
			if(HighestGoal >= n)
				return;
				
			HighestGoal = n;			
			Send("Goal", "goal=" + n + "&name=" + escape(name));
		}

		// ------------------------------------------------------------------------------
		// Ping
		// Tracks how long the player's session lasts.  First ping is at 60 seconds after
		// which it occurs every 30 seconds.
		// ------------------------------------------------------------------------------
		private static function PingServer(...args):void
		{			
			if(!Enabled)
				return;
				
			Pings++;
			
			Send("Ping", (FirstPing ? "&firstping=yes" : "") + "&pings=" + Pings);
				
			if(FirstPing)
			{
				PingF.stop();

				PingR.addEventListener(TimerEvent.TIMER, PingServer);
				PingR.start();

				FirstPing = false;
			}
		}
		
		// ------------------------------------------------------------------------------
		// CustomMetric
		// Logs a custom metric event.
		// ------------------------------------------------------------------------------
		public static function CustomMetric(name:String):void
		{		
			if(!Enabled)
				return;
			
			Send("CustomMetric", "name=" + escape(name));
		}

		// ------------------------------------------------------------------------------
		// LevelCounterMetric, LevelRangedMetric, LevelAverageMetric
		// Logs an event for each level metric type.
		// ------------------------------------------------------------------------------
		public static function LevelCounterMetric(name:String, level:*):void
		{		
			if(!Enabled)
				return;
			
			Send("LevelMetric", "name=" + escape(name) + "&level=" + level);
		}
		

		public static function LevelRangedMetric(name:String, level:*, value:int):void
		{			
			if(!Enabled)
				return;
			
			Send("LevelMetricRanged", "name=" + escape(name) + "&level=" + level + "&value=" + value);
		}

		public static function LevelAverageMetric(name:String, level:*, value:int):void
		{
			if(!Enabled)
				return;
			
			Send("LevelMetricAverage", "name=" + escape(name) + "&level=" + level + "&value=" + value);
		}


		// ------------------------------------------------------------------------------
		// Send
		// Creates and sends the url requests to the tracking service.
		// ------------------------------------------------------------------------------
		private static function Send(page:String, data:String):void
		{
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, StatusChange);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ErrorHandler);

			sendaction.load(new URLRequest("http://tracker.swfstats.com/Games/" + page + ".html?guid=" + GUID + "&swfid=" + SWFID + "&" + data + "&url=" + SourceUrl + "&" + Random));
		}
		
		private static function ErrorHandler(...args):void
		{
			Enabled = false;
		}

		private static function StatusChange(...args):void
		{
		}
	
		// ------------------------------------------------------------------------------
		// GetCookie and SetCookie
		// Records or retrieves data like how many times the person has played your
		// game.
		// ------------------------------------------------------------------------------
		private static function GetCookie(n:String):int
		{
			var cookie:SharedObject = SharedObject.getLocal("swfstats");		
			
			if(cookie.data[n] == undefined)
			{
				return 0;
			}
			else
			{
				return int(cookie.data[n]);
			}
		}
		
		private static function SaveCookie(n:String, v:int):void
		{
			var cookie:SharedObject = SharedObject.getLocal("swfstats");		
			cookie.data[n] = v.toString();
			cookie.flush();
		}	

		// ------------------------------------------------------------------------------
		// GetUrl
		// Tries to identify the actual page url, and if it's unable to it reverts to 
		// the default url you passed the View method.  If you're testing the game it
		// should revert to http://local-testing/.
		// ------------------------------------------------------------------------------
		private static function GetUrl(defaulturl:String):String
		{
			var url:String;
			
			if(ExternalInterface.available)
			{
				try
				{
					url = String(ExternalInterface.call("window.location.href.toString"));
				}
				catch(s:Error)
				{
					url = defaulturl;
				}
			}
			else if(defaulturl.indexOf("http://") == 0)
			{
				url = defaulturl;
			}

			if(url == null  || url == "" || url == "null")
			{
				if(Security.sandboxType == "localWithNetwork" || Security.sandboxType == "localTrusted")
				{
					url = "http://local-testing/";
				}
				else
				{
					url = null;
				}
			}

			return url;
		}
	}
}