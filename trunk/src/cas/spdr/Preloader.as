package cas.spdr 
{
	import org.flixel.data.FlxFactory;
	import SWFStats.Log;
	
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Preloader extends FlxFactory
	{
		private var bPerformSWFLogging:Boolean = false;		// this variable is also present in PlayState.as!!!
		
		public function Preloader() 
		{			
			className = "cas.spdr.SpeedRunner";
			super();	
			
			if ( bPerformSWFLogging )
			{
				Log.View(153, "6635b062-cc5b-4c1b-819c-1f1b48b4ad75", root.loaderInfo.loaderURL);
				Log.Play();
			}
		}

		
	}

}