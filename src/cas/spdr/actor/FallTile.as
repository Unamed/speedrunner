package cas.spdr.actor 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.flixel.FlxSprite;
	import cas.spdr.gfx.GraphicsLibrary;
	import flash.geom.Point;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FallTile extends FlxSprite
	{
		private var bHit:Boolean;
		private var rotDir:Number;
		
		public function FallTile(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);			
			this.loadGraphic(GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_FALLTILE), true, false, 32, 32);
			
			this.offset.x = 0;
			this.offset.y = 0;
			
			this.width = 32;
			this.height = 32;
			
			this.fixed = true;	
			
			this.addAnimation("fall", [0, 1, 2, 3, 4, 5, 6, 7], 12, false);
			
			//this.randomFrame();
		//	this._curFrame = Math.floor( Math.random() * 4 );
		}
		
		public function onHit( playerVelocity:Point ):void
		{
			var tim:Timer = new Timer(60 + Math.random()*50, 1);	//0.1s
			tim.addEventListener(TimerEvent.TIMER, onTimerComplete);
			tim.start();
			
			play("fall");
			
		}
		
		public function onTimerComplete(evt:Event):void
		{
			acceleration.y = 700;			
			rotDir = (Math.random() * 60) - 30;
			
			bHit = true;
			dead = true;
		}
		
		override public function update():void
		{
			super.update();
			
			if ( bHit )
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