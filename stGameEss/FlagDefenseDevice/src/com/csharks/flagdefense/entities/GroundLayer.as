package com.csharks.flagdefense.entities
{
	import com.csharks.flagdefense.helpers.LevelUtils;
	import com.csharks.juwalbose.helpers.IsoHelper;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.utils.AssetManager;
	
	public class GroundLayer
	{
		private var groundArray:Array;
		private var rows:uint;
		private var cols:uint;
		private var assetsManager:AssetManager;
		private var pt:Point=new Point();
		private var img:Image;
		private var tileWidth:Number;
		private var screenOffset:Point=new Point();
		private var str:String;
		public var glQb:QuadBatch;
		public function GroundLayer(width:int, height:int,_tileWidth:Number,_screenOffset:Point)
		{
			glQb=new QuadBatch();
			tileWidth=_tileWidth;
			screenOffset=_screenOffset;
			groundArray=LevelUtils.groundArray;
			rows=groundArray.length;
			cols=groundArray[0].length;
			assetsManager=ResourceManager.assets;
			img=new Image(assetsManager.getTexture("tile3"));
			drawGround(width,height);
		}
		private function drawGround(width:int, height:int):void{
			//fill whole screen with a ground tile
			var singleTileRect:Rectangle=new Rectangle(0,0,2*tileWidth,tileWidth);
			var i:uint=uint(rows/2);
			var j:uint=uint(cols/2);
			pt.x=j*tileWidth;
			pt.y=i*tileWidth;
			pt=IsoHelper.cartToIso(pt);
			singleTileRect.x=pt.x+screenOffset.x;
			singleTileRect.y=pt.y+screenOffset.y;
			glQb.reset();
			while(singleTileRect.x+singleTileRect.width>0){
				singleTileRect.x-=singleTileRect.width;
			}
			while(singleTileRect.y+singleTileRect.height>0){
				singleTileRect.y-=singleTileRect.height;
			}
			
			var visibleSpan:Point=new Point();
			var startPoint:Point=singleTileRect.topLeft.clone();
			while(singleTileRect.x<width){
				visibleSpan.x++;
				singleTileRect.x+=singleTileRect.width;
			}
			while(singleTileRect.y<height){
				visibleSpan.y++;
				singleTileRect.y+=singleTileRect.height;
			}
			var offset:Number;
			
			//let us first fill the whole screen with the base tile so that it fits in any screen
			for( i=0;i<visibleSpan.x;i++){
				for(j=0;j<2*visibleSpan.y;j++){
					if(j%2==0){
						offset=0;
					}else{
						offset=singleTileRect.width/2;
					}
					img.x=offset+startPoint.x+(i*singleTileRect.width);
					img.y=startPoint.y+(j*singleTileRect.height/2);
					glQb.addImage(img);
				}
			}
			//now draw level
			for(i=0;i<rows;i++){
				for(j=0;j<cols;j++){
					str=groundArray[i][j];
					img.texture=assetsManager.getTexture(str.split(".")[0]);
					pt.x=j*tileWidth;
					pt.y=i*tileWidth;
					pt=IsoHelper.cartToIso(pt);
					img.x=pt.x+screenOffset.x;
					img.y=pt.y+screenOffset.y;
					glQb.addImage(img);
				}
			}
			
			img=null;
		}
		public function dispose():void{
			glQb.reset();
			glQb.dispose();
		}
	}
}