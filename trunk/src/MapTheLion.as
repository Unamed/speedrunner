//Code generated by Flan. http://www.tbam.com.ar/utility--flan.php

package  {
	import org.flixel.*;
	
	public class MapTheLion extends MapBase {
		//Media content declarations
		[Embed(source="../data/maps/1.TheLion/MapCSV_TheLion_FG.txt", mimeType="application/octet-stream")] public var CSV_FG:Class;
		[Embed(source="../data/temp/tiles_foreground.png")] public var Img_FG:Class;
		[Embed(source="../data/maps/1.TheLion/MapCSV_TheLion_Main.txt", mimeType="application/octet-stream")] public var CSV_Main:Class;
		[Embed(source="../data/temp/tiles_black_32.png")] public var Img_Main:Class;
		[Embed(source="../data/maps/1.TheLion/MapCSV_TheLion_BG.txt", mimeType="application/octet-stream")] public var CSV_BG:Class;
		[Embed(source="../data/temp/tiles_background.png")] public var Img_BG:Class;

		
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
			
			layerMain = new FlxTilemap();
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
			boundsMaxY = 1600;
		}

		override public function addSpritesToLayerMain(onAddCallback:Function = null):void {
			var obj:FlxSprite;
			
			obj = new SlopeUp(640, 1120);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(656, 1104);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(672, 1088);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(688, 1072);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(2784, 1152);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(2800, 1136);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(2816, 1120);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(2832, 1104);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(2848, 1088);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(2864, 1072);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1968, 1072);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1984, 1088);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(2000, 1104);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(2016, 1120);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(2032, 1136);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(2048, 1152);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(304, 1072);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new PlayerStart(48, 1032);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Obstacle(2256, 1152);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Obstacle(2528, 1152);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new FinishTrigger(3056, 1048);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(592, 976);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(656, 976);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new StartTrigger(96, 1048);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(2112, 976);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(2144, 976);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new BoostSection(2256, 984);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(288, 1088);;
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
			obj = new Obstacle(1776, 1056);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(1456, 1152);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(1472, 1136);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(1488, 1120);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(1504, 1104);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(1520, 1088);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeUp(1536, 1072);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1104, 1072);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1120, 1088);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1136, 1104);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1152, 1120);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1168, 1136);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new SlopeDown(1184, 1152);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new BoostSection(1232, 1016);;
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
			obj = new Pickup(960, 1024);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Obstacle(960, 1056);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(1776, 912);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(1728, 912);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Pickup(1680, 912);;
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
