package com.csharks.flagdefense
{
	import com.csharks.juwalbose.IsoHelper;
	import com.csharks.juwalbose.ResourceManager;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class GroundLayer extends RenderTexture
	{
		public var groundArray:Array=[["tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile6.png","tile6.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile6.png","tile2.png","tile2.png","tile6.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile3.png","tile3.png","tile5.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile1.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile1.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile1.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile6.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile3.png","tile3.png","tile3.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile6.png","tile2.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile5.png","tile3.png","tile5.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile6.png","tile2.png","tile5.png","tile2.png","tile6.png","tile6.png","tile6.png","tile6.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile3.png","tile3.png","tile3.png","tile6.png","tile5.png","tile2.png","tile6.png","tile4.png","tile4.png","tile6.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile2.png","tile3.png","tile3.png","tile2.png","tile5.png","tile2.png","tile6.png","tile4.png","tile4.png","tile6.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile2.png","tile2.png","tile2.png","tile6.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile2.png","tile2.png","tile2.png","tile6.png","tile4.png","tile4.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile6.png","tile5.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile2.png","tile2.png","tile2.png","tile6.png","tile4.png","tile4.png","tile6.png","tile3.png","tile3.png","tile3.png","tile2.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile5.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile2.png","tile2.png","tile2.png","tile6.png","tile5.png","tile5.png","tile6.png","tile6.png","tile3.png","tile3.png","tile2.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile2.png","tile6.png","tile6.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile2.png","tile2.png","tile6.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile5.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile5.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile1.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile1.png","tile3.png","tile2.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile2.png","tile2.png","tile2.png","tile3.png","tile1.png","tile3.png","tile2.png","tile2.png","tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile6.png","tile3.png","tile1.png","tile3.png","tile6.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile6.png","tile3.png","tile6.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile6.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile6.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"],["tile2.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png","tile3.png"]];
		public var rows:uint;
		public var cols:uint;
		private var assetsManager:AssetManager;
		private var pt:Point=new Point();
		private var img:Image;
		private var tileWidth:Number;
		private var screenOffset:Point=new Point();
		private var instance:GroundLayer = null;
		
		
		public function GroundLayer(width:int, height:int,_tileWidth:Number,_screenOffset:Point)
		{
			super(width, height, true);
			tileWidth=_tileWidth;
			screenOffset=_screenOffset;
			rows=groundArray.length;
			cols=groundArray[0].length;
			assetsManager=ResourceManager.assets;
		}
		public function drawGround():void{
			this.instance = this;
			this.drawBundled(function():void
			{
				for(var i:int=0;i<rows;i++){
					for(var j:int=0;j<cols;j++){
						img=new Image(assetsManager.getTexture(String(groundArray[i][j]).split(".")[0]));
						pt.x=j*tileWidth;
						pt.y=i*tileWidth;
						pt=IsoHelper.cartToIso(pt);
						img.x=pt.x+screenOffset.x;
						img.y=pt.y+screenOffset.y;
						instance.draw(img);
					}
				}
			});
		}
		public function paintGround(path:Array,tp:Point):void{
			this.instance = this;
			this.drawBundled(function():void
			{
				if(path.length==0){
					img=new Image(assetsManager.getTexture("selectioncircle"));
				}else{
					img=new Image(getRightArrow(path,tp));
				}
				pt.x=tp.x*tileWidth;
				pt.y=tp.y*tileWidth;
				pt=IsoHelper.cartToIso(pt);
				img.x=pt.x+screenOffset.x;
				img.y=pt.y+screenOffset.y;
				instance.draw(img);
				
			});
		}
		private function getRightArrow(path:Array,tp:Point):Texture{
			var newTp:Point=path[path.length-1] as Point;
			return(getDirectionalArrow(newTp,tp));
		}
		private function getDirectionalArrow(newTp:Point,tp:Point):Texture{
			var dir:String;
			if(Math.abs(newTp.x-tp.x)==0){
				if(newTp.y>tp.y){
					dir="up";
				}else if(newTp.y<tp.y){
					dir="down";
				}
			}else if(Math.abs(newTp.y-tp.y)==0){
				if(newTp.x>tp.x){
					dir="left";
				}else if(newTp.x<tp.x){
					dir="right";
				}
			}
			return assetsManager.getTexture("arrow"+dir);
		}
		public function repaintGround(path:Array,withPath:Boolean=false):void{
			if(path.length==0){
				return;
			}
			this.instance = this;
			this.drawBundled(function():void
			{
				for(var i:int=0;i<path.length;i++){
					if(withPath){
						if(i==0){
							img=new Image(assetsManager.getTexture("selectioncircle"));
						}else{
							img=new Image(getDirectionalArrow(path[i-1],path[i]));
						}
						
					}else{
						img=new Image(assetsManager.getTexture(String(groundArray[path[i].y][path[i].x]).split(".")[0]));
					}
					pt.x=path[i].x*tileWidth;
					pt.y=path[i].y*tileWidth;
					pt=IsoHelper.cartToIso(pt);
					img.x=pt.x+screenOffset.x;
					img.y=pt.y+screenOffset.y;
					instance.draw(img);
				}
			});
		}		
	}
}