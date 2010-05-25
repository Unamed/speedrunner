//Code generated by Flan. http://www.tbam.com.ar/utility--flan.php

package cas.spdr.map {
	import cas.spdr.gfx.sprite.BoostSection;
	import cas.spdr.gfx.sprite.FinishTrigger;
	import cas.spdr.gfx.sprite.Obstacle;
	import cas.spdr.gfx.sprite.Pickup;
	import cas.spdr.gfx.sprite.PlayerStart;
	
	import org.flixel.*;
	import org.flixel.fefranca.FlxTilemapSloped;
	
	public class MapTheLion extends MapBase {
		//Media content declarations
		[Embed(source="../../../../data/maps/1.TheLion/MapCSV_TheLion_FG.txt", mimeType="application/octet-stream")] public var CSV_FG:Class;
		[Embed(source="../../../../data/temp/tiles_foreground.png")] public var Img_FG:Class;
		[Embed(source="../../../../data/maps/1.TheLion/MapCSV_TheLion_Main.txt", mimeType="application/octet-stream")] public var CSV_Main:Class;
		[Embed(source="../../../../data/temp/tiles_black_37.png")] public var Img_Main:Class;
		[Embed(source="../../../../data/maps/1.TheLion/MapCSV_TheLion_BG.txt", mimeType="application/octet-stream")] public var CSV_BG:Class;
		[Embed(source="../../../../data/temp/tiles_background.png")] public var Img_BG:Class;

		
		public function MapTheLion() {

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
			boundsMaxX = 6400;
			boundsMaxY = 1600;
		}

		override public function addSpritesToLayerMain(onAddCallback:Function = null):void {
			var obj:FlxSprite;
			
			obj = new Pickup(592, 976);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(272, 1040);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(560, 992);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(624, 976);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Obstacle(2816, 1056);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Obstacle(2352, 1056);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Obstacle(1088, 1056);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(656, 992);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(1088, 1024);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(1520, 992);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(1552, 992);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(1584, 992);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(4096, 1040);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(4064, 1040);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(4032, 1040);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(4304, 960);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(4336, 960);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(4960, 896);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(4992, 896);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(5024, 896);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new BoostSection(5480, 943-1);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new BoostSection(3320, 1023-1);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new PlayerStart(72, 1000);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new FinishTrigger(6136, 1016 -4);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(2304, 896);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(2352, 896);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(2400, 896);;
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
