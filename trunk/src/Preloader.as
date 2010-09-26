package
{
	import cas.spdr.gfx.GraphicsLibrary;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Preloader extends MovieClip 
	{
		
		[Embed(source = '/../data/font/tahoma.ttf', fontFamily = "Tahoma", fontWeight = "normal") ] private var FntTahoma:String;
		
		protected var _buffer:Sprite;
		protected var _text:TextField;
		
		protected var dispTxt:String;
		protected var tFmt:TextFormat;	
		
		protected var test:FlxSprite;
		
		public function Preloader() 
		{			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
						
			// background: 
			_buffer = new Sprite();
			_buffer.scaleX = 1;
			_buffer.scaleY = 1;
			addChild(_buffer);			
			_buffer.addChild(new Bitmap(new BitmapData(800, 600, false, 0x000000)));
			
			// textformat..
			tFmt = new TextFormat("Tahoma", 18, 0xFFFFFF,null,null,null,null,null,"center");
						
			// foreground:
			_text = new TextField();				
			_text.text = "Loading.. ";
			addChild(_text);			
			_text.defaultTextFormat = tFmt;
			_text.setTextFormat( tFmt );
			_text.embedFonts = true;
			_text.selectable = false;
			_text.border = false;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.multiline = true;
			_text.x = 200;
			_text.y = 200;
			_text.width = 400;
			_text.height = 300;		
			
			// test
			//test = new FlxSprite(400, 400, GraphicsLibrary.Instance.GetSprite( GraphicsLibrary.SPRITE_RYU ) );
			//addChild(test);
								
		}
		
		private function onLoading(e:ProgressEvent):void 
		{
			// update loader					
			_text.text = "Loading.. " + (( e.bytesLoaded / e.bytesTotal ) * 100).toFixed() + "%";
			_text.setTextFormat( tFmt );				
		}	
		
		private function onEnterFrame(e:Event):void 
		{			
			if ( framesLoaded >= totalFrames )
			{
				startGame();		
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);								
			}
		}		
		
		private function startGame():void 
		{			
			_text.text = "Complete.";						
			
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoading);
			var mainClass:Class = getDefinitionByName("cas.spdr.SpeedRunner") as Class;	
			
			removeChild(_text);
			addChild(new mainClass() as DisplayObject);			
			
		}
		
	}
	
}