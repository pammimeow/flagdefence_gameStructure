package com.csharks.juwalbose
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class IsometricLevel extends DisplayObjectContainer
	{
		[Embed(source="../../../../assets/assets.png")]
		public static const AssetTex:Class;
		
		[Embed(source = "../../../../assets/assets.xml", mimeType = "application/octet-stream")]
		private static const AssetXml:Class;
		
		private var texAtlas:TextureAtlas;
		private var tileWidth:uint=50;
		private var borderX:uint=25;
		private var borderY:uint=50;
		private var touch:Touch;
		private var rTex:RenderTexture;
		
		private var levelData:Array=
			[["14","21","21","21","21","21","21","13","21","21","21","21","21","21","17"],
				["18","12","7","2","2","8","2","3","2","5","2","2","7","13","20"],
				["18","3","3","2","2","2","2","2","2","2","2","2","3","2","20"],
				["18","3","3","2","2","2","9","2","2","2","3","2","3","3","20"],
				["18","5","2","2","5","2","2","2","4","2","2","2","2","5","20"],
				["10","2","2","2","2","3","2","2","2","2","2","2","7","2","12"],
				["18","2","8","2","2","2","2","3","2","5","2","2","2","5","20"],
				["18","2","2","2","4","2","2","2","2","2","4","2","2","2","20"],
				["18","11","2","3","2","2","2","3","2","2","2","2","2","10","20"],
				["15","19","19","19","19","19","19","13","19","19","19","19","19","19","16"]];
		
		
		public function IsometricLevel()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var tex:Texture =Texture.fromBitmap(new AssetTex(),false);
			var img:Image;
			texAtlas=new TextureAtlas(tex,XML(new AssetXml()));
			
			rTex=new RenderTexture(stage.stageWidth,stage.stageHeight);
			var rTexImage:Image= new Image(rTex);
			addChild(rTexImage);
			
			/*// way 1
			var m:Matrix = new Matrix(1,0.5,-1,0.5,0,0);
			for(var i:int=0;i<levelData.length;i++){
				for(var j:int=0;j<levelData[0].length;j++){
					img=new Image(texAtlas.getTexture(paddedName(levelData[i][j])));
					img.x=j*tileWidth+borderX;
					img.y=i*tileWidth+borderY;
					rTex.draw(img);
				}
			}
			m.translate( 300, 0 );
			rTexImage.transformationMatrix = m;*/
			
			//way 2
			var m:Matrix = new Matrix(1,0.5,-1,0.5,0,0);
			var pt:Point=new Point();
			for(var i:int=0;i<levelData.length;i++){
				for(var j:int=0;j<levelData[0].length;j++){
					img=new Image(texAtlas.getTexture(paddedName(levelData[i][j])));
					img.transformationMatrix = m;
					pt.x=j*tileWidth+borderX;
					pt.y=i*tileWidth+borderY;
					pt=IsoHelper.cartToIso(pt);
					img.x=pt.x+300;
					img.y=pt.y;
					rTex.draw(img);
				}
			}
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function paddedName(id:String):String{
			var offset:uint=10000;
			offset+=int(id);
			var str:String="tiles";
			str+=offset.toString().substr(1,4);
			return str;
		}
		private function detectTile(valueX:int, valueY:int):void{
			var tileX:int=int(valueX-borderX)/tileWidth;
			var tileY:int=int(valueY-borderY)/tileWidth;
			if(tileX<0 ||tileY<0 ||tileX>levelData[0].length-1 ||tileY>levelData.length-1){//outside of tile area
				return;
			}
			trace(levelData[tileY][tileX]);
		}
		protected function onTouch(event:TouchEvent):void
		{
			for (var i:int = 0; i < event.getTouches(this).length; ++i)
			{
				touch = event.getTouches(this)[i];
				detectTile(touch.globalX,touch.globalY);
			}
		}
	}
}



