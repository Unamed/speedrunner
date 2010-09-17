package cas.spdr.state 
{
	import cas.spdr.actor.Deathwall;
	import cas.spdr.map.MapPreBoss1;
	import cas.spdr.state.LevelState;
	import flash.geom.Point;
	import org.flixel.FlxG;
	import cas.spdr.gfx.GraphicsLibrary;	
	import org.flixel.FlxSprite;
	import SWFStats.Log;
	//import SWFStatsTest.Log;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Boss1LevelState extends BossLevelState
	{		
		private var deathFloor1:Deathwall;
		private var deathFloor2:Deathwall;
		private var deathFloor3:Deathwall;
		private var deathFloor4:Deathwall;
		
		protected var deathWallSpeed:Number;
		
		private var deathFloors:Array;
		
		public function Boss1LevelState() 
		{
			super();			
		}		
		
		override public function initLevel():void
		{				
			introMap = new MapPreBoss1();
			
			deathWallSpeed = 375;
			
			super.initLevel();	
			
			introCam = new FlxSprite( -2800, playerStartY);
			introCam.width = 21;
			introCam.height = 46;
			introCam.offset.x = 11;	//2
			introCam.offset.y = 4;
			
			introCam.alpha = 0;
			introCam.velocity.x = 600;
			introCam.acceleration.x = 0;
			this.add(introCam);
			
			bDoingIntro = true;
			player.bCinematicMode = true;
			
			FlxG.cameraOffset = new Point(0, 75);
			FlxG.follow(introCam, 1.5);
			FlxG.followAdjust(1.0, 0.25);	
			flanmap.layerMain.follow();
			FlxG.followMin.x = 3000;	
			
			player.x = -200;
		}

		override public function addMainLayer():void
		{		
			this.add(introMap.layerMain);
			
			super.addMainLayer();				
		}
		
		// add deathwall and deathfloors
		override public function addGameElements():void
		{
			super.addGameElements();
			
			trace("deathWallSpeed:" + deathWallSpeed);
			deathWall = new Deathwall(player.x - 2700, player.y -900, 800, 1800, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL_SIDE));
			deathWall.velocity.x = deathWallSpeed;
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
				
		// collide with deathFloor
		// and perform quake
		override public function update():void
		{			
			super.update();
			
			FlxG.collideArray(deathFloors, player);
			
			if ( deathWall.active )
			{
				if ( this.bDoingIntro )
				{
					FlxG.quake(0.008, 1);					
				}
				else
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
			}
			else 
				FlxG.quake(0.0, 1);			
		}	
		
		override public function restartLevel():void
		{				
			FlxG.switchState(Boss1LevelState);	
			
			if ( bPerformSWFLogging )
			{
				Log.LevelCounterMetric("Re-started", FlxG.level );
			}
		}	
	}
}