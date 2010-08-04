package cas.spdr.actor 
{	
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FallingBlock extends FlxSprite
	{	
		public var bFalling:Boolean;
		public var triggerId:int;
		private var rotDir:Number;
		
		public function FallingBlock(X:int=0,Y:int=0,SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			
			loadGraphic( GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_FALLBLOCK), false, false, 128, 32, false);
			
			width = 128;
			height = 32;
		}
		
		public function Fall():void
		{
			if ( !bFalling )
			{
				bFalling = true;
				FlxG.quake(0.004, 0.75);
				this.acceleration.y = 700;
				rotDir = (Math.random() * 40) - 20;
				
			}		
			
		}
		
		override public function update():void
		{
			
			super.update();
			
			if ( bFalling )
			{
				angle += rotDir * FlxG.elapsed;		
				alpha -= 0.25 * FlxG.elapsed; 
				
				if ( alpha <= 0 )
				{
					this.visible = false;
					this.active = false;
					this.dead = true;
					
				}
			}
		}
		
	}

}