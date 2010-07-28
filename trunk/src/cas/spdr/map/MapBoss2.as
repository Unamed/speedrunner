//Code generated by Flan. http://www.tbam.com.ar/utility--flan.php

package cas.spdr.map {
	import cas.spdr.gfx.sprite.BoostSection;
	import cas.spdr.gfx.sprite.FinishTrigger;
	import cas.spdr.gfx.sprite.Obstacle;
	import cas.spdr.gfx.sprite.Pickup;
	import cas.spdr.gfx.sprite.PlayerStart;
	
	import org.flixel.*;
	import org.flixel.fefranca.FlxTilemapSloped;
	
	public class MapBoss2 extends MapBase {
		//Media content declarations
		[Embed(source="../../../../data/maps/B2. Boss2/MapCSV_Boss2_FG.txt", mimeType="application/octet-stream")] public var CSV_FG:Class;
		[Embed(source="../../../../data/temp/tiles_foreground.png")] public var Img_FG:Class;
		[Embed(source="../../../../data/maps/B2. Boss2/MapCSV_Boss2_Main.txt", mimeType="application/octet-stream")] public var CSV_Main:Class;
		[Embed(source="../../../../data/temp/tiles_black_37.png")] public var Img_Main:Class;
		[Embed(source="../../../../data/maps/B2. Boss2/MapCSV_Boss2_BG.txt", mimeType="application/octet-stream")] public var CSV_BG:Class;
		[Embed(source="../../../../data/temp/tiles_background.png")] public var Img_BG:Class;

		
		public function MapBoss2() {

			_setCustomValues();

			bgColor = 0xff2e5392;

			layerFG = new FlxTilemap();			
			layerFG.loadMap(new CSV_FG, Img_FG, 16);
			layerFG.collideIndex = 31;
			layerFG.drawIndex = 1;
			layerFG.x = 0;
			layerFG.y = 0;
			layerFG.scrollFactor.x = 1.500000;
			layerFG.scrollFactor.y = 1.000000;
			
			layerMain = new FlxTilemapSloped();
			layerMain.loadMap(new CSV_Main, Img_Main, 16);
			layerMain.collideIndex = 31;
			layerMain.drawIndex = 1;
			layerMain.x = 0;
			layerMain.y = 0;
			layerMain.scrollFactor.x = 1.000000;
			layerMain.scrollFactor.y = 1.000000;
			
			layerBG = new FlxTilemap();
			layerBG.loadMap(new CSV_BG, Img_BG, 16);
			layerBG.collideIndex = 31;
			layerBG.drawIndex = 1;
			layerBG.x = 0;
			layerBG.y = 0;
			layerBG.scrollFactor.x = 0.500000;
			layerBG.scrollFactor.y = 1.000000;

			allLayers = [ layerFG, layerMain, layerBG ];

			mainLayer = layerMain;

			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 5200;
			boundsMaxY = 4800;
		}

		override public function addSpritesToLayerMain(onAddCallback:Function = null):void {
			var obj:FlxSprite;
			
			obj = new FinishTrigger(6136, 1016 -4);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(5232, 592);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["colorVal"] = "gold";
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(5296, 608);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["colorVal"] = "gold";
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new PlayerStart(712, 3912);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new FinishTrigger(2008, 1256 -4);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
		}

		override public function customFunction(param:* = null):* {

		}

		private function _setCustomValues():void {
		}

	}
}
