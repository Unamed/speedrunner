package 
{
	import org.flixel.FlxGame;
	import SWFStats.*;
		
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
			help("Jump / Hook", "Nothing", "Nothing");
			
			showLogo = false;
			
			// Stats:
			SWFStats.Tracker.Initialise(loaderInfo.loaderURL);
			
			SWFStats.Tracker.LogView();
			SWFStats.Tracker.LogPlay();
		}
	}	
}
