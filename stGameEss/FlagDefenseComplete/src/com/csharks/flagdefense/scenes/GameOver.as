package com.csharks.flagdefense.scenes
{
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.filters.GlowFilter;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	public class GameOver extends DisplayObjectContainer
	{
		private var assetManager:AssetManager;
		private var backBtn:Button;
		
		private var blueWins:Boolean;
		private var infoText:TextField;
		
		private var score:uint;
		
		public function GameOver(_blueWins:Boolean=false,score:uint=0)
		{
			blueWins=_blueWins;
			this.score=score;
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
			addChild(new Image(assetManager.getTexture("BaseBg")));
			
			var ttFont:String = "Ubuntu";
			var ttFontSize:int = 40; 
			infoText = new TextField(250, 200, 
				"", 
				ttFont, ttFontSize);
			
			infoText.touchable=false;
			infoText.bold = true;
			infoText.nativeFilters=[new GlowFilter(0xffff00)];
			infoText.y=100;
			
			backBtn=new Button(assetManager.getTexture("backbtn"));
			
			backBtn.x=stage.stageWidth/2-backBtn.width/2;
			backBtn.y=stage.stageHeight-backBtn.height-10;
			
			addChild(backBtn);
			
			var img:Image;
			if(blueWins){
				infoText.text="Blue Wins!"
					
				img=new Image(assetManager.getTexture("BlueWithWeapon"));
				img.x=stage.stageWidth-img.width;
				img.y=stage.stageHeight-img.height;
				addChild(img);
				
				img=new Image(assetManager.getTexture("TitleOnly"));
				img.x=stage.stageWidth-img.width-10;
				img.y=stage.stageHeight-img.height-5;
				addChild(img);
				
				img=new Image(assetManager.getTexture("WoodBase"));
				img.x=20;
				img.y=5;
				addChild(img);
				infoText.x = 140;
				
				backBtn.x=(260-backBtn.width/2);
			}else{
				infoText.text="Green Wins!"
				img=new Image(assetManager.getTexture("GreenWithWeapon"));
				img.y=stage.stageHeight-img.height;
				addChild(img);
				
				img=new Image(assetManager.getTexture("TitleOnly"));
				img.x=10;
				img.y=stage.stageHeight-img.height-5;
				addChild(img);
				
				img=new Image(assetManager.getTexture("WoodBase"));
				img.x=stage.stageWidth-img.width-20;
				img.y=5;
				addChild(img);
				infoText.x = 620;
				
				backBtn.x=(760-backBtn.width/2);
			}
			
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


