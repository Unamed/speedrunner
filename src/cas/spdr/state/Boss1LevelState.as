package cas.spdr.state 
{
	import cas.spdr.actor.Deathwall;
	import cas.spdr.state.LevelState;
	import org.flixel.FlxG;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Boss1LevelState extends LevelState
	{
		private var deathWall:Deathwall;
		private var deathFloor1:Deathwall;
		private var deathFloor2:Deathwall;
		private var deathFloor3:Deathwall;
		private var deathFloor4:Deathwall;
		
		private var deathFloors:Array;
		
		public function Boss1LevelState() 
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
			
			deathWall = new Deathwall(player.x - 1300, player.y -900, 800, 1800, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL_SIDE));			
			deathWall.velocity.x = 400;
			this.add(deathWall);
			
			// death floor:
			deathFloor1 = new Deathwall(0, 1600-16, 2400, 600, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));			
			this.add(deathFloor1);
			
			deathFloor2 = new Deathwall(2400, 1600-16, 2400, 600, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));						
			this.add(deathFloor2);
			
			deathFloor3 = new Deathwall(4800, 1600-16, 2400, 600, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));						
			this.add(deathFloor3);
			
			deathFloor4 = new Deathwall(7200, 1600-16, 2400, 600, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));						
			this.add(deathFloor4);
			
			deathFloors = new Array();
			deathFloors.push(deathFloor1);
			deathFloors.push(deathFloor2);
			deathFloors.push(deathFloor3);
			deathFloors.push(deathFloor4);
		}
		
		override public function update():void
		{			
			super.update();
			
			if( deathWall.active )
				deathWall.collide(player);
			
			FlxG.collideArray(deathFloors, player);
		}
		
		override public function restartLevel():void
		{				
			FlxG.switchState(Boss1LevelState);						
		}	
		
		override public function stopTimer():void
		{
			deathWall.active = false;
			deathWall.velocity.x = 0;
			
			super.stopTimer();
		}
		
	}

}