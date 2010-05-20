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
			
			// Display best results over each level door
			for ( var i:uint = 0; i < this._layer.children().length; i++ )
			{
				if ( this._layer.children()[i] is Door )
				{
					var door:Door = ( this._layer.children()[i] as Door );	
					var bestResult:String = FlxG.progressManager.getBestResult(door.levelId);					
					
					var tTxt:FlxText = new FlxText(door.x - 10, door.y - 20, 100, "Lvl"+door.levelId+": " + bestResult);
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
				"Welcome to SpeedRunner Prototype v0.5" + "\n \n" + 
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
			
			var cTxt:FlxText = new FlxText(30, 170, 500, "Currency: " + FlxG.progressManager.getCredits());				
			cTxt.size = 12;							
			cTxt.scrollFactor = new Point(0, 0);				
			this.add(cTxt);	
			
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