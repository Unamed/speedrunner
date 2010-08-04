package cas.spdr.gfx.sprite
{
	import cas.spdr.actor.FallingBlock;
	import cas.spdr.state.PlayState;
	import org.flixel.FlxSprite;
	import org.flixel.fefranca.debug.FlxSpriteDebug;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Trigger extends FlxSprite//Debug
	{	
		public var triggerId:int;
		
		public function Trigger(X:int=0,Y:int=0,SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			//loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_FINISH), false, false, 32, 64);
			this.visible = false;
			
			this.height = 64;
			this.width = 64;
			fixed = true;
		}	
		
		// triggers the Fall function of
		// all fallBlocks that have the same triggerId as I do.
		public function Triggered(state:PlayState):void
		{			
			var i:int;
			
			for ( i = 0; i < state.fallBlocks.length; i++ )
			{
				if ( FallingBlock(state.fallBlocks[i]).triggerId == this.triggerId )
					FallingBlock(state.fallBlocks[i]).Fall();						
			}			
			
		}
		
	}
}