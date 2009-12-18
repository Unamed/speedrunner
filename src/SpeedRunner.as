package 
{
	import org.flixel.FlxGame;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;

	
	
	[SWF(width="800", height="600", backgroundColor="#000000")]	
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class SpeedRunner extends FlxGame 
	{		
		private var tracker:GATracker;
		
		public function SpeedRunner():void 
		{			
			super(800, 600, PlayState, 1);// , 0xff131c1b, false, 0xff729954);
			help("Jump / Hook", "Nothing", "Nothing");
			
			tracker =  new GATracker(this, "UA-12125437-1", "AS3", false );
			tracker.trackPageview("/started");// "/FisherGirl");
			
			showLogo = false;
		}
	}	
}