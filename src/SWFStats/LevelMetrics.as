/*

SWFStats tracking code is (c) SWFStats (www.swfstats.com)
--------------------------------------------------------------------------------------------------------------------------------
Version 1.3 - 1/18/2010

The tracking code is provided as-is and with no warranty.  Failsafes are in place that should ensure your game will continue
to function should SWFStats be unavailable.

You may modify this code as you see fit but if you make changes to the core logic it may not provide any or accurate analytics.



LevelMetrics.as
--------------------------------------------------------------------------------------------------------------------------------
This is the code for saving level metrics you have configured in SWFStats.  For a list of your level metrics refer to the
Config.as, where you should have pasted your data from SWFStats.


Example usage:
--------------------------------------------------------------------------------------------------------------------------------
Level metrics work just like custom metrics but with two differences:

1) You can send any level number which is used to group your metrics in the reports (ie showing you 'lives lost' across levels

2) You can send any integer value.  The value defaults to 1 which is just a standard increment you could use to count
   how many people begin, win, restart or abandon each level for instance.  You would pass a value to track non-incrementing
   data such as how many lives are lost on each level to identify problems with your difficulty settings.
   
Note that we either send a level number or a level label, whichever you use the other is 0.

function StartLevel(e:MouseEvent):void
{
	SWFStats.LevelMetrics.Log("Started", levelnumber);

	// continue with beginning the level ...
}

function RestartLevel(e:MouseEvent):void
{
	SWFStats.LevelMetrics.Log("Restarted", "Level label");

	// continue restarting the level ...
}

function WonLevel():void
{
	SWFStats.LevelMetrics.Log("Completed", levelnumber);
	SWFStats.LevelMetrics.LogRanged("Lives lost", levelnumber, liveslost);

	// go to the won level screen ...
}

*/

package SWFStats
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	
	public class LevelMetrics
	{
		// Log a counter metric, either send a level or a label 
		public static function Log(name:String, level:*):void
		{
			if(Tracker.DebugMode)
				trace("SWFStats.LevelMetrics.Log '" + name + "', Level '" + level + "'");
			
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
				
				
			if(Config.LevelCounterMetrics[name] == null)
			{
				trace("** ERROR INVALID METRIC NAME **");
				trace("    You passed an invalid counter metric called \"" + name + "\".  This metric does not exist in your Config.as");
				trace("    Solutions:");
				trace("      1) Check that you have pasted in your game configuration into Config.as");
				trace("      2) Check that you have configured this level counter metric at http://my.swfstats.com/");
				return;
			}
			
			var metricid:int = Config.LevelCounterMetrics[name] as int;			
			var levelnumber:int = 0;
			var labelid:int = 0;
			
			if(level is int)
			{
				levelnumber = int(level);
			}
			else if(level is String)
			{
				if(Config.LevelLabels[String(level)] == null)
				{
					if(Tracker.DebugMode)
					{
						trace("** ERROR INVALID LEVEL LABEL **");
						trace("    You passed an invalid level label called \"" + name + "\".  This label does not exist in your Config.as");
						trace("    Solutions:");
						trace("      1) Check that you have pasted in your game configuration into Config.as");
						trace("      2) Check that you have configured this level label at http://my.swfstats.com/");
					}
					return;
				}
				
				labelid = Config.LevelLabels[String(level)] as int;
			}
			
			if(levelnumber == 0 && labelid == 0)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR NO LEVEL NUMBER AND NO LEVEL LABEL **");
					trace("    You didn't specify a level number or level label.");
					trace("    Solutions:");
					trace("      1) Pass a level number: Log(name, level) where level is an integer");
					trace("      2) Pass a level label: Log(name, level) where level is a String you have defined in Config.as");
				}
				return;
			}
			
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, Tracker.ErrorHandler);
			sendaction.load(new URLRequest("http://tracker.swfstats.com/Games/LevelMetric.html?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&metricid=" + metricid + "&levelid=" + levelnumber + "&labelid=" + labelid + "&" + SWFStats.Tracker.Random));
		}

		// Log a ranged-value metric, either send a level or a label 
		public static function LogRanged(name:String, level:*, value:int):void
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
				trace("SWFStats.LevelMetrics.LogRanged '" + name + "', Level '" + level + "', Value '" + value + "'");	
				
			if(Config.LevelRangedMetrics[name] == null)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR INVALID METRIC NAME **");
					trace("    You passed an invalid ranged metric called \"" + name + "\".  This metric does not exist in your Config.as");
					trace("    Solutions:");
					trace("      1) Check that you have pasted in your game configuration into Config.as");
					trace("      2) Check that you have configured this level counter metric at http://my.swfstats.com/");
				}
				return;
			}
			
			var metricid:int = Config.LevelRangedMetrics[name] as int;
			var levelnumber:int = 0;
			var labelid:int = 0;
			
			if(level is int)
			{
				levelnumber = int(level);
			}
			else if(level is String)
			{
				if(Config.LevelLabels[String(level)] == null)
				{
					if(Tracker.DebugMode)
					{
						trace("** ERROR INVALID LEVEL LABEL **");
						trace("    You passed an invalid level label called \"" + name + "\".  This label does not exist in your Config.as");
						trace("    Solutions:");
						trace("      1) Check that you have pasted in your game configuration into Config.as");
						trace("      2) Check that you have configured this level label at http://my.swfstats.com/");
					}
					return;
				}
				
				labelid = Config.LevelLabels[String(level)] as int;
			}
			
			if(levelnumber == 0 && labelid == 0)
			{
				if(Tracker.DebugMode)
				{
					trace("** ERROR NO LEVEL NUMBER AND NO LEVEL LABEL **");
					trace("    You didn't specify a level number or level label.");
					trace("    Solutions:");
					trace("      1) Pass a level number: Log(name, level) where level is an integer");
					trace("      2) Pass a level label: Log(name, level) where level is a String you have defined in Config.as");
				}
				return;
			}
			
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, Tracker.ErrorHandler);
			sendaction.load(new URLRequest("http://tracker.swfstats.com/Games/LevelMetricRanged.html?guid=" + Config.GUID + "&swfid=" + Config.SWFID + "&metricid=" + metricid + "&levelid=" + levelnumber + "&labelid=" + labelid + "&value=" + value + "&" + SWFStats.Tracker.Random));
		}
	}
}