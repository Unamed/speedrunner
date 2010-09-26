package cas.spdr.state 
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class BeginState extends FlxState
	{
		private var startBtn:String = "Z";
		
		public function BeginState() 
		{
			super();
			
			bgColor = 0xFF000000;			
			
			//fade in
			//FlxG.flash(0xff000000);
			
			var text:String = "SpeedRunner" +
					"\n\n\n\n\n" +
					"Press "+startBtn+" to start";		
			
			var gTxt:FlxText = new FlxText(100, 200, 600, text);							
			gTxt.scrollFactor = new Point(1, 1);				
			gTxt.setFormat("Tahoma", 20, 0xFFFFFF, "center");
			this.add(gTxt);
		}
		
		override public function update():void
		{
			super.update();
			
			// Various Input				
			if ( FlxG.keys.justPressed(startBtn) )
			{
				FlxG.switchState( MainMenuState );
			}
		}
		
	}

}