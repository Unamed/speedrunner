//Code generated by Flan. http://www.tbam.com.ar/utility--flan.php

package cas.spdr.map {
	import cas.spdr.actor.FallTile;
	import cas.spdr.gfx.sprite.BoostSection;
	import cas.spdr.gfx.sprite.Door;
	import cas.spdr.gfx.sprite.PlayerStart;
	import cas.spdr.gfx.sprite.Trigger;
	import cas.spdr.gfx.sprite.UseTrigger;
	import cas.spdr.actor.FallingBlock;
	
	import org.flixel.*;
	import org.flixel.fefranca.FlxTilemapSloped;
	
	public class MapMainMenu extends MapBase {
		//Media content declarations
		[Embed(source="../../../../data/maps/MainMenu/MapCSV_MainMenu_FG.txt", mimeType="application/octet-stream")] public var CSV_FG:Class;
		[Embed(source="../../../../data/temp/tiles_foreground.png")] public var Img_FG:Class;
		[Embed(source="../../../../data/maps/MainMenu/MapCSV_MainMenu_Main.txt", mimeType="application/octet-stream")] public var CSV_Main:Class;
		[Embed(source="../../../../data/temp/tiles_black_37.png")] public var Img_Main:Class;
		[Embed(source="../../../../data/maps/MainMenu/MapCSV_MainMenu_BG.txt", mimeType="application/octet-stream")] public var CSV_BG:Class;
		[Embed(source="../../../../data/temp/tiles_background.png")] public var Img_BG:Class;

		
		public function MapMainMenu() {

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
			boundsMaxX = 5600;
			boundsMaxY = 1600;
		}

		override public function addSpritesToLayerMain(onAddCallback:Function = null):void {
			var obj:FlxSprite;
			
			obj = new Door(2280, 1288+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 1;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Door(2840, 1272+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 2;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Door(3000, 1272+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 3;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Door(3048, 952+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 4;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Door(3288, 904+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 5;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Door(3304, 1400+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 6;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new PlayerStart(2008, 1304);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Door(4728, 1032+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 8;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Door(3432, 1160+8);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["levelId"] = 7;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new BoostSection(3528, 1183);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new UseTrigger(1144, 1464);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["effect"] = "Hook";
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new UseTrigger(984, 1464);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["effect"] = "Wall";
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new UseTrigger(824, 1464);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["effect"] = "Slide";
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new UseTrigger(664, 1464);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["effect"] = "DoubleJump";
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new UseTrigger(440, 1464);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			obj["effect"] = "Reverse";
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
