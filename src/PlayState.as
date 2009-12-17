package  
{
	import flash.geom.Point;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class PlayState extends FlxState
	{
		[Embed(source = "../data/temp/map_long.txt", mimeType = "application/octet-stream")] private var TxtMap:Class;
		[Embed(source = "../data/temp/tiles_new_small.png")] private var ImgTiles:Class;
		
		//major game objects
		private var tilemap:FlxTilemap;		
		private var player:Player;
		private var hooks:Array;
		
		private var timerTxt:FlxText;
		private var debugTxt:FlxText;
		private var playTime:Number;
		
		private var start:StartTrigger;
		private var finish:FinishTrigger;
		
		private var bIsTimer:Boolean;
		
		public function PlayState() 
		{
			super();
			
			//create tilemap
			tilemap = new FlxTilemap(new TxtMap,ImgTiles,16,3);
						
			//create player and hooks array
			hooks = new Array();
			for(var i:uint = 0; i < 1; i++)
				hooks.push(this.add(new Hook()));												
				
			player = new Player(150, 300, hooks);	
			player.playState = this;
			
			//add player and set up camera
			this.add(player);
			FlxG.follow(player,1.5);
			FlxG.followAdjust(0.5,0.25);
			tilemap.follow();	//Set the followBounds to the map dimensions
			
			//Uncomment these lines if you want to center TxtMap2
			//var fx:uint = _tilemap.width/2 - FlxG.width/2;
			//var fy:uint = _tilemap.height/2 - FlxG.height/2;
			//FlxG.followBounds(fx,fy,fx,fy);
			
			//add tilemap last so it is in front, looks neat
			this.add(tilemap);
			
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

		override public function update():void
		{
			super.update();	
			
			if ( FlxG.keys.justPressed("ESC") )
			{
				resetGame();				
			}
			
			if( bIsTimer )
				playTime += FlxG.elapsed;
			timerTxt.text = "Timer: " + playTime.toFixed(2);
			
			debugTxt.text = "";// "Velocity.x: " + player.velocity.x;
			
			
			// Collision tests:
			tilemap.collide(player);
			
			if ( hooks[player.prevHook].exists )
			{
				tilemap.collide(hooks[player.prevHook]);
			
			}
			
			start.collide(player);
			finish.collide(player);
		}	
		
		public function startTimer():void
		{
			playTime = 0;
			bIsTimer = true;
			
		}
		
		public function stopTimer():void
		{
			bIsTimer = false;
			
		}
	}

}