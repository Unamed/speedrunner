package cas.spdr.state
{	
	import cas.spdr.gfx.sprite.Door;
	import cas.spdr.map.MapMainMenu;
	import org.flixel.*;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class MainMenuState extends PlayState
	{		
		public function MainMenuState() 
		{
			flanmap = new MapMainMenu();	
			super();
			
			for ( var i:uint = 0; i < this._layer.children().length; i++ )
			{
				if ( this._layer.children()[i] is Door )
				{
					var door:Door = ( this._layer.children()[i] as Door );					
					var dMap:Class = FlxG.levels[door.levelId];					
					//var lTime:Number = FlxG.progressManager.getBestTime(new dMap());					
					var lTime:Number = FlxG.progressManager.getBestTime(door.levelId);					
					
					var tTxt:FlxText = new FlxText(door.x - 10, door.y - 20, 100, "Best: " + lTime.toFixed(2));
					tTxt.size = 12;							
					tTxt.scrollFactor = new Point(1, 1);				
					this.add(tTxt);						
				}
			}
		}
		
		override public function addHUDElements():void
		{		
			super.addHUDElements();
			
			var gTxt:FlxText = new FlxText(30, 1370, 500, 
				"Welcome to FlowRunner Prototype v0.4" + "\n \n" + 
				"Controls: " + "\n" +
				"LEFT, RIGHT to move" + "\n" +
				"Z - (Double) Jump (when unlocked)" + "\n" +
				"X - Shoot Grappling Hook (when unlocked)" + "\n" +
				"DOWN - Slide (when unlocked)" + "\n" +				
				"UP to enter door" + "\n" +
				"ESC to main menu" + "\n" +
				"SPACE to restart level" + "\n \n" +
				"caspervanest [at] gmail [dot] com"
				);			
			gTxt.size = 12;							
			gTxt.scrollFactor = new Point(1, 1);				
			this.add(gTxt);	
		}
		
		override public function addGameElements():void
		{	
			// re-define playerStart, if coming from a level:
			if ( FlxG.level > 0 )
			{
				for ( var i:uint = 0; i < this._layer.children().length; i++ )
				{
					if ( this._layer.children()[i] is Door )
					{
						var door:Door = ( this._layer.children()[i] as Door );	
						
						if ( door.levelId == FlxG.level )
						{
							// this is the door next to which the player should start
							playerStartX = door.x;
							playerStartY = door.y;							
						}						
					}
				}				
			}
			
			super.addGameElements();
		}
	}
}