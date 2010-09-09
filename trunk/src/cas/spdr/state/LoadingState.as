package cas.spdr.state 
{
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class LoadingState extends FlxState
	{
		private var bLoadingComplete:Boolean;
		private var bLoading:Boolean;
		private var loadingCntDwn:Number = 2.0;
		
		public function LoadingState() 
		{
			super();
			
			bgColor = 0x000000;
			bLoading = true;
			
			//fade in
			FlxG.flash(0xff000000);
			
			var gTxt:FlxText = new FlxText(200, 200, 500, 
				"Loading Race.. " + "\n" + "\n" //+
				/*"Controls: " + "\n" +
				"LEFT, RIGHT to move" + "\n" +
				"Z - (Double) Jump (when unlocked)" + "\n" +
				"X - Shoot Grappling Hook (when unlocked)" + "\n" +
				"DOWN - Slide" + "\n" +								
				"ESC to main menu" + "\n" +
				"SPACE to restart level" + "\n \n"				*/
				);			
			gTxt.size = 16;							
			gTxt.scrollFactor = new Point(1, 1);				
			this.add(gTxt);	
			
		}
		
		override public function update():void
		{
			super.update();
			
			if ( bLoading )
			{
				loadingCntDwn -= FlxG.elapsed;
				if ( loadingCntDwn < 0 )
					bLoadingComplete = true;
				
				if ( bLoadingComplete )
				{	
					FlxG.fade(0xFF000000, 1, doSwitch);
					bLoading = false;
				}
			}
		}
		
		private function doSwitch():void
		{			
			// hardcoded hook for starting boss levels:
			if ( FlxG.level == 4 )
				FlxG.switchState(Boss1LevelState);
			else if ( FlxG.level == 8 )
				FlxG.switchState(Boss2LevelState);
			else if ( FlxG.level == 12 )
				FlxG.switchState(Boss1LevelState);
			else if ( FlxG.level == 13 )
				FlxG.switchState(FinalBossLevelState);
			else			
				FlxG.switchState(LevelState);				
		}
		
	}

}