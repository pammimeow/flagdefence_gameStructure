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
	
	public class GameOver extends SkeletonScene
	{
		private var assetManager:AssetManager;
		private var backBtn:Button;
		
		private var blueWins:Boolean;
		private var infoText:TextField;
		private var SR:Number;
		public function GameOver(_blueWins:Boolean=false)
		{
			blueWins=_blueWins;
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
			
			var ttFont:String = "Ubuntu";
			var ttFontSize:int = 80*SR; 
			infoText = new TextField(500*SR, 400*SR, 
				"", 
				ttFont, ttFontSize);
			
			infoText.touchable=false;
			infoText.bold = true;
			infoText.nativeFilters=[new GlowFilter(0xffff00)];
			infoText.y=200*SR;
			
			backBtn=new Button(assetManager.getTexture("backbtn"));
			
			backBtn.x=stage.stageWidth/2-backBtn.width/2;
			backBtn.y=stage.stageHeight-backBtn.height-(20*SR);
			
			addChild(backBtn);
			
			var img:Image;
			if(blueWins){
				infoText.text="Blue Wins!"
				
				img=new Image(assetManager.getTexture("TitleOnly"));
				img.x=base.width-img.width-(20*SR);
				img.y=base.height-img.height-(10*SR);
				container.addChild(img);
				
				img=new Image(assetManager.getTexture("WoodBase"));
				img.x=40*SR;
				img.y=10*SR;
				container.addChild(img);
				infoText.x = 280*SR;
				
				backBtn.x=((520*SR)-backBtn.width/2);
			}else{
				infoText.text="Green Wins!"
				
				img=new Image(assetManager.getTexture("TitleOnly"));
				img.x=20*SR;
				img.y=stage.stageHeight-img.height-(10*SR);
				container.addChild(img);
				
				img=new Image(assetManager.getTexture("WoodBase"));
				img.x=stage.stageWidth-img.width-(40*SR);
				img.y=10*SR;
				container.addChild(img);
				infoText.x = 1240*SR;
				
				backBtn.x=((1520*SR)-backBtn.width/2);
			}
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


