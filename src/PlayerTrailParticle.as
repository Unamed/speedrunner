package  
{
	import flash.geom.Point;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class PlayerTrailParticle extends FlxSprite
	{
		private var fadeSpeed:Number;
		
		public function PlayerTrailParticle(FadeSpeed:Number = 1.0, X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.alpha = 100;
			this.fadeSpeed = FadeSpeed;
			
		}
		
		
		
		override public function update():void
		{			
			this.alpha = Math.max(0, alpha - FlxG.elapsed * (Math.random() * fadeSpeed));
			
			//this.scale.x = Math.max( 0.1, scale.x - FlxG.elapsed * (Math.random() * fadeSpeed));
			this.scale.y = Math.max( 0.1, scale.y - FlxG.elapsed * (Math.random() * fadeSpeed));
			
			//this.scale.y = Math.max( 0.1, scale.y - FlxG.elapsed * (Math.random() * fadeSpeed));
			
			
			super.update();
			
		}
		
		override public function reset(X:Number,Y:Number):void
		{
			this.alpha = 100;
			this.scale = new Point(1, 1);
			super.reset(X, Y);
		}
	}

}