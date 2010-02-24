package 
{
    import org.flixel.FlxCore;
    import org.flixel.FlxG;
    import org.flixel.FlxSprite;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import flash.display.Shape;

    public class Line extends FlxCore 
	{
		protected var drawShape:Shape;
		protected var player:Player;
		protected var hook:Hook;
		
		private var thickness:Number;
		private var color:uint;

        function Line(player:Player, hook:Hook, thickness:Number, color:uint) 
		{
			this.player = player;
			this.hook = hook;
			
			this.thickness = thickness;
			this.color = color;
        }

        override public function render():void 
		{
            drawShape = new Shape();
            drawShape.graphics.lineStyle(thickness, color);
			
			var xLoc:Number;
			var yLoc:Number;
			if ( hook.bCollided )
			{				
				if ( player.facing == FlxSprite.LEFT)
					xLoc = 1.25 * player.width;
				else
					xLoc = player.width / 2;
					
				yLoc = player.height / 2;
			}
			else
			{
				if ( player.facing == FlxSprite.LEFT)
					xLoc = 0.5 * player.width;
				else
					xLoc = 1.5 * player.width;
					
				yLoc = player.height / 8;
			}
            drawShape.graphics.moveTo(player.x + xLoc + FlxG.scroll.x, player.y + yLoc + FlxG.scroll.y);
            drawShape.graphics.lineTo(hook.x + hook.width/2 + FlxG.scroll.x, hook.y + 6 + FlxG.scroll.y);
            FlxG.buffer.draw(drawShape);
        }
    }
}