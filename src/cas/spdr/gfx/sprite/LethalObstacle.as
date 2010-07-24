package cas.spdr.gfx.sprite 
{
	import cas.spdr.gfx.sprite.Obstacle;
	import cas.spdr.gfx.GraphicsLibrary;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class LethalObstacle extends Obstacle
	{
		
		public function LethalObstacle(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			this.loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_OBSTACLE_LETHAL), false, false, 24, 24);
		}
		
	}

}