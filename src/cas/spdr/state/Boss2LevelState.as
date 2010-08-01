package cas.spdr.state 
{
	import cas.spdr.state.LevelState;
	import org.flixel.FlxG;
	import cas.spdr.actor.Deathwall;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Boss2LevelState extends LevelState
	{
		// BOSS:
		private var deathWall:Deathwall;
		
		public function Boss2LevelState() 
		{
			super();
			
		}
		
		override public function initLevel():void
		{	
			bShowHUD = false;		
			
			super.initLevel();		
			
			FlxG.quake(0.0075, 3);
			startTimer();
		}

		override public function addGameElements():void
		{
			super.addGameElements();
			
			deathWall = new Deathwall(0, player.y + 325, 2400, 600, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));
			
			deathWall.velocity.y = -100;
			this.add(deathWall);
		}
		
		override public function update():void
		{			
			super.update();
			
			if( deathWall.active )
				deathWall.collide(player);
		}
		
		override public function restartLevel():void
		{				
			FlxG.switchState(Boss2LevelState);						
		}	
		
		override public function stopTimer():void
		{
			deathWall.active = false;
			deathWall.velocity.y = 0;
			super.stopTimer();
		}
	}

}