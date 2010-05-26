package cas.spdr.gfx.sprite
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
		private var bScaleX:Boolean;
		
		public function PlayerTrailParticle(FadeSpeed:Number = 1.0, X:int = 0, Y:int = 0, SimpleGraphic:Class = null, bScaleX:Boolean = false) 
		{
			super(X, Y, SimpleGraphic);
			this.alpha = 100;
			this.fadeSpeed = FadeSpeed;
			this.bScaleX = bScaleX;
			
		}
		
		override public function update():void
		{			
			this.alpha = Math.max(0, alpha - FlxG.elapsed * (Math.random() * fadeSpeed));
			
			if( bScaleX )
				this.scale.x = Math.max( 0.1, scale.x - FlxG.elapsed * (Math.random() * fadeSpeed));
				
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