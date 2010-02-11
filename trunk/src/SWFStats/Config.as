/*

SWFStats tracking code is (c) SWFStats (www.swfstats.com)
--------------------------------------------------------------------------------------------------------------------------------
Version 1.3 - 1/18/2010

The tracking code is provided as-is and with no warranty.  Failsafes are in place that should ensure your game will continue
to function should SWFStats be unavailable.

You may modify this code as you see fit but if you make changes to the core logic it may not provide any or accurate analytics.



Configuration.as
--------------------------------------------------------------------------------------------------------------------------------
This is the configuration for your game, make sure you put the correct values in for your game which you can get from the 
API Code page inside http://my.swfstats.com/

*/

package SWFStats
{
	import flash.utils.Dictionary;
	
	public class Config
	{
		// Replace all of this with the code you're given
		public static const SWFID:int = 153;
		public static const GUID:String = "6635b062-cc5b-4c1b-819c-1f1b48b4ad75";
		public static const CustomMetrics:Dictionary = new Dictionary();
		public static const LevelLabels:Dictionary = new Dictionary();
		// Level metrics
		public static const LevelCounterMetrics:Dictionary = new Dictionary();
		LevelCounterMetrics["Started"] = 45;
		LevelCounterMetrics["Finished"] = 46;

		public static const LevelRangedMetrics:Dictionary = new Dictionary();
		LevelRangedMetrics["CompletionTime"] = 33;

		public static const ScoreTables:Dictionary = new Dictionary();
	}
}