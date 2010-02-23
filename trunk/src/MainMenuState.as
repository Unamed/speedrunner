package  
{	
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
					var lTime:Number = FlxG.progressManager.getBestTime(new dMap());					
					
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
			
			var gTxt:FlxText = new FlxText(100, 1400, 500, 
				"Welcome to SpeedRunner Prototype v0.3" + "\n" + 
				"Controls: " + "\n" +
				"Z - jump" + "\n" +
				"X - shoot Grappling Hook (when unlocked)" + "\n" +
				"Arrow keys to move" + "\n" +
				"UP to enter door" + "\n" +
				"ESC to main menu" + "\n" +
				"SPACE to restart level" + "\n" +
				"Q to switch character (test)"
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