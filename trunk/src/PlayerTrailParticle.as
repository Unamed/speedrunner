package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class PlayerTrailParticle extends FlxSprite
	{
		
		public function PlayerTrailParticle(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.alpha = 100;
			
		}
		
		
		
		override public function update():void
		{
			this.alpha = Math.max(0, alpha - FlxG.elapsed*2.5);
			
			super.update();
			
		}
		
		override public function reset(X:Number,Y:Number):void
		{
			this.alpha = 100;
			super.reset(X, Y);
		}
	}

}