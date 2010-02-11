/*

SWFStats tracking code is (c) SWFStats (www.swfstats.com)
--------------------------------------------------------------------------------------------------------------------------------
Version 1.3 - 1/18/2010

The tracking code is provided as-is and with no warranty.  Failsafes are in place that should ensure your game will continue
to function should SWFStats be unavailable.

You may modify this code as you see fit but if you make changes to the core logic it may not provide any or accurate analytics.



Tracker.as
--------------------------------------------------------------------------------------------------------------------------------
This class holds the methods that begin and track a user's view of your game.



VERY IMPORTANT
--------------------------------------------------------------------------------------------------------------------------------
Before you do anything at all with SWFStats you *must* call the Initialise method here.  If you do not call Initialise first then
you will not collect any data.  The URL to the SWF is used as the default URL in case the actual page cannot be determined via
the ExternalInterface.  The data is showing this does not show up reliably unfortunately so it is an unfortunate but necessary fallback.

The best place to do this is in your main document class's constructor:

package
{
	public class MyGame
	{
		public function MyGame()
		{
			SWFStats.Tracker.Initialise(loaderInfo.loaderURL);

			// the rest of your game
		}
	}
}



Example usage:
--------------------------------------------------------------------------------------------------------------------------------

In your document class before your preloader you would log the view:
SWFStats.Tracker.LogView();

In your document class when you begin a game you would log the play:
SWFStats.Tracker.LogPlay();

PingServer and the error handler are private methods that you should not manually call.  If you do modify that code remember
that the SWFStats service regards every 'ping' as representing 30 seconds the user has spent viewing your game, and will keep
assuming that even if it means something else to you.

*/

package SWFStats
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;

	public class Tracker
	{
		public static const Random:Number = Math.random();
		private static const Ping:Timer = new Timer(30000);
		public static var SourceUrl:String;
		public static var DebugMode:Boolean = true;
		public static var Initialised:Boolean = false;

		// Initialises the SWFStats service.  The 'defaulturl' should be your loaderInfo.loaderURL 
		public static function Initialise(defaulturl:String, turnoffdebugmode:Boolean = false):void
		{			
			DebugMode = turnoffdebugmode ? false : Security.sandboxType == "localTrusted";
			
			if(DebugMode)
				trace("SWFStats.Tracker.Initialise");			
			
			if(Config.SWFID == 0 || Config.GUID == "")
			{
				if(DebugMode)
				{
					trace("** ERROR YOU MUST COPY YOUR DATA INTO CONFIG.AS **");
					trace("    You have not copied your settings into SWFStats\\Config.as.");
					trace("    Solution:");
					trace("      1) Go to http://my.swfstats.com/");
					trace("      2) Select your game and go into the 'API Code' section");
					trace("      3) Copy your data into SWFStats\\Config.as");
				}
				return;
			}			
			
			Initialised = true;
			
			// avoid any non-http protocols, eg file:// is the player viewing your game locally
			// on his hard drive and Adobe will generate security dialogues if the SWF tries to
			// access the internet
			if(defaulturl.indexOf("http://") != 0 && Security.sandboxType != "localTrusted")
				return;
			
			// Set our sourceurl, the variable which decides whether to proceed
			// with requests - if it's null all requests are discarded.
			SourceUrl = GetUrl(defaulturl);

			// Load the security context
			try
			{
				Security.loadPolicyFile("http://tracker.swfstats.com/crossdomain.xml");
				Security.loadPolicyFile("http://utils.swfstats.com/crossdomain.xml");
			}
			catch(s:Error)
			{
				// On an error we set SourceUrl to null since it will prevent anything else from proceeding
				SourceUrl = null;
				return;
				
				if(DebugMode)
					trace("** ERROR COULD NOT LOAD SWFSTATS POLICY FILE **");
			}
		}

		// Registers the person's initial visit and sets up a recurring ping used to track how long the person spends on your game
		public static function LogView():void
		{			
			if(SourceUrl == null)
				return;
				
			if(DebugMode)
				trace("SWFStats.Tracker.LogView");				

			// Begin the session
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);
			sendaction.load(new URLRequest("http://tracker.swfstats.com/Games/View.html?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&url=" + SourceUrl + "&" + Random));

			// Set up our pinger to keep tracking the session duration
			Ping.addEventListener(TimerEvent.TIMER, PingServer);
			Ping.start();
		}
		
		// Logs a play, call this function each time a new game commences
		public static function LogPlay():void
		{
			if(SourceUrl == null)
				return;
				
			if(DebugMode)
				trace("SWFStats.Tracker.LogPlay");

			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);			
			sendaction.load(new URLRequest("http://tracker.swfstats.com/Games/Play.html?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&url=" + SourceUrl + "&" + Random));
		}
		
		// This keeps pinging the server to track how long the user spends 
		// in the game
		private static function PingServer(e:Event):void
		{			
			if(SourceUrl == null)
				return;
				
			if(DebugMode)
				trace("SWFStats.Tracker.PingServer");
				
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);
			sendaction.load(new URLRequest("http://tracker.swfstats.com/Games/Ping.html?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&url=" + SourceUrl + "&" + Random));
		}

		// Tries to get the source site's url, keep the try/catch because it WILL
		// fail outside of a browser context
		private static function GetUrl(defaulturl:String):String
		{
			var url:String;
			
			try
			{
				url = String(ExternalInterface.call("window.location.href.toString"));
			}
			catch(s:Error)
			{
				url = defaulturl != null ? defaulturl : "";
				
			}
			
			return url != "null" ? url : "";
		}
		
		// On any error we default SourceUrl to null so no further requests will be sent
		public static function ErrorHandler(e:IOErrorEvent):void
		{
			if(DebugMode)
				trace("** ERROR COMPLETING URL REQUEST TO SWFSTATS **");

			SourceUrl = null;
		}
	}
}