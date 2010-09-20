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
			
			// create deathwalls across the entire height of the map:
			deathWalls = new Array();									
			for ( var yloc:int = 0; yloc < flanmap.mainLayer.height; yloc += 384 )
			{
				// create a new deathwall section
				var deathWall:Deathwall = new Deathwall(player.x - 2500, yloc, 400, 384, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL_SIDE));
				deathWall.velocity.x = deathWallSpeed;
				
				// add it to the array and to the level
				deathWalls.push(deathWall);			
				this.add(deathWall);	
				
				// create another deathwall section, that faces the other way (this makes the wall twice as wide)
				var deathWall2:Deathwall = new Deathwall(player.x - 2900, yloc, 400, 384, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL_SIDE), true);
				deathWall2.velocity.x = deathWallSpeed;
				deathWall2.facing = FlxSprite.LEFT;
				deathWall2.dead = true;
				
				// ..and also add it to the array and to the level
				deathWalls.push(deathWall2);			
				this.add(deathWall2);					
			}
				
			// also add death floors across the entire length of the map:
			deathFloors = new Array();
			for ( var xloc:int = 0; xloc < flanmap.mainLayer.width; xloc += 384 )
			{
				var deathFloor:Deathwall = new Deathwall(xloc, flanmap.mainLayer.height-16, 384, 400, GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_DEATHWALL));			
				this.add(deathFloor);
				deathFloors.push(deathFloor);			
			}
		}
				
		// collide with deathFloor
		// and perform quake
		override public function update():void
		{			
			super.update();
			
			FlxG.collideArray(deathFloors, player);
			
			if ( deathWalls.length > 0 && (deathWalls[0] as Deathwall).active)
			{
				if ( this.bDoingIntro )
				{
					FlxG.quake(0.008, 1);					
				}
				else
				{
					var wallDist:int = player.x - (deathWalls[0] as Deathwall ).x -800; 
					
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