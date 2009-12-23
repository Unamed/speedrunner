package  
{
	import flash.geom.Point;
	import org.flixel.*;
	
	import flash.filters.BlurFilter;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
		
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class PlayState extends FlxState
	{
		[Embed(source = "../data/temp/main_flan.txt", mimeType = "application/octet-stream")] private var TxtMap:Class;
		[Embed(source = "../data/temp/bg_flan.txt", mimeType = "application/octet-stream")] private var BgMap:Class;
		[Embed(source = "../data/temp/fg_map.txt", mimeType = "application/octet-stream")] private var FgMap:Class;
		//[Embed(source = "../data/temp/tiles_new_small.png")] private var ImgTiles:Class;
		[Embed(source = "../data/temp/tiles_black_32.png")] private var ImgTiles:Class; 
		[Embed(source = "../data/temp/tiles_background.png")] private var BgTiles:Class;
		[Embed(source = "../data/temp/tiles_foreground.png")] private var FgTiles:Class;
		[Embed(source = "../data/temp/tile_slope_down.png")] private var SlopeTiles:Class;
		
		//[Embed(source = "../data/temp/MapCSV_SR_Playground_Collision.txt", mimeType = "application/octet-stream")] private var TxtMap:Class;		
		
		// FLAN CODE:
		private var _map:MapBase;
		
		//major game objects
		private var tilemap:FlxTilemap;		
		private var bgmap:FlxTilemap;
		private var fgmap:FlxTilemap;
		
		public var player:Player;
		public var hooks:Array;	
		
		private var obstacles:Array;
		private var timerTxt:FlxText;
		private var debugTxt:FlxText;
		private var playTime:Number;
		
		private var start:StartTrigger;
		private var finish:FinishTrigger;
		
		private var bIsTimer:Boolean;

		// Google Analytics:
		private var tracker:GATracker;
		
		
		// temp slopes:
		private var slopes:Array;
		private var slopeDowns:Array;
		
		private var blurLayer:BlurLayer;
		

		
		public function PlayState() 
		{
			super();
			
			// 0. set default settings
			// 1. create tilemap
			// 2. create sprites (obstacles, boost, triggers)
			// 3. create player & hooks
			// 4. camera settings
			// 4. add to stage in correct order
			
			bgColor = 0xFF7678CB;
			
			
			playTime = 0;		
			//FlxG.followBounds(_map.boundsMinX, _map.boundsMinY, _map.boundsMaxX, _map.boundsMaxY);
			
			// create tilemap
			tilemap = new FlxTilemap();
			tilemap.loadMap(new TxtMap, ImgTiles, 16);
			tilemap.collideIndex = 31;				
			
			// BG map
			bgmap = new FlxTilemap();
			bgmap.loadMap(new BgMap, FgTiles, 16);
			bgmap.collideIndex = 15;
			bgmap.scrollFactor = new Point(0.5, 0.5);	
			
			// FG map
			fgmap = new FlxTilemap();			
			fgmap.loadMap(new FgMap, FgTiles, 16);
			fgmap.collideIndex = 15;
			fgmap.scrollFactor = new Point(2.0, 2.0);			
			
			
			//_map = new MapSR_Playground();
			//Add the layers to current the FlxState
			//FlxG.state.add(_map.layerCollision);
			//_map.addSpritesToLayerCollision(onAddSpriteCallback);
			//FlxG.state.add(_map.layerObstacles);
			//_map.addSpritesToLayerObstacles(onAddSpriteCallback);
			
			// create sprites
			var obj:Obstacle = new Obstacle(1148, 550);
			obstacles = new Array();						
			obstacles.push(obj);
			
			// Test BOOST:
			var bst:BoostSection = new BoostSection(1350, 528);
			bst.createGraphic(200, 32, 0xFF0000FF);
			bst.width = 200;
			bst.height = 32;			
			obstacles.push(bst);
			
			// TEXTS:
			timerTxt = new FlxText(300, 100, 200, "Timer");
			timerTxt.scrollFactor = new Point(0, 0);	
			timerTxt.size = 15;				
			
			debugTxt = new FlxText(300, 150, 200, "Debug");
			debugTxt.scrollFactor = new Point(0, 0);	
			debugTxt.size = 10;	
			
			// Triggers:
			start = new StartTrigger(200, 370);
			finish = new FinishTrigger(2400, 370);
			
			
				
			
							
			
			
			//blurLayer = new BlurLayer();
			//this.add(blurLayer);
			this.add(bgmap);
			
			///////////////////////// TEMP STUFF, EXPERIMENTAL:
			///
			// more temp:
			slopeDowns = new Array();
			slopeDowns.push(this.add(new SlopeDown(480, 384, SlopeTiles)));
			slopeDowns.push(this.add(new SlopeDown(496, 400, SlopeTiles)));
			slopeDowns.push(this.add(new SlopeDown(512, 416, SlopeTiles)));			
			slopeDowns.push(this.add(new SlopeDown(528, 432, SlopeTiles)));
			slopeDowns.push(this.add(new SlopeDown(544, 448, SlopeTiles)));
			slopeDowns.push(this.add(new SlopeDown(560, 464, SlopeTiles)));			
			slopeDowns.push(this.add(new SlopeDown(576, 480, SlopeTiles)));			
			slopeDowns.push(this.add(new SlopeDown(592, 496, SlopeTiles)));
			slopeDowns.push(this.add(new SlopeDown(608, 512, SlopeTiles)));
			slopeDowns.push(this.add(new SlopeDown(624, 528, SlopeTiles)));			
			slopeDowns.push(this.add(new SlopeDown(640, 544, SlopeTiles)));
			
			slopeDowns.push(this.add(new SlopeDown(1840, 560, SlopeTiles)));
			slopeDowns.push(this.add(new SlopeDown(1856, 576, SlopeTiles)));			
			slopeDowns.push(this.add(new SlopeDown(1872, 592, SlopeTiles)));
			
			
			
			
			
			//Add your blocks
			slopes = new Array();			
			//slopes.push(this.add(new SlopeBlock(480, 384, 656, 566, 16, SlopeTiles) ) );		
			
			//slopes.push(this.add(new SlopeBlock(220, 300, 420, 232, 32, ImgTiles) ) );	
			//slopes.push(this.add(new SlopeBlock(420, 2032, 520, 2090, 32, ImgTiles) ) );
			
			
			// Finally, add everything to stage:
			
			// create player and hooks				
			player = new Player(150, 300);
			hooks = new Array();
			for(var i:uint = 0; i < 1; i++)
				hooks.push(this.add(new Hook(player)));					
			player.setHooks(hooks);
			
			// camera settings			
			FlxG.follow(player,1.5);
			FlxG.followAdjust(1.0,0.25);			
			tilemap.follow();	
			//_map.layerCollision.follow();	//Set the followBounds to the map dimensions
			
			this.add(bst);			
			player.addToState(this);			
			this.add(tilemap);
			//this.add(_map.layerCollision);
			this.add(timerTxt);
			this.add(debugTxt);
			this.add(start);
			this.add(finish);
			this.add(obj);
			
			this.add(fgmap);
			
			//fade in
			FlxG.flash(0xff131c1b);
		}
		
		
		
		public function resetGame():void
		{
			player.x = 150;
			player.y = 300;
			
			player.velocity = new Point(0, 0);
			player.acceleration.x = 0;
			playTime = 0;
			bIsTimer = false;
			
		}

		// MAIN UPDATE FUNCTION:
		// 1. Update childs
		// 2. Run game state updates (timers, etc.)
		// 3. Perform collision checks		
		override public function update():void
		{
			// RUN UPDATE ON ALL CHILDS:
			super.update();
			
			// Debugging:
			if( player.status == 0 )
				debugTxt.text = "" + "Status: " + "onGround";
			if( player.status == 1 )
				debugTxt.text = "" + "Status: " + "onWall";
			if( player.status == 2 )
				debugTxt.text = "" + "Status: " + "onSlopeDown";
			if( player.status == 3 )
				debugTxt.text = "" + "Status: " + "onSlopeUp";
			if( player.status == 4 )
				debugTxt.text = "" + "Status: " + "inAir";
			if( player.status == 5 )
				debugTxt.text = "" + "Status: " + "swinging";
				
			//debugTxt.text = "Facing: " + player.facing;
			
			// Google Analytics:			
			if ( !tracker )
				tracker = new GATracker(this, "UA-12125437-1", "AS3", false );
			
			// Various Input
			if ( FlxG.keys.justPressed("ESC") )
				resetGame();				
						
			// Timer
			if( bIsTimer )
				playTime += FlxG.elapsed;
			timerTxt.text = "Timer: " + playTime.toFixed(2);
			
			// COLLISION:
			
			var playerCol:Boolean = false;
			if ( tilemap.collide(player) )
				playerCol = true;
			if ( FlxG.overlapArray(slopeDowns, player, player.hitSlope) )
				playerCol = true;
			
			if ( !playerCol )
				player.hitNothing();
			
			FlxG.collideArray(obstacles, player);
			start.collide(player);
			finish.collide(player);
			
			if ( hooks[player.prevHook].exists )
			{
				tilemap.collide(hooks[player.prevHook]);
				//_map.layerCollision.collide(hooks[player.prevHook]);			
			}
			
			// OBSOLETE:
			//SlopeBlock.collideSlopeArray(slopes, player);
			//_map.layerCollision.collide(player);
			//slD.collide(player);
			
			
		}	
		
		public function startTimer():void
		{
			playTime = 0;
			bIsTimer = true;			
			
			//tracker.trackPageview("/started");// "/FisherGirl");
			//tracker.trackEvent("Timing Events", "Started", "Label", playTime );			
		}
		
		public function stopTimer():void
		{
			bIsTimer = false;
			//tracker.trackEvent("Timing Events", "Finished", "Label", playTime );			
		}	
		
		protected function onAddSpriteCallback(obj:FlxSprite):void
		{			
			if ( obj is Obstacle )
			{
				obstacles.push(obj);				
			}
		}
		
		// OBSOLETE:
		/*
		public function slopeColl(Core:FlxCore,X:uint,Y:uint,Tile:uint):void
		{
			FlxG.log("slopeColl...");
			FlxG.log("Core: " + Core);
			FlxG.log("X: " + X);
			FlxG.log("Y: " + Y);			
			FlxG.log("Tile: "+Tile);
			
			
		}*/
	}

}