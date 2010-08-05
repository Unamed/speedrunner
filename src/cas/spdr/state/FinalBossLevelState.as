package cas.spdr.state 
{
	import cas.spdr.actor.Deathwall;
	import cas.spdr.gfx.GraphicsLibrary;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FinalBossLevelState extends BossLevelState
	{		
		private var deathFloor1:Deathwall;
		private var deathFloor2:Deathwall;
		private var deathFloor3:Deathwall;
		private var deathFloor4:Deathwall;
		private var deathFloors:Array;		
		
		public function FinalBossLevelState() 
		{
			super();			
		}
		
		// add deathwall and deathfloors (TODO: more floors)
		override public function addGameElements():void
		{
			super.addGameElements();
			
			deathWall = new Deathwall(player.x - 1300, player.y -900, 800, 1800, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL_SIDE));
			deathWall.velocity.x = 350;
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
		
		// collide with deathfloors 
		// and perform quak
		override public function update():void
		{			
			super.update();
			
			FlxG.collideArray(deathFloors, player);
			
			if ( deathWall.active )
			{
				var wallDist:int = player.x - deathWall.x -800; 
				
				if ( wallDist > 800 )
					FlxG.quake(0.00, 1);				
				else if ( wallDist > 500 )
					FlxG.quake(0.001, 1);				
				else if ( wallDist > 300 )
					FlxG.quake(0.004, 1);				
				else
					FlxG.quake(0.008, 1);
			}
			else 
				FlxG.quake(0.0, 1);			
		}
		
		override public function restartLevel():void
		{				
			FlxG.switchState(FinalBossLevelState);						
		}	
		
	}

}