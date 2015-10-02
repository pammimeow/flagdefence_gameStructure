package com.csharks.juwalbose
{
	import flash.display.Sprite;
	import flash.geom.Point;

	public class IsoHelper
	{
		/**
		 * convert an isometric point to 2D
		 * */
		public static function isoToCart(pt:Point):Point{
			var x:Number=pt.x;
			var y:Number=pt.y;
			x=(2*pt.y+pt.x)/2;
			y=(2*pt.y-pt.x)/2;
			pt.x=x;
			pt.y=y;
			return(pt);
		}
		/**
		 * convert a 2d point to isometric
		 * */
		public static function cartToIso(pt:Point):Point{
			var x:Number=pt.x;
			var y:Number=pt.y;
			x=pt.x-pt.y;
			y=(pt.x+pt.y)/2;
			pt.x=x;
			pt.y=y;
			return(pt);
		}
		
		/**
		 * convert a 2d point to specific tile row/column
		 * */
		public static function getTileIndices(pt:Point, tileWidth:Number):Point{
			var x:Number=pt.x;
			var y:Number=pt.y;
			x=Math.floor(pt.x/tileWidth);
			y=Math.floor(pt.y/tileWidth);
			pt.x=x;
			pt.y=y;
			return(pt);
		}
		
		/**
		 * convert specific tile row/column to 2d point
		 * */
		public static function get2dFromTileIndices(pt:Point, tileWidth:Number):Point{
			var x:Number=pt.x;
			var y:Number=pt.y;
			x=pt.x*tileWidth;
			y=pt.y*tileWidth;
			pt.x=x;
			pt.y=y;
			return(pt);
		}
		/**
		 * creates an isometric grid with specified col,row,tile height and tile width
		 * */
		public static function createIsoGrid(cols:uint,rows:uint,tileWidth:Number,tileHeight:Number):Sprite{
			var tempSprite:Sprite=new Sprite();
			var d:Point=new Point(0,tileHeight*rows);
			var c:Point=new Point(tileWidth*cols,tileHeight*rows);
			var b:Point=new Point(tileWidth*cols,0);
			var a:Point=new Point(0,0);
			
			tempSprite.graphics.lineStyle(1,0x000000);
			var srcPt:Point=new Point(0,a.y);
			var destPt:Point=new Point(0,0);
			for(var i:uint=0;i<=cols;i++){
				srcPt.x=a.x+(i*tileWidth);
				srcPt.y=a.y;
				destPt.x=d.x+(i*tileWidth);
				destPt.y=d.y;
				srcPt=IsoHelper.cartToIso(srcPt);
				destPt=IsoHelper.cartToIso(destPt);
				tempSprite.graphics.moveTo(srcPt.x,srcPt.y);
				tempSprite.graphics.lineTo(destPt.x,destPt.y);
			}
			for(i=0;i<=rows;i++){
				srcPt.x=d.x;
				srcPt.y=a.y+(i*tileHeight);
				destPt.x=b.x;
				destPt.y=b.y+(i*tileHeight);;
				srcPt=IsoHelper.cartToIso(srcPt);
				destPt=IsoHelper.cartToIso(destPt);
				tempSprite.graphics.moveTo(srcPt.x,srcPt.y);
				tempSprite.graphics.lineTo(destPt.x,destPt.y);
			}
			a=IsoHelper.cartToIso(a);
			b=IsoHelper.cartToIso(b);
			c=IsoHelper.cartToIso(c);
			d=IsoHelper.cartToIso(d);
			tempSprite.graphics.beginFill(0xff0000);
			tempSprite.graphics.drawCircle(a.x,a.y,5);
			tempSprite.graphics.endFill();
			tempSprite.graphics.beginFill(0x00ff00);
			tempSprite.graphics.drawCircle(b.x,b.y,5);
			tempSprite.graphics.endFill();
			tempSprite.graphics.beginFill(0x0000ff);
			tempSprite.graphics.drawCircle(c.x,c.y,5);
			tempSprite.graphics.endFill();
			tempSprite.graphics.beginFill(0x00ffff);
			tempSprite.graphics.drawCircle(d.x,d.y,5);
			tempSprite.graphics.endFill();
			return(tempSprite);
		}
	}
}