package com.csharks.flagdefense
{
	import com.csharks.juwalbose.IsoHelper;
	import com.csharks.juwalbose.ResourceManager;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;
	
	public class MainLevel extends DisplayObjectContainer
	{
		private var screenOffset:Point=new Point(490,-260);
		
		private var tileWidth:uint=40;/*isogrid tilewidth*/
		private var visibileTiles:Point=new Point(13,20);
		
		private var viewPort:Rectangle=new Rectangle(0,0,1024,768);
		
		private var worldLayer:WorldLayer;
		private var rTexImage:Image;
		private var groundLayer:GroundLayer;
		private var groundImage:Image;
		
		
		private var assetsManager:AssetManager;
		
		private var infoText:TextField;
		
		public function MainLevel()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		public function createLevel():void{
			assetsManager=ResourceManager.assets;
			worldLayer=new WorldLayer(viewPort.width,viewPort.height,tileWidth,screenOffset);
			rTexImage= new Image(worldLayer);
			addChildAt(rTexImage,0);
			
			rTexImage.blendMode=BlendMode.NONE;
			//rTexImage.touchable=false;
			rTexImage.smoothing=TextureSmoothing.NONE;
			
			rTexImage.x=viewPort.x;
			rTexImage.y=viewPort.y;
			
			groundLayer=new GroundLayer(viewPort.width,viewPort.height,tileWidth,screenOffset);
			groundLayer.drawGround();
			groundImage= new Image(groundLayer);
			
			for(var i:int=0;i<groundLayer.rows;i++){
				worldLayer.collisionArray[i]=new Array();
				for(var j:int=0;j<groundLayer.cols;j++){
					if(worldLayer.overlayArray[i][j]!="*"||groundLayer.groundArray[i][j]=="tile4.png"){
						worldLayer.collisionArray[i].push(1);
					}else{
						worldLayer.collisionArray[i].push(0);
					}
				}
			}
			
			var ttFont:String = "Ubuntu";
			var ttFontSize:int = 26; 
			
			infoText = new TextField(800, 100, 
				"Touch to add Explosion", 
				ttFont, ttFontSize);
			infoText.x = stage.stageWidth/2-infoText.width/2;
			infoText.touchable=false;
			infoText.bold = true;
			infoText.nativeFilters=[new GlowFilter(0xffff00)];
			addChild(infoText);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME,loop);
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function loop(e:EnterFrameEvent):void{
			worldLayer.render(e.passedTime,groundImage);
		}
		private function onTouch(e:TouchEvent):void{
			var t:Touch=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t){
				var tp:Point=new Point(t.globalX,t.globalY);
				var ip:Point=new Point(t.globalX,t.globalY);
				tp.x-=screenOffset.x;
				tp.y-=screenOffset.y;
				//image offset
				tp.x-=tileWidth;
				tp=IsoHelper.isoToCart(tp);
				tp=IsoHelper.getTileIndices(tp,tileWidth);
				worldLayer.spawnExplosion(tp,ip);
			}
		}
		
	}
}
