/*

SWFStats tracking code is (c) SWFStats (www.swfstats.com)
--------------------------------------------------------------------------------------------------------------------------------
Version 1.3 - 1/18/2010

The tracking code is provided as-is and with no warranty.  Failsafes are in place that should ensure your game will continue
to function should SWFStats be unavailable.

You may modify this code as you see fit but if you make changes to the core logic it may not provide any or accurate analytics.



CustomMetrics.as
--------------------------------------------------------------------------------------------------------------------------------
This is the code for saving custom metrics you have configured in SWFStats.  For a list of your custom metrics refer to the
Config.as, where you should have pasted your data from SWFStats.



Example usage:
--------------------------------------------------------------------------------------------------------------------------------
You are logging what difficulty people play at so on your Easy, 
Medium and Hard button event handlers you would include code 
like this:

function ClickedOnEasy(e:MouseEvent):void
{
	SWFStats.CustomMetrics.Log("Easy');

	// continue with beginning a game on easy
}

*/

package SWFStats
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	
	public class CustomMetrics
	{
		// Log a custom metric
		public static function Log(name:String):void
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
				trace("SWFStats.CustomMetrics.Log '" + name + "'");

			if(Config.CustomMetrics[name] == null)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR INVALID METRIC NAME ** ");
					trace("    You passed an invalid metric called \"" + name + "\".  This metric does not exist in your Config.as");
					trace("    Solutions:");
					trace("      1) Check that you have pasted in your game configuration into Config.as");
					trace("      2) Check that you have configured this custom metric at http://my.swfstats.com/");
				}
				return;
			}
			
			var metricid:int = Config.CustomMetrics[name] as int;
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, Tracker.ErrorHandler);
			sendaction.load(new URLRequest("http://tracker.swfstats.com/Games/CustomMetric.html?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&metricid=" + metricid + "&" + SWFStats.Tracker.Random));
		}
	}
}