package cas.spdr.gfx 
{
	/**
	 * ...
	 * @author Gert-Jan Stolk
	 */
	public class GraphicsLibrary
	{
		//[Embed(source = "/../data/temp/tiles_new_small.png")] private var ImgTiles:Class;
		[Embed(source = "/../data/temp/tiles_black_32.png")] private var Black32Tiles:Class;//ImgTiles:Class; 
		[Embed(source="/../data/temp/tiles_background.png")] private var BgTiles:Class;
		[Embed(source="/../data/temp/tiles_foreground.png")] private var FgTiles:Class;
		[Embed(source = "/../data/temp/tiles_black_37.png")] public var Black37Tiles:Class;//Img_Main:Class;

		[Embed(source = "/../data/temp/bgIm.png")] private var bgIm:Class;
		
		[Embed(source = "/../data/temp/obstacle.png")] private var ObstacleIcon:Class;
		[Embed(source = "/../data/temp/lethal_obstacle.png")] private var LethalObstacleIcon:Class;
		[Embed(source = "/../data/temp/pickup_anim.png")] private var PickupIcon:Class;
		[Embed(source = "/../data/temp/pickup_Alt.png")] private var PickupAltIcon:Class;
		[Embed(source = "/../data/temp/BoostSection.png")] private var BoostImg:Class;
		[Embed(source = "/../data/temp/player.png")] private var ImgPlayer:Class;
		//[Embed(source="/../data/temp/ninjagaidentrilogy_ryuhayabusa_sheet.png")] private var ImgRyu:Class;
		[Embed(source = "/../data/temp/player_sheet_black2.png")] private var ImgRyu:Class;
		[Embed(source = "/../data/temp/door.png")] private var DoorIcon:Class;
		[Embed(source = "/../data/temp/tile_slope_up.png")] private var SlopeUpTile:Class;
		[Embed(source = "/../data/temp/tile_slope_down.png")] private var SlopeDownTile:Class;
		[Embed(source = "/../data/temp/hook_small.png")] private var ImgHook:Class;
		[Embed(source = "/../data/temp/messageDialog.png")] private var MessageDialog:Class;
		[Embed(source = "/../data/temp/startDialog.png")] private var MessageDialogStart:Class;
		[Embed(source = "/../data/temp/levelPopupDialog.png")] private var MessageDialogLevelInfo:Class;
		[Embed(source = "/../data/temp/finish.png")] private var Finish:Class;
		[Embed(source = "/../data/temp/useTrigger.png")] private var UseTrigger:Class;
		[Embed(source = "/../data/temp/deathWall.png")] private var deathWallIm:Class;
		
		public static const TILES_BACKGROUND:uint = 0;
		public static const TILES_FOREGROUND:uint = 1;
		public static const TILES_BLACK_32:uint = 2;
		public static const TILES_BLACK_37:uint = 3;
		
		public static const IMAGE_BACKGROUND:uint = 0;
		
		public static const SPRITE_OBSTACLE:uint = 0;
		public static const SPRITE_COIN_PICKUP:uint = 1;
		public static const SPRITE_BOOST:uint = 2;
		public static const SPRITE_PLAYER:uint = 3;
		public static const SPRITE_RYU:uint = 4;
		public static const SPRITE_DOOR:uint = 5;
		public static const SPRITE_SLOPE_UP:uint = 6;
		public static const SPRITE_SLOPE_DOWN:uint = 7;
		public static const SPRITE_HOOK:uint = 8;
		public static const SPRITE_COIN_PICKUP_ALT:uint = 9;
		public static const SPRITE_MESSAGE_DIALOG:uint = 10;
		public static const SPRITE_MESSAGE_DIALOG_START:uint = 11;
		public static const SPRITE_MESSAGE_DIALOG_LEVELINFO:uint = 12;		
		public static const SPRITE_FINISH:uint = 13;
		public static const SPRITE_USETRIGGER:uint = 14;
		public static const SPRITE_OBSTACLE_LETHAL:uint = 15;
		public static const SPRITE_DEATHWALL:uint = 15;
		
		private var tiles:Array = new Array();
		private var sprites:Array = new Array();
		private var images:Array = new Array();
		
		private static var instance:GraphicsLibrary = new GraphicsLibrary();
		
		public function GraphicsLibrary() 
		{
			tiles[TILES_BACKGROUND] = BgTiles;
			tiles[TILES_FOREGROUND] = FgTiles;
			tiles[TILES_BLACK_32] = Black32Tiles;
			tiles[TILES_BLACK_37] = Black37Tiles;
			
			images[IMAGE_BACKGROUND] = bgIm;
			
			sprites[SPRITE_OBSTACLE] = ObstacleIcon;
			sprites[SPRITE_COIN_PICKUP] = PickupIcon;			
			sprites[SPRITE_BOOST] = BoostImg;
			sprites[SPRITE_PLAYER] = ImgPlayer;
			sprites[SPRITE_RYU] = ImgRyu;
			sprites[SPRITE_DOOR] = DoorIcon;
			sprites[SPRITE_SLOPE_UP] = SlopeUpTile;
			sprites[SPRITE_SLOPE_DOWN] = SlopeDownTile;
			sprites[SPRITE_HOOK] = ImgHook;
			sprites[SPRITE_COIN_PICKUP_ALT] = PickupAltIcon;
			sprites[SPRITE_MESSAGE_DIALOG] = MessageDialog;
			sprites[SPRITE_MESSAGE_DIALOG_START] = MessageDialogStart;
			sprites[SPRITE_MESSAGE_DIALOG_LEVELINFO] = MessageDialogLevelInfo;
			sprites[SPRITE_FINISH] = Finish;
			sprites[SPRITE_USETRIGGER] = UseTrigger;
			sprites[SPRITE_OBSTACLE_LETHAL] = LethalObstacleIcon;
			sprites[SPRITE_DEATHWALL] = deathWallIm;
		}
		
		public static function get Instance():GraphicsLibrary
		{
			return instance;
		}
		
		public function GetTiles(id:uint):Class
		{
			return tiles[id];
		}
		
		public function GetImage(id:uint):Class
		{
			return images[id];
		}
		
		public function GetSprite(id:uint):Class
		{
			return sprites[id];
		}
	}
}