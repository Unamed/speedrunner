package  
{
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
		
		public function PlayState() 
		{
			super();
			
			//create tilemap
			tilemap = new FlxTilemap(new TxtMap,ImgTiles,16,3);
						
			//create player and hooks array
			hooks = new Array();
			for(var i:uint = 0; i < 1; i++)
				hooks.push(this.add(new Hook()));												
				
			player = new Player(tilemap.width / 2 - 4, tilemap.height / 2 - 4, hooks);			
			
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
			
			//fade in
			FlxG.flash(0xff131c1b);
		}

		override public function update():void
		{
			super.update();			
			tilemap.collide(player);
			
			if ( hooks[player.prevHook].exists )
			{
					tilemap.collide(hooks[player.prevHook]);
			
			}
		}		
	}

}