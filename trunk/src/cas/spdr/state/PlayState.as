package cas.spdr.state
{
	import cas.spdr.actor.*;	
	import cas.spdr.gfx.sprite.*;
	import cas.spdr.map.MapBase;
	import FGL.GameTracker.GameTracker;
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.fefranca.FlxGradientBackground;
	import cas.spdr.gfx.GraphicsLibrary;
	import SWFStats.Log;
	//import SWFStatsTest.Log;
		
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
		
	/**
	 * The Base PlayState, featuring a character that walks around in an environment. Can be used for a level, or for the main menu
	 * @author Casper van Est
	 */
	public class PlayState extends FlxState
	{		
		// FLAN CODE:
		public var flanmap:MapBase;
		
		//major game objects
		//public var tilemap:FlxTilemap;		
		//private var bgmap:FlxTilemap;
		//private var fgmap:FlxTilemap;
		
		public var player:Player;
		public var hooks:Array;	
		
		private var obstacles:Array;
		private var boosts:Array;
		protected var pickups:Array;
		private var triggers:Array;
		private var fallTiles:Array;
		public var fallBlocks:Array;
		protected var gates:Array;
		private var slopeDowns:Array;
		private var slopeUps:Array;
		private var movingBlocks:Array;
		private var doors:Array;
		private var start:StartTrigger;
		private var finish:FinishTrigger;
		
		protected var debugTxt:FlxText;

		// Google Analytics:
		private var tracker:GATracker;
		
		private var bgSpr:FlxGradientBackground;
		private var bgSpr2:FlxSprite;
		private var bgSpr3:FlxSprite;
		
		protected var playerStartX:Number = 100;
		protected var playerStartY:Number = 100;		
			
		// HUD:
		private var speedometerBG:FlxSprite;
		private var speedometerBG2:FlxSprite;
		private var speedometer:FlxSprite;
		
		// SWFStats logging:
		public var bPerformSWFLogging:Boolean = false;		// this variable is also present in Preloader.as!!
		public var fglTracker:GameTracker;
		
		protected var bIsPaused:Boolean;
		
		public function PlayState() 
		{
			super();			
			
			bgColor = 0xFF7678CB;
			
			initLevel();
						
			//fade in
			FlxG.flash(0xff000000);					
		}	
		
		virtual public function initLevel():void
		{			
			// DEFINE ARRAYS:
			slopeDowns = new Array();
			slopeUps = new Array();	
			pickups = new Array();
			hooks = new Array();
			obstacles = new Array();	
			boosts = new Array();
			triggers = new Array();
			fallTiles = new Array();
			fallBlocks = new Array();
			gates = new Array();
			doors = new Array();
			movingBlocks = new Array();
			
			addBackGround();
			addBGLayer();
			addMainLayer();			
			addGameElements();
			addFGLayer();
			addHUDElements();
			
			if ( FlxG.level != 4 )
			{			
				FlxG.cameraOffset = new Point(0, 75);
				FlxG.follow(player, 1.5);
				FlxG.followAdjust(1.0, 0.25);	
				flanmap.layerMain.follow();
			}
		}
		
		public function addBackGround():void
		{	
			if( Math.random() > 0.5 )
				bgSpr = new FlxGradientBackground(0, 0, 800, 600, 0xFF7678CB, 0xFF2222BB);	// blueish..
			else 			
				bgSpr = new FlxGradientBackground(0, 0, 800, 600, 0xFFA75452, 0xFF661111);		// reddish..	
			
			bgSpr2 = new FlxSprite(-500, 0, GraphicsLibrary.Instance.GetImage(GraphicsLibrary.IMAGE_BACKGROUND));
			bgSpr2.scrollFactor = new Point(0.2, 0.1);
			bgSpr2.width = 5000;
			bgSpr2.height = 1000;
			
			var yval:int;
			if ( FlxG.level == 8 )
				yval = 1650;
			else
				yval = 0;
				
			bgSpr3 = new FlxSprite(0, yval, GraphicsLibrary.Instance.GetImage(GraphicsLibrary.IMAGE_BACKGROUND_2));
			bgSpr3.scrollFactor = new Point(0.5, 0.9);
			bgSpr3.width = 4000;
			bgSpr3.height = 2000;
			
			var bgSpr3b:FlxSprite = new FlxSprite(4000*0.5, yval, GraphicsLibrary.Instance.GetImage(GraphicsLibrary.IMAGE_BACKGROUND_2));
			bgSpr3b.scrollFactor = new Point(0.5, 0.9);
			bgSpr3b.width = 4000;
			bgSpr3b.height = 2000;
			
			//bgSpr2.alpha = 0.2;
			
			this.add(bgSpr);			
			this.add(bgSpr2);
			this.add(bgSpr3);
			this.add(bgSpr3b);
		}
		
		public function addBGLayer():void
		{			
			this.add(flanmap.layerBG);	
			flanmap.addSpritesToLayerMain(onAddSpriteCallback);
		}
		
		public function addMainLayer():void
		{			
			this.add(flanmap.layerMain);
				
		}
		
		virtual public function addGameElements():void
		{		
			// Triggers:
			//start = new StartTrigger(200, 370);
			//finish = new FinishTrigger(2400, 370);
			
			//this.add(start);
						
			// create player and hooks				
			player = new Player(playerStartX, playerStartY);
			player.addToState(this);
			
			for(var i:uint = 0; i < 1; i++)
				hooks.push(this.add(new Hook(player)));					
			player.setHooks(hooks);			
		}
		
		public function addFGLayer():void
		{			
			//this.add(flanmap.layerFG);			
		}
		
		virtual public function addHUDElements():void
		{	
			debugTxt = new FlxText(300, 150, 200, "");
			debugTxt.scrollFactor = new Point(0, 0);	
			debugTxt.size = 10;	
			
			this.add(debugTxt);
			
			// SPEEDOMETER:			
			/*
			speedometerBG = new FlxSprite(100, 550, null);
			speedometerBG.createGraphic(200, 25, 0xFFFFFFFF, false);
			speedometerBG.scrollFactor = new Point(0, 0);			
			this.add(speedometerBG);
			
			speedometerBG2 = new FlxSprite(100, 550, null);
			speedometerBG2.createGraphic(200, 25, 0xFF0000FF, false);
			speedometerBG2.scrollFactor = new Point(0, 0);			
			this.add(speedometerBG2);
			
			speedometer = new FlxSprite(100, 550, null);
			speedometer.createGraphic(200, 25, 0xFFFF0000, false);
			speedometer.scrollFactor = new Point(0, 0);			
			this.add(speedometer);
			*/
		}
		
		public function switchToLevel(levelId:uint):void
		{				
			FlxG.prevLevel = FlxG.level;
			FlxG.level = levelId;		
			
			FlxG.fade(0xFF000000, 1, startLoad);
			
			if ( bPerformSWFLogging )
			{
				if ( FlxG.prevLevel == FlxG.level )
					Log.LevelCounterMetric("Re-started", FlxG.level);
				else
					Log.LevelCounterMetric("Started", FlxG.level);
			}
			
			FlxG.fglTracker.beginLevel(FlxG.level, 0, "", "Started");
		}
		
		public function startLoad():void
		{
			FlxG.switchState(LoadingState );
			
		}

		// MAIN UPDATE FUNCTION:
		// 1. Update childs
		// 2. Run game state updates (timers, etc.)
		// 3. Perform collision checks		
		override public function update():void
		{
			if ( root != null )
			{				
				if ( root.loaderInfo.url.indexOf("flashgamelicense") < 0 && (root.loaderInfo.url.indexOf("file") < 0) 
					&& root.loaderInfo.url.indexOf("progamestudios") < 0 )
				{
					return;
					
				}
			}
			
			// First (and always, irregardless of pause), process input:			
			if ( FlxG.keys.justPressed("ESC") )
				switchToMainMenu();	
			
			// Don't perform collisions or updates when game is paused:
			if ( bIsPaused )
				return;
				
			// RUN UPDATE ON ALL CHILDS:	
			super.update();
			
			/*
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
			*/	
			
			// Google Analytics:			
			if ( !tracker )
				tracker = new GATracker(this, "UA-12125437-1", "AS3", false );			
			
			// COLLISION:			
			var playerCol:Boolean = false;
			//if ( tilemap.collide(player) )
			//	playerCol = true;
			if ( flanmap.mainLayer.collide(player) )
				playerCol = true;
			if ( FlxG.overlapArray(slopeDowns, player, player.hitSlope) )
				playerCol = true;
			if ( FlxG.overlapArray(slopeUps, player, player.hitSlope) )
				playerCol = true;
			
			if ( !playerCol )
				player.hitNothing();
			
			if( !player.isStumbling() )
				FlxG.collideArray(obstacles, player);
				
			FlxG.collideArray(pickups, player);
			FlxG.collideArray(doors, player);
			FlxG.collideArray(triggers, player);
			FlxG.collideArray(fallTiles, player);
			FlxG.collideArray(gates, player);
			FlxG.collideArray(boosts, player);
			FlxG.collideArray(movingBlocks, player);
			//start.collide(player);
			
			if ( finish != null ) 
			{
				finish.collide(player);
			}
			
			if ( start != null ) 
			{
				start.collide(player);
			}
			
			if ( hooks[player.prevHook].exists )
			{
				flanmap.mainLayer.collide(hooks[player.prevHook]);				
			}	
			
			// HUD:
			var maxSpeed:Number = Math.max( player.maxBoostVelocity, player.maxSwingVelocity );
			
			if ( speedometer )
			{
				speedometer.x = 0 + (100* (Math.abs( player.velocity.x ) / maxSpeed));
				speedometer.scale.x = (Math.abs( player.velocity.x ) / maxSpeed);
				
				speedometerBG2.x = 0 + (100* (Math.abs( player.maxVelocity.x ) / maxSpeed));
				speedometerBG2.scale.x = (Math.abs( player.maxVelocity.x ) / maxSpeed);
			}
			
			// For testing purposes:
			if ( FlxG.keys.justPressed("R") )
			{
				FlxG.progressManager.clearSaveData();
			}
			
			if ( FlxG.keys.justPressed("O") )
			{
				FlxG.switchState(OptionsMenuState);				
			}
		}
		
		public function switchToMainMenu():void 
		{
			FlxG.prevLevel = FlxG.level;
			FlxG.level = 0;
			FlxG.switchState(MainMenuState);	
			
			if ( bPerformSWFLogging )
			{
				Log.LevelCounterMetric("Exited", FlxG.prevLevel);
			}
			
			FlxG.fglTracker.endLevel(0, "", "Exited");
		}
		
		protected function onAddSpriteCallback(obj:FlxCore):void
		{			
			if ( obj is Obstacle )
			{
				obstacles.push(obj);				
			}
			
			//else if ( obj is Trigger )
			//{
			//	triggers.push(obj);				
			//}
			
			else if ( obj is SlopeDown )
			{
				slopeDowns.push(obj);				
			}
			
			else if ( obj is SlopeUp )
			{
				slopeUps.push(obj);				
			}
			
			else if ( obj is BoostSection )
			{
				boosts.push(obj);				
			}
			
			else if ( obj is Pickup )
			{
				pickups.push(obj);
				(obj as Pickup).SetColorAndValue();
			}
			
			else if ( obj is PlayerStart )
			{
				playerStartX = obj.x;
				playerStartY = obj.y + 10;	//hack, I know..
			}
			
			else if ( obj is Door )
			{
				doors.push(obj);				
			}
			
			else if (obj is FinishTrigger )
			{				
				finish = (obj as FinishTrigger);						
			}
			
			else if (obj is StartTrigger )
			{				
				start = (obj as StartTrigger);								
			}
			
			else if (obj is Trigger )
			{				
				triggers.push(obj);
			}
			
			
			else if (obj is MovingBlock )
			{				
				movingBlocks.push(obj);								
			}
			
			else if ( obj is FallTile )
			{
				fallTiles.push(obj);
			}
			
			else if ( obj is FallingBlock )
			{
				fallBlocks.push(obj);
				
			}
			
			else if ( obj is Gate )
			{
				gates.push(obj);
			}
			
			else
			{
				trace("Callback, trying to add object that isn't recognized.");
				
			}
		}	
		
		public function getPickupIndex(pickup:Pickup):int
		{
			return pickups.indexOf(pickup);
		}
	}
}
