package cas.spdr.state 
{
	import cas.spdr.actor.Deathwall;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BossLevelState extends LevelState
	{
		protected var deathWall:Deathwall;
		
		public function BossLevelState() 
		{
			super();			
		}
		
		override public function initLevel():void
		{	
			bShowHUD = false;	
			super.initLevel();	
				
			startTimer();
		}
		
		override public function update():void
		{			
			super.update();
			
			if( deathWall && deathWall.active )
				deathWall.collide(player);
				
			//@TODO: maybe visually display the progress of the player through the level,
			// calculated like this: 
			//var progress:int = (player.x / flanmap.layerMain.width)
			//this.debugTxt.text = "" + progress;
		}
		
		override public function restartLevel():void
		{				
			FlxG.switchState(BossLevelState);						
		}	
		
		override public function stopTimer():void
		{
			if ( deathWall )
			{
				deathWall.active = false;
				deathWall.velocity.x = 0;
				deathWall.velocity.y = 0;
			}
			
			super.stopTimer();
		}		
	}
}