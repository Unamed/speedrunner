package 
{
    import org.flixel.FlxCore;
    import org.flixel.FlxG;
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
            drawShape.graphics.moveTo(player.x + player.width/2 + FlxG.scroll.x, player.y + player.height/2 + FlxG.scroll.y);
            drawShape.graphics.lineTo(hook.x + hook.width/2 + FlxG.scroll.x, hook.y + hook.height/2 + FlxG.scroll.y);
            FlxG.buffer.draw(drawShape);
        }
    }
}