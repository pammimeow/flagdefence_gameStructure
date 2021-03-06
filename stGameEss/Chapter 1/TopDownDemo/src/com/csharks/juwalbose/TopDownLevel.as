package com.csharks.juwalbose
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TopDownLevel extends DisplayObjectContainer
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

		
		public function TopDownLevel()
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
			for(var i:int=0;i<levelData.length;i++){//i is for rows
				for(var j:int=0;j<levelData[0].length;j++){//j is for columns
					img=new Image(texAtlas.getTexture(paddedName(levelData[i][j])));
					addChild(img);
					img.x=j*tileWidth+borderX;
					img.y=i*tileWidth+borderY;
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