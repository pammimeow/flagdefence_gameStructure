package com.csharks.flagdefense.scenes
{
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.filters.GlowFilter;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	public class HelpScene extends DisplayObjectContainer
	{
		private var assetManager:AssetManager;
		private var backBtn:Button;
		
		private var infoText:TextField;
		public function HelpScene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			initUi();
			
		}
		private function initUi():void{
			assetManager=ResourceManager.assets;
			
			var container:Sprite=new Sprite();
			var base:Image=new Image(assetManager.getTexture("BaseBg"));
			container.addChild(base);
			addChild(container);
			
			var ttFont:String = "Ubuntu";
			var ttFontSize:int = 30; 
			infoText = new TextField(300, 400, 
				"Tap dice to settle it.\nTouch & drag soldier to draw a path while it is your turn.\n\n\n" +
				"You can share the mouse with another user to play multiplayer on same PC.", 
				ttFont, ttFontSize);
			infoText.color = 0xffff00;
			infoText.touchable=false;
			infoText.bold = true;
			infoText.nativeFilters=[new GlowFilter(0x000000)];
			infoText.y=250;
			infoText.x=stage.stageWidth/2-infoText.width/2;
			
			backBtn=new Button(assetManager.getTexture("backbtn"));
			
			backBtn.x=stage.stageWidth/2-backBtn.width/2;
			backBtn.y=stage.stageHeight-backBtn.height-(10);
			
			addChild(backBtn);
			
			var img:Image;
			
			img=new Image(assetManager.getTexture("WoodBase"));
			img.x=base.width/2-img.width/2;
			img.y=(100);
			container.addChild(img);
			
			img=new Image(assetManager.getTexture("TitleOnly"));
			img.x=base.width/2-img.width/2;
			img.y=(25);
			container.addChild(img);
			
			container.flatten();
			container.scaleX=stage.stageWidth/base.width;
			container.scaleY=stage.stageHeight/base.height;
			addChild(infoText);
			
			backBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			
		}
		
		private function handleButtonPress(e:Event):void{
			ResourceManager.playSound("ButtonSfx");
			backBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			var evt:GameEvent=new GameEvent("menu");
			dispatchEvent(evt);
		}
		public override function dispose():void{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}