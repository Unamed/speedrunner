package cas.spdr.layer
{
	//import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import org.flixel.FlxLayer;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class BlurLayer extends FlxLayer
	{
		// Blur:		
		private const _blur:Number =  0.35;
		private var _helper:FlxSprite;
			
		public function BlurLayer() 
		{
			super();
			
			_helper = new FlxSprite();
			_helper.createGraphic(FlxG.width,FlxG.height,0xff000000,true);
			//_helper.alpha = _blur;			
		}
		
		override public function render():void
		{	
			// fade the alpha of the helper buffer
			_helper.pixels.colorTransform(new Rectangle(0, 0, FlxG.width, FlxG.height), new ColorTransform(1, 1, 1, 0.50));
				
			// save FlxG.buffer
			var tmp:BitmapData = FlxG.buffer;

			// point FlxG.buffer at our helper sprite so everything on this layer gets drawn onto the BG sprite instead of FlxG.buffer
			FlxG.buffer = _helper.pixels;

			// Now draw to _helper
			super.render();
				
			// put the buffer back
			FlxG.buffer = tmp;
				
			// Now draw _helper onto the REAL buffer.
			FlxG.buffer.copyPixels(_helper.pixels, new Rectangle(0, 0, FlxG.width, FlxG.height), new Point(0, 0), null, null, true);		
		}		
	}
}