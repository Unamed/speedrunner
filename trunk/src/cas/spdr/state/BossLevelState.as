package cas.spdr.state 
{
	import cas.spdr.actor.Deathwall;
	import cas.spdr.map.MapPreBoss1;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	import cas.spdr.map.MapBase;
	import SWFStats.Log;
	//import SWFStatsTest.Log;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BossLevelState extends LevelState
	{
		protected var deathWalls:Array;// Deathwall;
		
		protected var introCam:FlxSprite;		
		protected var introMap:MapBase;
		protected var bDoingIntro:Boolean;
		
		
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
			if ( introMap != null && player.x < 0 )
				introMap.mainLayer.collide(player);			
			
			super.update();
			
			if ( introCam != null && bDoingIntro )
			{				
				if ( player.bCinematicMode && introCam.x > player.x - 600 )
				{				
					player.velocity.x = 100;					
				}
				
				if ( bDoingIntro && introCam.x > player.x )
				{
					player.velocity.x = 400;
					player.x = introCam.x;
						
					player.bCinematicMode = false;
					FlxG.followTarget = player;
					bDoingIntro = false;					
				}		
			}
			
			if ( deathWalls.length > 0 )
			{
				FlxG.collideArray(deathWalls, player);				
			}
			
			//if( deathWall && deathWall.active )
			//	deathWall.collide(player);
				
			//@TODO: maybe visually display the progress of the player through the level,
			// calculated like this: 
			//var progress:int = (player.x / flanmap.layerMain.width)
			//this.debugTxt.text = "" + progress;
			
		}
		
		public function onHitDeathwall():void
		{
			for ( var d:int = 0; d < deathWalls.length; d++ )
			{
				deathWalls[d].active = false;
				deathWalls[d].dead = true;			
				deathWalls[d].velocity.y = 0;	
			}			
			
		}
		
		override public function restartLevel():void
		{				
			FlxG.switchState(BossLevelState);	
			
			if ( bPerformSWFLogging )
			{
				Log.LevelCounterMetric("Re-started", FlxG.level );
			}
		}	
		
		override public function stopTimer():void
		{
			if ( deathWalls.length > 0 )
			{
				for ( var d:int = 0; d < deathWalls.length; d++ )
				{
					deathWalls[d].active = false;
					deathWalls[d].velocity.x = 0;
					deathWalls[d].velocity.y = 0;
				}
			}
			
			super.stopTimer();
		}		
	}
}