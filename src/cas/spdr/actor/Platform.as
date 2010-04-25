package cas.spdr.actor 
{
	import org.flixel.FlxBlock;
	import org.flixel.FlxG;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class Platform extends FlxBlock
	{	
		private var grassStartIndeces:Array;
		private var grassEndIndeces:Array;		
		private var grassIndeces:Array;
		
		private var solidTileIndeces:Array;
		private var magnetIndex:int;
		private var slopeStartIndeces:Array;
		private var slopeEndIndeces:Array;
		
		public function Platform(X:int, Y:int, Width:uint, Height:uint) 
		{
			super(X, Y, Width, Height);
			setIndices();			
		}
		
		private function setIndices():void
		{
			grassStartIndeces = new Array();
			grassEndIndeces = new Array();
			grassIndeces = new Array();			
			solidTileIndeces = new Array();			
			slopeStartIndeces = new Array();
			slopeEndIndeces = new Array();
			
			grassStartIndeces.push(1);
			grassStartIndeces.push(3);
			
			grassEndIndeces.push(2);
			grassEndIndeces.push(4);
			
			grassIndeces.push(5);
			grassIndeces.push(6);
			grassIndeces.push(7);
			grassIndeces.push(8);
			grassIndeces.push(9);
			grassIndeces.push(10);
			grassIndeces.push(11);
			grassIndeces.push(12);
			grassIndeces.push(13);
			grassIndeces.push(14);
			grassIndeces.push(15);
			//grassIndeces.push(16);
			//grassIndeces.push(17);
			
			solidTileIndeces.push(31);
			
			slopeStartIndeces.push(26);
			slopeEndIndeces.push(27);
			
			magnetIndex = 35;
			
		}
		
		/**
		 * Fills the block with a purposely arranged selection of graphics from the image provided.
		 * 
		 * @param	TileGraphic The graphic class that contains the tiles that should fill this block.
		 * The TileGraphic needs to have .. 
		 
		 */
		override public function loadGraphic(TileGraphic:Class,Empties:uint=0):void
		{	
			if(TileGraphic == null)
				return;

			_pixels = FlxG.addBitmap(TileGraphic);			
			_rects = new Array();
			_p = new Point();			
			_tileSize = _pixels.height;						
			var widthInTiles:uint = Math.ceil(width/_tileSize);
			var heightInTiles:uint = Math.ceil(height / _tileSize);			
			width = widthInTiles*_tileSize;
			height = heightInTiles*_tileSize;
			
			var numTiles:uint = widthInTiles*heightInTiles;
			var numGraphics:uint = _pixels.width / _tileSize;
			
			// add Rectangles to _rects, 
			// detailing the tiles used
			// from top left to bottom right
			/*
			// top left is always a "grass start" tile:
			var grassStartIndex:int = Math.floor( Math.random() * grassStartIndeces.length );
			_rects.push( new Rectangle( _tileSize * grassStartIndeces[grassStartIndex], 0, _tileSize, _tileSize) );
			
			// then, up until the "grass end", we have regular grass sections:
			for (var i:uint = 1; i < widthInTiles-1; i++)
			{
				var grassIndex:int = Math.floor( Math.random() * grassIndeces.length );
				_rects.push( new Rectangle( _tileSize * grassIndeces[grassIndex], 0, _tileSize, _tileSize) );				
			}
			
			// then, we have a "grass end" tile:
			var grassEndIndex:int = Math.floor( Math.random() * grassEndIndeces.length );
			_rects.push( new Rectangle( _tileSize * grassEndIndeces[grassEndIndex], 0, _tileSize, _tileSize) );
			*/
			
			// then, the next rows, until the bottom row, are solid tiles:
			var numSolidTiles:uint = widthInTiles * (heightInTiles - 1);
			for (var j:uint = 0; j < numSolidTiles; j++)
			{		
				var solidTileIndex:int = Math.floor( Math.random() * solidTileIndeces.length );
				_rects.push( new Rectangle( _tileSize * solidTileIndeces[solidTileIndex], 0, _tileSize, _tileSize) );				
			}
			
			// finally, the bottom row starts with a sloped tile:
			var slopeStartIndex:int = Math.floor( Math.random() * slopeStartIndeces.length );
			_rects.push( new Rectangle( _tileSize * slopeStartIndeces[slopeStartIndex], 0, _tileSize, _tileSize) );
			
			// then, a row of magnetable tiles:
			for (var k:uint = 1; k < widthInTiles-1; k++)
			{				
				_rects.push( new Rectangle( _tileSize * magnetIndex, 0, _tileSize, _tileSize) );				
			}
			
			// and last, another sloped tile:
			var slopeEndIndex:int = Math.floor( Math.random() * slopeEndIndeces.length );
			_rects.push( new Rectangle( _tileSize * slopeEndIndeces[slopeEndIndex], 0, _tileSize, _tileSize) );					
		}		
	}
}