package com.csharks.flagdefense.scenes
{
	import com.csharks.flagdefense.helpers.SkeletonScene;
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.filters.GlowFilter;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	public class HelpScene extends SkeletonScene
	{
		private var assetManager:AssetManager;
		private var backBtn:Button;
		
		private var infoText:TextField;
		private var SR:Number;
		
		public function HelpScene()
		{
			super();
		}
		
		protected override function init(e:Event):void 
		{
			super.init(e);
			initUi();
			
		}
		private function initUi():void{
			assetManager=ResourceManager.assets;
			SR=ResourceManager.scaleRatio;
			
			var container:Sprite=new Sprite();
			var base:Image=new Image(assetManager.getTexture("BaseBg"));
			container.addChild(base);
			addChild(container);
			
			backBtn=new Button(assetManager.getTexture("backbtn"));
			
			backBtn.x=stage.stageWidth/2-backBtn.width/2;
			backBtn.y=stage.stageHeight-backBtn.height-(20*SR);
			
			addChild(backBtn);
			
			var img:Image;
			
			img=new Image(assetManager.getTexture("WoodBase"));
			img.x=base.width/2-img.width/2;
			img.y=(200*SR);
			container.addChild(img);
			
			var ttFont:String = "Ubuntu";
			var ttFontSize:int = 60*SR; 
			infoText = new TextField(700*SR, 800*SR, 
				"Get enemy flag to your flag pole to win. Walking over an enemy will reset him to his castle.\n" +
				"Tap dice to settle it.\nTap to select soldier & tap screen top, down, left or right to mark path while it is your turn.\n" +
				"You can use the same device with 2 users to play multiplayer.", 
				ttFont, ttFontSize);
			infoText.color = 0xffff00;
			infoText.touchable=false;
			infoText.bold = true;
			infoText.nativeFilters=[new GlowFilter(0x000000)];
			infoText.y=img.y+200*SR;
			infoText.x=stage.stageWidth/2-infoText.width/2;
			
			img=new Image(assetManager.getTexture("TitleOnly"));
			img.x=base.width/2-img.width/2;
			img.y=(50*SR);
			container.addChild(img);
			
			container.flatten();
			container.scaleX=stage.stageWidth/base.width;
			container.scaleY=stage.stageHeight/base.height;
			addChild(infoText);
			
			backBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			
		}
		
		private function handleButtonPress(e:Event=null):void{
			ResourceManager.playSound("ButtonSfx");
			backBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			var evt:GameEvent=new GameEvent("menu");
			dispatchEvent(evt);
		}
		public override function backButtonPressed():void{
			handleButtonPress();
		}
		public override function dispose():void{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}