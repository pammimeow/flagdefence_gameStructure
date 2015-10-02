package com.csharks.flagdefense.scenes
{
	import com.csharks.flagdefense.helpers.SkeletonScene;
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class MainMenu extends SkeletonScene
	{
		private var assetManager:AssetManager;
		private var singleBtn:Button;
		private var multiBtn:Button;
		private var helpBtn:Button;
		private var soundBtn:Button;
		private var lbBtn:Button;
		private var SR:Number;
		
		public function MainMenu()
		{
			super();
		}
		
		protected override function init(e:Event):void 
		{
			super.init(e);
			
			initUi();
			
		}
		private function initUi():void{//trace("menu done");
			assetManager=ResourceManager.assets;
			SR=ResourceManager.scaleRatio;
			
			var container:Sprite=new Sprite();
			var base:Image=new Image(assetManager.getTexture("BaseBg"));
			container.addChild(base);
			
			var img:Image=new Image(assetManager.getTexture("TitleOnly"));
			img.x=base.width/2-img.width/2-(40*SR);
			img.y=base.height-img.height-(10*SR);
			container.addChild(img);
			
			addChild(container);
			container.flatten();
			container.scaleX=stage.stageWidth/base.width;
			container.scaleY=stage.stageHeight/base.height;
			
			singleBtn=new Button(assetManager.getTexture("singlebtn"));
			multiBtn=new Button(assetManager.getTexture("multibtn"));
			helpBtn=new Button(assetManager.getTexture("helpbtn"));
			soundBtn=new Button(assetManager.getTexture("soundbtn"));
			lbBtn=new Button(assetManager.getTexture("lbbtn"));
			
			singleBtn.x=multiBtn.x=stage.stageWidth/2-singleBtn.width/2;
			helpBtn.x=stage.stageWidth/2-helpBtn.width/2;
			lbBtn.x=stage.stageWidth/2-lbBtn.width/2;
			singleBtn.y=multiBtn.y=helpBtn.y=lbBtn.y=-singleBtn.height;
			soundBtn.x=stage.stageWidth-soundBtn.width-(20*SR);
			soundBtn.y=(20*SR);
			
			addChild(singleBtn);
			addChild(multiBtn);
			addChild(helpBtn);
			addChild(lbBtn);
			addChild(soundBtn);
			
			TweenLite.to(singleBtn,0.5,{y:(500*SR),ease:Back.easeOut,onComplete:addListeners});
			TweenLite.to(multiBtn,0.5,{y:(660*SR),ease:Back.easeOut,delay:0.2});
			TweenLite.to(helpBtn,0.5,{y:(820*SR),ease:Back.easeOut,delay:0.4});
			TweenLite.to(lbBtn,0.5,{y:(980*SR),ease:Back.easeOut,delay:0.6});
			//trace("menu done");
			
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
			var yVal:int=stage.stageHeight+(200*SR);
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