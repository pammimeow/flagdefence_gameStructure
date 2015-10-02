package com.csharks.flagdefense.scenes
{
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class MainMenu extends DisplayObjectContainer
	{
		private var assetManager:AssetManager;
		private var singleBtn:Button;
		private var multiBtn:Button;
		private var helpBtn:Button;
		private var soundBtn:Button;
		private var lbBtn:Button;
		
		public function MainMenu()
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
			addChild(new Image(assetManager.getTexture("BaseBg")));
			
			var img:Image=new Image(assetManager.getTexture("BlueWithWeapon"));
			img.x=stage.stageWidth-img.width;
			img.y=stage.stageHeight-img.height;
			addChild(img);
			img=new Image(assetManager.getTexture("GreenWithWeapon"));
			img.y=stage.stageHeight-img.height;
			addChild(img);
			img=new Image(assetManager.getTexture("TitleOnly"));
			img.x=stage.stageWidth/2-img.width/2-20;
			img.y=stage.stageHeight-img.height-5;
			addChild(img);
			
			singleBtn=new Button(assetManager.getTexture("singlebtn"));
			multiBtn=new Button(assetManager.getTexture("multibtn"));
			helpBtn=new Button(assetManager.getTexture("helpbtn"));
			soundBtn=new Button(assetManager.getTexture("soundbtn"));
			lbBtn=new Button(assetManager.getTexture("lbbtn"));
			
			singleBtn.x=multiBtn.x=stage.stageWidth/2-singleBtn.width/2;
			helpBtn.x=stage.stageWidth/2-helpBtn.width/2;
			lbBtn.x=stage.stageWidth/2-lbBtn.width/2;
			singleBtn.y=multiBtn.y=helpBtn.y=lbBtn.y=-singleBtn.height;
			soundBtn.x=stage.stageWidth-10-soundBtn.width;
			soundBtn.y=10;
			
			addChild(singleBtn);
			addChild(multiBtn);
			addChild(helpBtn);
			addChild(lbBtn);
			addChild(soundBtn);
			
			TweenLite.to(singleBtn,0.5,{y:250,ease:Back.easeOut,onComplete:addListeners});
			TweenLite.to(multiBtn,0.5,{y:330,ease:Back.easeOut,delay:0.2});
			TweenLite.to(helpBtn,0.5,{y:410,ease:Back.easeOut,delay:0.4});
			TweenLite.to(lbBtn,0.5,{y:490,ease:Back.easeOut,delay:0.6});
			
		}
		private function addListeners():void{
			singleBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			multiBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			helpBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			soundBtn.addEventListener(Event.TRIGGERED, toggleSound);
			lbBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
		}
		private function removeListeners():void{
			singleBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			multiBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			helpBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			soundBtn.removeEventListener(Event.TRIGGERED, toggleSound);
			lbBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
		}
		private function switchScene(id:String):void
		{
			var evt:GameEvent=new GameEvent(id);
			dispatchEvent(evt);
		}
		private function toggleSound(e:Event):void
		{
			// TODO Auto Generated method stub
			if(ResourceManager.soundEnabled){
				ResourceManager.soundEnabled=false;
				ResourceManager.stopMusic();
			}else{
				ResourceManager.soundEnabled=true;
				ResourceManager.startMusic();
			}
		}
		private function handleButtonPress(e:Event):void{
			removeListeners();
			var yVal:int=stage.stageHeight+100;
			TweenLite.to(singleBtn,0.5,{y:yVal,ease:Back.easeIn});
			TweenLite.to(multiBtn,0.5,{y:yVal,ease:Back.easeIn});
			TweenLite.to(helpBtn,0.5,{y:yVal,ease:Back.easeIn});
			TweenLite.to(lbBtn,0.5,{y:yVal,ease:Back.easeIn});
			ResourceManager.playSound("ButtonSfx");
			TweenLite.killTweensOf(e.target);
			switch(e.target){
				case singleBtn:
					TweenLite.to(singleBtn,0.5,{y:yVal,delay:0.3,ease:Back.easeIn,onComplete:switchScene,onCompleteParams:["singlegame"]});
					break;
				case multiBtn:
					TweenLite.to(multiBtn,0.5,{y:yVal,delay:0.3,ease:Back.easeIn,onComplete:switchScene,onCompleteParams:["multigame"]});
					break;
				case helpBtn:
					TweenLite.to(helpBtn,0.5,{y:yVal,delay:0.3,ease:Back.easeIn,onComplete:switchScene,onCompleteParams:["help"]});
					break;
				case lbBtn:
					TweenLite.to(lbBtn,0.5,{y:yVal,delay:0.3,ease:Back.easeIn,onComplete:switchScene,onCompleteParams:["lb"]});
					break;
				
			}
			
		}
		public override function dispose():void{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}