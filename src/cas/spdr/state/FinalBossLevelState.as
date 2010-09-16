package cas.spdr.state 
{
	import cas.spdr.actor.Deathwall;
	import cas.spdr.gfx.GraphicsLibrary;
	import cas.spdr.map.MapPreBoss1;
	import flash.geom.Point;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FinalBossLevelState extends Boss1LevelState
	{		
		
		public function FinalBossLevelState() 
		{					
			
			
			super();
			
			
			
		}
		
		// add deathwall and deathfloors
		override public function addGameElements():void
		{
			deathWallSpeed = 350;
			super.addGameElements();
			
		}
		
		override public function restartLevel():void
		{				
			FlxG.switchState(FinalBossLevelState);						
		}	
		
	}

}