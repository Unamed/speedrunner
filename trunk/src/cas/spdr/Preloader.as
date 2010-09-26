package cas.spdr
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flixel.data.FlxFactory;
	import org.flixel.FlxPreloader;
	import org.flixel.FlxText;
	import SWFStats.Log;
	//import SWFStatsTest.Log;		// when using SWFStats-TEST-, comment out line 25: Log.Queue
	
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Preloader extends FlxPreloader//FlxFactory
	{
		private var bPerformSWFLogging:Boolean = false;		// this variable is also present in PlayState.as!!!
		
		private var lTxt:TextField;
		
		public function Preloader() 
		{			
			className = "cas.spdr.SpeedRunner";
			super();	
			
			if ( bPerformSWFLogging )
			{
				Log.View(153, "6635b062-cc5b-4c1b-819c-1f1b48b4ad75", root.loaderInfo.loaderURL);
				Log.Play();
				Log.Queue = false;
			}				
		}
		
		/*
		
		override protected function create(): void 
		{
			// The buffer, add every graphics on it.
			_buffer = new Sprite();					
			_buffer.width = stage.stageWidth;
			_buffer.height = stage.stageHeight;
			_buffer.scaleX = 2;
			_buffer.scaleY = 2;
			addChild(_buffer);
			
			// Background
			_width = stage.stageWidth/_buffer.scaleX;
			_height = stage.stageHeight/_buffer.scaleY;
			_buffer.addChild(new Bitmap(new BitmapData(_width, _height, false, 0x59003A)));
			
			// This shows the bar.
			_bmpBar = new Bitmap(new BitmapData(1,7,false,0xFFFFFF));
			_bmpBar.x = 4;
			_bmpBar.y = _height-11;
			_buffer.addChild(_bmpBar);
			
			// This displays the percentage that has been loaded.
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat("system",8,0xFFFFFF);
			_text.embedFonts = true;
			_text.selectable = false;
			_text.multiline = false;
			_text.x = 2;
			_text.y = _bmpBar.y - 11;
			_text.width = 80;
			_buffer.addChild(_text);
		}

		override protected function update(Percent: Number): void 
		{
			_bmpBar.scaleX = Percent*(_width-8);
			if(Percent >= 1)
			{
				_text.text = "Completed";
				_text.setTextFormat(_text.defaultTextFormat);
				return;
			}
			_text.text = "Loading: " + Math.floor(Percent*100)+"%";
			_text.setTextFormat(_text.defaultTextFormat);
		}
		*/
	}

}