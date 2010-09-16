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
			
			var text:String;
			switch( FlxG.level )
			{
				case 1:
					text = "Loading Race.. " + "\n" + "\n" +
					"\n\n\n\n\n" +
					"Jump: Z\n" + 
					"Slide: down";
					break;
				case 2:
				case 3:
					text = "Loading Race.. " + "\n" + "\n" +
					"Tip: Use the grappling hook \nto reach higher platforms \nand find quicker routes\n\n\n" +
					"Jump: Z\n" + 
					"Hook: X";
					break;
				case 4:
					text = "Warning: Wall of Death approaching!" + "\n" + "\n" +
					"Use your grappling hook to stay ahead \nof the deadly spikes\n\n\n\n\n";
					break;
				case 5:
				case 6:
				case 7:
					text = "Loading Race.. " + "\n" + "\n" +
					"Tip: Use walljumping \nto find alternate routes \n\n\n\n\n" +
					"Jump: Z\n" + 
					"Hook: X";
					break;				
				case 8:
					text = "Warning: Deathfloor is rising! " + "\n" + "\n" +
					"Use your walljumping ability to stay ahead \nof deadly spikes \n\n\n\n\n";
					break;
				case 9:
				case 10:
				case 11:
					text = "Loading Race.. " + "\n" + "\n" +
					"Tip: Use doublejumping \nto find the quickest routes \n\n\n\n\n" +
					"Jump: Z\n" + 
					"Hook: X";
					break;	
				case 12:
					text = "Warning: Wall of Death is back! " + "\n" + "\n" +
					"Use your doublejumping skills to stay ahead \nof the deadly spikes\n\n\n\n\n";
					break;
				case 13:
					text = "Warning: This challenge is really hard";
					break;
				default:
					text = "Loading Race.. " + "\n" + "\n" +
					"Try to find the fastest route to the finish! \n\n\n\n\n" +
					"Jump: Z\n" + 
					"Hook: X";
					break;				
			}
			
			
			var gTxt:FlxText = new FlxText(200, 200, 500, text);				
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