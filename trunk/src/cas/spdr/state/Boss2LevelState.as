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
			
			// create deathwalls across the entire length of the map:
			deathWalls = new Array();									
			for ( var xloc:int = 0; xloc < flanmap.mainLayer.width; xloc += 384 )
			{
				// create a new deathwall section
				var deathWall:Deathwall = new Deathwall(xloc, player.y + 325, 384, 400, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));
				deathWall.velocity.y = -80;
				
				// add it to the array and to the level
				deathWalls.push(deathWall);			
				this.add(deathWall);					
			}
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