package cas.spdr
{
	import cas.spdr.map.*;
	import cas.spdr.state.BeginState;
	import FGL.GameTracker.GameTracker;
	import org.flixel.*;
	//import cas.spdr.Preloader;
		
	[SWF(width = "800", height = "600", backgroundColor = "#000000")]	
	//[Frame(factoryClass="cas.spdr.Preloader")]
		
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SpeedRunner extends FlxGame 
	{	
		public function SpeedRunner():void 
		{	
			super(800, 600, BeginState, 1);// , 0xff131c1b, false, 0xff729954);		
			
			// main menu is level 0
			FlxG.levels.push(MapMainMenu);
			
			FlxG.levels.push(MapTheLion);
			
			FlxG.levels.push(MapTheHydra);			
			FlxG.levels.push(MapTheHind);
			FlxG.levels.push(MapBoss1);
			
			FlxG.levels.push(MapLevel4);
			FlxG.levels.push(MapLevel5);			
			FlxG.levels.push(MapLevel6);
			FlxG.levels.push(MapBoss2);
			
			FlxG.levels.push(MapLevel7);									
			FlxG.levels.push(MapLevel8);
			FlxG.levels.push(MapLevel9);
			FlxG.levels.push(MapBoss3);
			
			FlxG.levels.push(MapBoss4);
			
			FlxG.level = 0;
			
			var save:FlxSave = new FlxSave();
			save.bind("SpeedRunner07");
			FlxG.progressManager.readSaveData(save);						
			FlxG.saves = new Array();
			FlxG.saves.push( save );		
			FlxG.save = 0;
			
			showLogo = false;		
			
			// FGL tracking:
			FlxG.fglTracker = new GameTracker();
			FlxG.fglTracker.beginGame();
		}
	}	
}
