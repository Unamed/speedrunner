package  
{
	import flash.geom.Point;
	import org.flixel.*;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
		
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class PlayState extends FlxState
	{
		[Embed(source = "../data/temp/map_long.txt", mimeType = "application/octet-stream")] private var TxtMap:Class;
		[Embed(source = "../data/temp/tiles_new_small.png")] private var ImgTiles:Class;
		[Embed(source = "../data/temp/tile_slope_down.png")] private var SlopeTiles:Class;
		
		//[Embed(source = "../data/temp/MapCSV_SR_Playground_Collision.txt", mimeType = "application/octet-stream")] private var TxtMap:Class;		
		
		// FLAN CODE:
		private var _map:MapBase;
		
		//major game objects
		private var tilemap:FlxTilemap;		
		private var player:Player;
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
		
		private var playerLayer:BlurLayer;
		
		
		// temp slopes:
		private var slopes:Array;
		private var slopeDowns:Array;
		

		
		public function PlayState() 
		{
			super();
			
			obstacles = new Array();
			
			//create tilemap
			tilemap = new FlxTilemap();
			tilemap.loadMap(new TxtMap, ImgTiles, 16);
			tilemap.collideIndex = 3;			
			
			
			// FLAN CODE:
			//Create the map
			_map = new MapSR_Playground();
			//Add the background (a bit hacky but works)
			//var bgColorSprite:FlxSprite = new FlxSprite(null, 0, 0, false, false, FlxG.width, FlxG.height, _map.bgColor);
			//var bgColorSprite:FlxSprite = new FlxSprite();// null, 0, 0, false, false, FlxG.width, FlxG.height, _map.bgColor);
			//bgColorSprite.scrollFactor.x = 0;
			//bgColorSprite.scrollFactor.y = 0;
			//FlxG.state.add(bgColorSprite);

			//Add the layers to current the FlxState
			//FlxG.state.add(_map.layerCollision);
			//_map.addSpritesToLayerCollision(onAddSpriteCallback);
			//FlxG.state.add(_map.layerObstacles);
			//_map.addSpritesToLayerObstacles(onAddSpriteCallback);

			FlxG.followBounds(_map.boundsMinX, _map.boundsMinY, _map.boundsMaxX, _map.boundsMaxY);
			
						
			//create player and hooks array
			
			playerLayer = new BlurLayer();
			
			this.add(playerLayer);
			
			
				
			player = new Player(150, 300);// , hooks);	
			player.playState = this;
			
			
			hooks = new Array();
			for(var i:uint = 0; i < 1; i++)
				hooks.push(this.add(new Hook(player)));	
				
			player.setHooks(hooks);
				
				
			//add player and set up camera
			
			
			
			
			//this.add(player);
			FlxG.follow(player,1.5);
			FlxG.followAdjust(1.0,0.25);
			
			tilemap.follow();	//Set the followBounds to the map dimensions
			//_map.layerCollision.follow();	//Set the followBounds to the map dimensions
			
			
			playerLayer.add(player);
			
			
			
			
			//add tilemap last so it is in front, looks neat
			this.add(tilemap);
			//this.add(_map.layerCollision);
			
			timerTxt = new FlxText(300, 100, 100, "Timer");
			timerTxt.scrollFactor = new Point(0, 0);	
			timerTxt.size = 10;			
			this.add(timerTxt);
			
			debugTxt = new FlxText(300, 150, 100, "Debug");
			debugTxt.scrollFactor = new Point(0, 0);	
			debugTxt.size = 10;			
			this.add(debugTxt);
			
			// Add Start and Finish:
			playTime = 0;
			
			start = new StartTrigger(200, 370);
			finish = new FinishTrigger(2400, 370);
			this.add(start);
			this.add(finish);
			
			// Test obstacle:
			var obj:Obstacle = new Obstacle(1148, 550);
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			this.add(obj);
			obstacles.push(obj);
			
			//fade in
			FlxG.flash(0xff131c1b);
			
			
			
			
			
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
			
			/*
			slopeDowns.push(this.add(new SlopeDown(480, 384)));
			slopeDowns.push(this.add(new SlopeDown(480, 384)));
			slopeDowns.push(this.add(new SlopeDown(480, 384)));
			slopeDowns.push(this.add(new SlopeDown(480, 384)));
			slopeDowns.push(this.add(new SlopeDown(480, 384)));
			slopeDowns.push(this.add(new SlopeDown(480, 384)));
			slpeDowns.push(this.add(new SlopeDown(480, 384)));
			*/
			
			
			
			//Add your blocks
			slopes = new Array();
			
			//slopes.push(this.add(new SlopeBlock(480, 384, 656, 566, 16, SlopeTiles) ) );
			
			
			//slopes.push(this.add(new SlopeBlock(220, 300, 420, 232, 32, ImgTiles) ) );	
			//slopes.push(this.add(new SlopeBlock(420, 2032, 520, 2090, 32, ImgTiles) ) );
			
			

		}
		/*
		public function slopeColl(Core:FlxCore,X:uint,Y:uint,Tile:uint):void
		{
			FlxG.log("slopeColl...");
			FlxG.log("Core: " + Core);
			FlxG.log("X: " + X);
			FlxG.log("Y: " + Y);			
			FlxG.log("Tile: "+Tile);
			
			
		}*/
		
		public function resetGame():void
		{
			player.x = 150;
			player.y = 300;
			
			player.velocity = new Point(0, 0);
			player.acceleration.x = 0;
			playTime = 0;
			bIsTimer = false;
			
		}

		override public function update():void
		{
			debugTxt.text = "" + player.bOnDownSlope;// "Velocity.x: " + player.velocity.x;
			super.update();	
			
			if ( !tracker )
				tracker = new GATracker(this, "UA-12125437-1", "AS3", false );
			
			if ( FlxG.keys.justPressed("ESC") )
			{
				resetGame();				
			}
			
			if( bIsTimer )
				playTime += FlxG.elapsed;
			timerTxt.text = "Timer: " + playTime.toFixed(2);
			
			
			
			
			// Collision tests:
			tilemap.collide(player);
			SlopeBlock.collideSlopeArray(slopes, player);
			//_map.layerCollision.collide(player);
			
			FlxG.collideArray(obstacles, player);
			
			if ( hooks[player.prevHook].exists )
			{
				tilemap.collide(hooks[player.prevHook]);
				//_map.layerCollision.collide(hooks[player.prevHook]);			
			}
			
			start.collide(player);
			finish.collide(player);
			
			
			FlxG.overlapArray(slopeDowns, player, player.hitSlope);
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
	}

}