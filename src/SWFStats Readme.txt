SWFStats tracking code is (c) SWFStats (www.swfstats.com)
--------------------------------------------------------------------------------------------------------------------------------
Version 2.2 - 7/30/2010

Changes from previous versions:
- finalized the basics of the level sharing API

Version 2.1 - 6/18/2010

Changes from previous versions:
- added event queuing so multiple events are sent in a single request.  This is on by default but can be disabled by
setting:

Log.Queue = false;

When queuing is enabled events are sent in bulk every 8th request or every time the play timer event is called which is 
every 30 seconds after the first minute.  The initial view is always sent.

Version 1.8 - 4/1/2010

Changes from previous version:
- added group name specifying to custom metrics as an optional 2nd parameter

Version 1.7 - 3/30/2010

Changes from previous version:
- fixed leaderboard API issues
- fixed compilation warnings in FDT ide (www.fdt.powerflasher.com)
- removed debugging notes/traces from SWFStats package
- added SWFStatsTest package with debugging notes and server responses

LICENSE AND DISCLAIMER:

This code is provided as-is and with no warranty.  Failsafes are in place that *should* ensure your game will continue
to function should SWFStats be unavailable, but you use it at your own risk.

You may modify this code as you see fit but if you make changes to the core logic it may not provide any or accurate analytics.


--------------------------------------------------------------------------------------------------------------------------------
USING THE TEST VERSION
--------------------------------------------------------------------------------------------------------------------------------

The test version SWFStatsTest is completely interchangeable with the live version.  All class names and parameters are the same.


// the real tracker
import SWFStats;

OR

// the test tracker
import SWFStatsTest;

The SWFStatsTest version does NOT save your tracking data, it just tells you what you would be logging.


--------------------------------------------------------------------------------------------------------------------------------
LOGGING DATA
--------------------------------------------------------------------------------------------------------------------------------
Begin by logging a view which initalises the API, and then log any metrics you want.  Play time, repeat visitors etc are 
handled automatically.


Logging a view
___________________________________________

Call this at the very start of your game loading, eg from your document class constructor.

	Log.View(swfid:int, guid:String, defaulturl:String)
		swfid = from your API page in swfstats
		guid = from your API page in swfstats
		defaulturl = path to the swf, should be loaderInfo.loaderURL from your document or main class



Logging a play
___________________________________________

Call this when a player begins a game.  This may be 0 or many times during a view.

	Log.Play();



Logging custom metrics:
___________________________________________

Custom metrics can track any general events you want to follow, like clickthrough rate on your sponsorship
branding or difficulty level players select.

Call this to log any custom data you want to track.

	Log.CustomMetric(name:String, group:String)
		name = whatever you want to call your custom metric, eg "Clicked sponsor link"
		group = optional group name, you can specify in-game or assign in my.swfstats.com



Logging level metrics:
___________________________________________

Level metrics can identify problems players are having with your difficulty and by logging information
like how many people begin vs. finish each level you can identify major problems in your player retention.

These methods log the 3 types of level metrics - counters, ranged-value and average-value metrics.

- Counter metrics count how many times an event occurs across levels
- Ranged-value metrics track multiple values across a single event aross levels, like lives lost
- Average-value metrics track the average of something across levels, like points or gold collected


Log.LevelCounterMetric(name:String, level:*)

	name = your metric name
	level = either a level number (int > 0) or a level name (eg "kitchen")


Log.LevelRangedMetric(name:String, level:*, value:int)
	name = your metric name
	level = either a level number (int > 0) or a level name (eg "kitchen")
	value = the value you want to track


Log.LevelAverageMetric(name:String, level:*, value:int)
	name = your metric name
	level = either a level number (int > 0) or a level name (eg "kitchen")
	value = the value you want to track



--------------------------------------------------------------------------------------------------------------------------------
LEVEL SHARING
--------------------------------------------------------------------------------------------------------------------------------

The level sharing API provides a way to store and retrieve user-generated content for your game. It can operate anonymously or authenticated via any 3rd party service you're already using.

The PlayerLevel object
___________________________________________


The PlayerLevel class consists of:
	LevelId (String)  = Assigned by SWFStats
	PlayerSource (String, Optional) = Eg: "GamerSafe", "MochiCoins", ignore if anonymous
	PlayerId (String, Optional) = The user identifier provided by the PlayerSource, ignore if anonymous
	PlayerName (String, Optional) = The username provided by the PlayerSource, ignore if anonymous
	Data (String) = The level data
	Votes (int) = Number of votes on this level
	Plays (int) = Number of plays for this level
	Rating (Number) = The rating out of 10
	Score (int) = The sum of all votes
	Thumbnail (String, read only) = The url of the thumbnail. You don't need to use this if it is faster to construct thumbnails from the data.

The PlayerX information is optional if you are using another service or API that authenticates users for you. It is used for administration purposes and in the future will 
allow users to edit / list their own and friends levels. If you are not using any other service then ignore the fields, level sharing can be anonymous.

Saving levels
___________________________________________

Levels are saved by creating a PlayerLevel object and then saving it.

	PlayerLevels.Save(level, thumb, callback)
		level (PlayerLevel) = your PlayerLevel object
		thumb (DisplayObject) = any display object (movieclip, sprite, bitmap etc), this is scaled to maximum 100x100 and saved as a PNG
		callback (Function) = called when the save is complete

public function ClickedSaveButton(e:MouseEvent):void
{
    var level:PlayerLevel = new PlayerLevel();
    level.Name = "My level";
    level.Data = level_data; // level data is a string and can be up to about 3 megabytes
			
    PlayerLevels.Save(level, my_thumbnail, this.SaveComplete); // my_thumbnail is whatever you want or generate for the thumb
}

private function SaveComplete(level:PlayerLevel, success:Boolean, status:int):void
{
    // success
    if(success)
    {
    trace("Level saved successfully, the 'level' parameter is ready for use!");
}

// failure
else
{
    switch(status)
    {
        case PlayerLevels.SAVE_FAILED_GENERAL_ERROR:
        trace("A general error occurred");
        break;
						
        case PlayerLevels.SAVE_FAILED_LEVEL_EXISTS:
        trace("This level has already been saved");
        break;
						
        case PlayerLevels.SAVE_INVALID_THUMB:
        trace("Thumbnail failed validation");
        break;
    }			
}


Rating levels
___________________________________________

Users may rate anonymously.  Precautions are in place to ensure they can't game the system easily.  Authenticated rating is coming soon.

	PlayerLevels.Rate(levelid, rating, callback)
		levelid (String) = the playerlevel.LevelId
		rating (int) = 	a value between 0 and 10 inclusive
		callback (Function) = called when the rating is complete

private function Rate(e:MouseEvent):void
{
    PlayerLevels.Rate(level.LevelId, 8, this.RateComplete);
}
		
private function RateComplete(success:Boolean):void
{
    trace("Rating complete: " + success);
}


Listing levels
___________________________________________

PlayerLevels.List(callback, mode, page = 1, perpage = 20, data = false, datemin = "", datemax = "")
	callback(Function) = called when the rating is complete
	mode(String) = newest or popular
	page(int) = The page number starting at 1 (defaults to 1)
	perpage(int) = The number of levels to include
	data(Boolean) = Returns level data along with information. On large levels or lists this might add to the loading time but it allows you to generate thumbnails programatically which may be very fast. Defaults to false.
	datemin(String) = Optional minimum date for when levels were created, used to get for instance best levels this month
	datemax(String) = Optional maximum date for when levels were created

Your callback function will receive two parameters:
	levels(Array) = Array of PlayerLevel objects
	numresults(int) = The total number of levels you have for use with whatever pagination (if any) you implement


private function ListLevels(e:MouseEvent):void
{
	PlayerLevels.List(this.ListLoaded, "newest", 1, 20);
}
		
private function ListLoaded(levels:Array, numresults:int):void
{
	trace(numresults + " levels loaded total");
			
	for each(var level:PlayerLevel in levels)
	{
		trace(" -> " + level.LevelId + ": " + level.Name);
	}
}



Loading levels
___________________________________________

If you do not include the data when you load lists of levels then you can request it seperately:

	PlayerLevels.Load(levelid, callback)
		levelid (String) = the playerlevel.LevelId
		callback (Function) = called when the loading is complete

Your callback function will be passed a PlayerLevel as a parameter.

private function Load(e:MouseEvent):void
{
	PlayerLevels.Load(level.LevelId, this.LoadComplete);
}
		
private function LoadComplete(level:PlayerLevel):void
{
	if(level != null)
	{
		trace("Level has been loaded, now you can begin playing it");
	}
	else
	{
		trace("Load failed");
	}
}

--------------------------------------------------------------------------------------------------------------------------------
HIGH SCORES API
--------------------------------------------------------------------------------------------------------------------------------
The high scores API lets you have leaderboards in your game for highest / lowest scores.  The leaderboards can be used externally
to your game for Facebook applications.

HighScores.Scores(global:Boolean, table:String, callback:Function, mode:String)
	global = show the scores only for the site you're on, or for everywhere
	table = the score table, you can have as many as you want eg "easy", "medium", "hard"
	callback = the function to send the scores to
	mode = today, last30days or (default) alltime

The callback function will receive an array of objects with these properties:
	- Rank (int)
	- Name (string)
	- Points (int)
	- Website (string, site the score was logged on)
	- SDate (date the score was logged on

A similar method exists for retrieving Facebook score tables within your game.  Because only the fb:userid is stored you will
need your own script that converts the user ids to player names within your application.

HighScores.FacebookScores(table:String, callback:Function, friendlist:Array, mode:String)
	table = the score table, you can have as many as you want eg "easy", "medium", "hard"
	callback = the function to send the scores to
	friendslist = optional array of friends user ids to show only friends scores
	mode = today, last30days or (default) alltime


To save a score:

HighScores.Submit(name:String, score:int, table:String, oncomplete:Function, facebook:Boolean)
	name = the player's name or facebook id
	score = their score
	table = the score table
	oncomplete = function to run when it finishes
	facebook = boolean true or false

The callback function will receive a boolean true or false for whether the score submission worked.

Showing the scores on Facebook applications is done by accessing special XML feeds of your scores.  Due to privacy concerns
you can only store facebook users as their fb:userid and not their full name, so you can't really use a Facebook score table
in conjunction with non-facebook users.  (ie you have a table "facebook" that is for facebook, and another one for everyone else).

http://utils.swfstats.com/leaderboards/getfb.aspx?guid=xxx&swfid=xxx&table=whatever&fbuserid=xxx&mode=xxx
Mode can be 'today', 'last30days' or 'alltime'

To only request the user's friends scores:
http://utils.swfstats.com/leaderboards/getfb.aspx?guid=xxx&swfid=xxx&table=whatever&fbuserid=xxx&mode=xxx&friendlist=xxx,xxx,xxx,xxx



--------------------------------------------------------------------------------------------------------------------------------
GEOIP
--------------------------------------------------------------------------------------------------------------------------------
Once you have logged a view (which initialises the API) you may request the player's country information using the new 
GeoIP class.

public function MyDocumentClass()
{
    // game has started
    Log.View(0, "aaaaa-bbbbb....");
    GeoIP.Lookup(this.OutputCountry);
}

private function OutputCountry(country:Object):void
{
    trace("You are from " + country.Code + " - " + country.Name);
}



--------------------------------------------------------------------------------------------------------------------------------
DATA API
--------------------------------------------------------------------------------------------------------------------------------
NOTE:  YOU MUST ENABLE THIS IN YOUR GAME PROFILE.  BY DEFAULT IT IS DISABLED BECAUSE IT COULD BE USED TO ACCESS YOUR GAME DATA.
TO ENABLE THE DATA API SIGN IN TO MY.SWFSTATS.COM AND GO TO THE EDIT GAME DETAILS PAGE.


Each function for retrieving data takes 3 optional parameters for day, month and year, with default values of 0.

 - When day, month and year are each not 0 then you will receive data for that specific day.
 - When month and year are both not 0 then you will receive data for that specific month.
 - When day, month and year are all 0 then you will receive data for all time.


Requesting views, plays and play time:
___________________________________________

Get.General(type:String, callback:Function);
Get.General("Views", this.OutputData);			// VIEWS FOR ALL TIME
Get.General("Plays", this.OutputData, 22, 3, 2010);	// PLAYS ON 22 MARCH, 2010
Get.General("PlayTime", this.OutputData, 0, 3, 2010);	// PLAY TIME FOR MARCH 2010

private function OutputGeneral(name:String, date:String, value:int):void
{
	trace(name + ": " + value + " for date " + date);
}


Progress goals:
___________________________________________

Goals are handled in the exact same way as views/plays/play time

Get.Goal(goalname:String, callback:Function);
Get.Goal("Started level 1", this.OutputData);
Get.Goal("Started level 1", this.OutputData, 22, 3, 2010);
Get.Goal("Started level 1", this.OutputData, 22, 3, 2010);

private function OutputGeneral(name:String, date:String, value:int):void
{
	trace(name + ": " + value + " for date " + date);
}


Custom metrics:
___________________________________________

Custom metrics are handled in the exact same way as views/plays/play time

Get.CustomMetric(name:String, callback:Function);
Get.CustomMetric("Clicked start button", this.OutputData);
Get.CustomMetric("Clicked start button", this.OutputData, 22, 3, 2010);
Get.CustomMetric("Clicked start button", this.OutputData, 22, 3, 2010);

private function OutputGeneral(name:String, date:String, value:int):void
{
	trace(name + ": " + value + " for date " + date);
}


Level metrics:
___________________________________________


Get.LevelMetricCounter(name:String, level:*, callback:Function);
Get.LevelMetricCounter("Started level", 1, this.OutputLevelCounter);
Get.LevelMetricCounter("Started level", 1, this.OutputLevelCounter, 22, 3, 2010);
Get.LevelMetricCounter("Entered area", "Kitchen", this.OutputLevelCounter, 0, 3, 2010);

private function OutputLevelCounter(name:String, date:String, level:String, value:int):void
{
	trace(name + ": " + value + " for level " + level + ", " + date);
}

Get.LevelMetricRanged(name:String, level:*, callback:Function);
Get.LevelMetricRanged("Shots remaining", 1, this.OutputLevelRanged);
Get.LevelMetricRanged("Shots remaining", 1, this.OutputLevelRanged, 22, 3, 2010);
Get.LevelMetricRanged("Shots remaining", 1, this.OutputLevelRanged, 0, 3, 2010);

private function OutputLevelRanged(name:String, date:String, level:String, values:Array):void
{
	trace(name + ", level " + level + " for date " + date);
	
	for(var i:int=0; i<values.length; i++)
	{
		var x:Object = values[i];
		trace("Tracking value: " + x.Value + ", " + x.Occurances + " occurances);
	}
}


Get.LevelMetricAveraged(name:String, level:*, callback:Function);
Get.LevelMetricAveraged("Retries", 1, this.OutputLevelAverage);
Get.LevelMetricAveraged("Retries", 1, this.OutputLevelAverage, 22, 3, 2010);
Get.LevelMetricAveraged("Retries", 1, this.OutputLevelAverage, 0, 3, 2010);

private function OutputLevelAverage(name:String, date:String, level:String, average:int, max:int, min:int):void
{
	trace(name + ": average" + average + " (min: " + min + ", max: " + max + ") for level " + level + ", " + date);
}