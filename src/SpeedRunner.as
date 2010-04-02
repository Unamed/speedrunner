package 
{
	import org.flixel.*;
	import SWFStats.Log;
		
	[SWF(width="800", height="600", backgroundColor="#000000")]	
		
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SpeedRunner extends FlxGame 
	{	
		public function SpeedRunner():void 
		{			
			super(800, 600, MainMenuState, 1);// , 0xff131c1b, false, 0xff729954);
			
			FlxG.levels.push(MapMainMenu);
			FlxG.levels.push(MapTheLion);
			FlxG.levels.push(MapTheHydra);
			FlxG.levels.push(MapTheHind);
			
			FlxG.level = 0;
			
			var save:FlxSave = new FlxSave("SpeedRunner03");
			FlxG.progressManager.bUnlockedHook = (save.read("bUnlockedHook") as Boolean);
			FlxG.progressManager.lionBest = (save.read("lionBest") as Number);
			FlxG.progressManager.hydraBest = (save.read("hydraBest") as Number);
			FlxG.progressManager.hindBest = (save.read("hindBest") as Number);
			
			FlxG.saves = new Array();
			FlxG.saves.push( save );		
			FlxG.save = 0;
			
			
			help("Jump / Hook", "Nothing", "Nothing");
			
			showLogo = false;
			
			// Stats:
			//SWFStats.Tracker.Initialise(loaderInfo.loaderURL);
			
			//SWFStats.Tracker.LogView();
			//SWFStats.Tracker.LogPlay();
			
			Log.View(153, "6635b062-cc5b-4c1b-819c-1f1b48b4ad75", root.loaderInfo.loaderURL);
			
		}
	}	
}
