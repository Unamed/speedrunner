package cas.spdr.logic
{
	import org.flixel.FlxBlock;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Sprite;	
	import flash.events.*;

	//@desc		Wonky proof of concept for slopes in the framework...
	public class SlopeBlock extends FlxBlock
	{				
		private var _nRec:BitmapData;
		
		public function SlopeBlock(X1:int,Y1:int,X2:int,Y2:int,tHeight:uint,TileGraphic:Class)
		{
			this.scrollFactor = new Point(0, 0);
			x = X1;
			y = Y1;
			//Get the width
			//width = 100;
			if (X1 > X2)
			{
				width = X1 - X2;
				X1 = width;
				X2 = 0;
			}
			else
			{
				width = X2 - X1;
				X1 = 0;
				X2 = width;
			}
			
			//Get the height	
			if (Y1 > Y2)
			{
				y = Y2; //Make sure the block is drawn on the right side y since that is the high point
				height = Math.abs(Y1 - Y2) + tHeight;
				Y1 = Math.abs(Y1 - Y2);
				Y2 = 0;
			}
			else
			{
				height = Math.abs(Y2 - Y1) + tHeight;
				Y2 = Math.abs(Y1 - Y2);
				Y1 = 0;
			}	
			
			super(x, y, width, height);
			
			if(TileGraphic == null)
				return;
				
			_p = new Point()
			_pixels = FlxG.addBitmap(TileGraphic);
			_nRec = new BitmapData(width, height, true, 0x0);
			_nRec.draw(draw_poly(X1, Y1, X2, Y2, X2, Y2 + tHeight, X1, Y1 + tHeight, _pixels));
			
			_rects = new Array();
		}
		
		//@desc		Draws this block
		override public function render():void
		{
			super.render();
			getScreenXY(_p);
			//_p.x = x;
			//_p.y = y;
			FlxG.buffer.copyPixels(_nRec, new Rectangle(0,0,width,height), _p, null, null, true);
		}

		////////////////////
		//Draw the polygon
		////////////////////
		private function draw_poly(pX1:int, pY1:int, pX2:int, pY2:int, pX3:int, pY3:int, pX4:int, pY4:int,image:BitmapData ):Sprite
		{
			var the_square:Sprite = new Sprite();
			//this.addChild(the_square);
			//the_square.graphics.beginFill(0x0000FF);
			the_square.graphics.beginBitmapFill(image );
			the_square.graphics.moveTo(pX1,pY1);//Start of new line
			the_square.graphics.lineTo(pX2,pY2);//End of new line
			the_square.graphics.lineTo(pX3,pY3);//End of new line		
			the_square.graphics.lineTo(pX4,pY4);//End of new line		
			the_square.graphics.endFill();
			return the_square;
		}
		
		////////////////////
		//Collisions
		////////////////////
		public function prefectCollideSlope(Spr:FlxSprite):void
		{		
			//This function checks pixel perfect against the Sprite and the Block
			//I've opted to check by a point vs the entire sprite - should be a little quicker
			//The collisions work, but they need a LOT of work on the after effect on the sprite.
			
			var xcheck:Number = Spr.width * 0.5;
			var ycheck:Number = Spr.height + (0.5 * Spr.width);
			var xadder:Number = 0;
			var yadder:Number = -0.1;
			var col:Boolean = false;
			
			//Moving up away from collision
			if ( _nRec.hitTest(new Point(x,y),1,new Point(Spr.x + xcheck, Spr.y + ycheck)))						
			{
				Spr.y -= Spr.velocity.y * FlxG.elapsed;
				Spr.velocity.y = 0;
				col = true;
				while( _nRec.hitTest(new Point(x,y),1,new Point(Spr.x + xcheck, Spr.y + ycheck)))		
				{
					Spr.y += yadder;
					Spr.x += xadder;
					
					Spr.hitFloor(this);											
				}
			}
			
			//Moving down toward collision
			if ( col == false && Spr.velocity.y > 0) //Don't do this if collisions have been handled
			{
				//Decrease the ii_increment to have the object check in smaller steps - small = slower
				var ii_increment:Number = 0.2;
				//How far down the slope to check - bigger = slower
				var ii_how_far:Number = 2;
				for (var ii:Number = 0; ii < ii_how_far; ii += ii_increment)
				{
					if (_nRec.hitTest(new Point(x,y),1,new Point(Spr.x + xcheck, Spr.y + ycheck + ii)))				
					{
						Spr.y += ii - ii_increment; //Ok, collision now go back one increment and hope for the best
						Spr.velocity.y = 0;
						ii = 9999;
						
						Spr.hitFloor(this);
					}
				}
			}
		} 
		
		static public function collideSlopeArray(Blocks:Array,Sprite:FlxSprite):void
		{
			if ((Sprite == null) || !Sprite.exists || Sprite.dead) 
				return;
				
			for(var i:uint = 0; i < Blocks.length; i++)
				Blocks[i].prefectCollideSlope(Sprite);
		}
	}
}