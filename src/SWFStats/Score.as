/*

SWFStats tracking code is (c) SWFStats (www.swfstats.com)
--------------------------------------------------------------------------------------------------------------------------------
Version 1.3 - 1/18/2010

The tracking code is provided as-is and with no warranty.  Failsafes are in place that should ensure your game will continue
to function should SWFStats be unavailable.

You may modify this code as you see fit but if you make changes to the core logic it may not provide any or accurate analytics.



Score.as
--------------------------------------------------------------------------------------------------------------------------------
Represents a score item.  When you request a highscore list it is returned as an array of these objects.

*/

package SWFStats
{
	public class Score
	{
		public var Rank:int;
		public var Name:String;
		public var Points:int;
		public var Website:String;
		public var SDate:Date;
	}
}