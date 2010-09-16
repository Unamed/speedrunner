package cas.spdr.state 
{
	import cas.spdr.state.LevelState;
	import org.flixel.FlxG;
	import cas.spdr.actor.Deathwall;
	import cas.spdr.gfx.GraphicsLibrary;
	import SWFStats.Log;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Boss2LevelState extends BossLevelState
	{		
		public function Boss2LevelState() 
		{
			super();			
		}
		
		override public function addGameElements():void
		{
			super.addGameElements();
			
			deathWall = new Deathwall(0, player.y + 325, 2400, 600, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));			
			deathWall.velocity.y = -80;
			this.add(deathWall);
		}
		
		override public function restartLevel():void
		{				
			FlxG.switchState(Boss2LevelState);		
			
			if ( bPerformSWFLogging )
			{
				Log.LevelCounterMetric("Re-started", FlxG.level );
			}
		}	
	}

}