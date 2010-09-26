package cas.spdr.state 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import flash.geom.Point;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class StoryState extends FlxState
	{
		//[Embed(source = '/../data/font/tahoma.ttf', fontFamily = "Tahoma", fontWeight = "normal") ] private var FntTahoma:String;
		[Embed(source = '/../data/font/tahomabd.ttf', fontFamily = "Tahoma", fontWeight = "bold") ] private var FntTahomaBld:String;		
		
		private var image:FlxSprite;
		private var mTxt:FlxText;			
		private var sTxt:FlxText;
		
		//public var bAllowRestart:Boolean;
		
		public function StoryState() 
		{
			super();			
			
			bgColor = 0x000000;			
			
			//fade in
			FlxG.flash(0xff000000);
			
			mTxt = new FlxText(150, 40, 500, "");							
			mTxt.setFormat("Tahoma", 20, 0xFFFFFF, "center");
			this.add(mTxt);			
						
			sTxt = new FlxText(150, 390, 500, "");
			sTxt.setFormat("Tahoma", 16, 0xFFFFFF, "center");			
			this.add(sTxt);	
			
			var eTxt:FlxText = new FlxText(100, 525, 600, "-Press Enter to continue-");
			eTxt.setFormat("Tahoma", 12, 0xFFFFFF, "center");			
			this.add(eTxt);	

			
		}
		
		public function setImage(imageClass:Class):void
		{			
			image = new FlxSprite(100, 90, imageClass);			
			this.add(image);			
		}
		
		public function setText(text:String):void
		{			
			mTxt.text = text;	
		}
		
		public function setSupportText(text:String):void
		{			
			sTxt.text = text;	
		}
		
		/*
		public function setRestart(bAllow:Boolean):void
		{			
			bAllowRestart = bAllow;
			rTxt.visible = bAllowRestart;			
		}
		*/
		
		override public function update():void
		{
			super.update();
			
			// Various Input				
			if ( FlxG.keys.justPressed("ENTER") )
			{
				FlxG.switchState( MainMenuState );
			}
			
			/*
			if ( FlxG.keys.justPressed("BACKSPACE") && bAllowRestart)
			{
				FlxG.switchState( MainMenuState );
			}*/
		}
		
	}

}