package com.csharks.flagdefense.helpers
{
	import com.csharks.flagdefense.scenes.GameOver;
	import com.csharks.flagdefense.scenes.HelpScene;
	import com.csharks.flagdefense.scenes.MainLevel;
	import com.csharks.flagdefense.scenes.MainMenu;
	import com.csharks.flagdefense.scenes.MultiSamePc;
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.DeviceManager;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;
	
	import so.cuo.anes.admob.AdEvent;
	import so.cuo.anes.admob.AdSize;
	import so.cuo.anes.admob.Admob;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class SceneManager extends DisplayObjectContainer
	{
		private var currentScene:SkeletonScene;
		private var admob:Admob;
		private var adShowing:Boolean=false;
		
		public function SceneManager()
		{
			super();
			
			this.addEventListener(GameEvent.CONTROL_TYPE,onGameEvent);
			
			adShowing=false;
			
		}
		public function launchMenu():void{//call this when resources are ready
			//launchGameOver(false);
			//return;
			currentScene=new MainMenu();
			addChild(currentScene);
		}
		private function showAd():void{
			trace("show ad");
			if (admob.isSupported &&!adShowing)
			{
				adShowing=true;
				admob.addToStage(stage.stageWidth/2-234, 0); // ad to displaylist position 0,0
				admob.load(true); // send a ad request.  
			}
		}
		private function hideAd():void{
			trace("hide ad");
			if (admob.isSupported &&adShowing)
			{
				admob.stopLoading();
				adShowing=false;
				admob.removeFromStage();
			}
		}
		/**
		 * Listens to GameEvent & Swaps scenes 
		 * @param e
		 * 
		 */
		private function onGameEvent(e:GameEvent):void{
			
			switch(e.command){
				case "singlegame":
					hideAd();
					currentScene.removeFromParent(true);
					currentScene=null;
					launchGame();
					break;
				case "multigame":
					hideAd();
					currentScene.removeFromParent(true);
					currentScene=null;
					launchMultiGame();
					break;
				case "menu":
					showAd();
					currentScene.removeFromParent(true);
					currentScene=null;
					launchMenu();
					break;
				case "bluewin":
					showAd();
					currentScene.removeFromParent(true);
					currentScene=null;
					launchGameOver(true);
					break;
				case "greenwin":
					showAd();
					currentScene.removeFromParent(true);
					currentScene=null;
					launchGameOver();
					break;
				case "help":
					showAd();
					currentScene.removeFromParent(true);
					currentScene=null;
					launchHelp();
					break;
				case "lb":
					showAd();
					currentScene.removeFromParent(true);
					currentScene=null;
					
					break;
			}
			System.gc();
		}
		
		private function launchHelp():void
		{
			currentScene=new HelpScene();
			addChild(currentScene);
		}
		
		private function launchGameOver(blueWins:Boolean=false):void
		{
			currentScene=new GameOver(blueWins);
			addChild(currentScene);
		}
		
		private function launchGame():void
		{
			currentScene=new MainLevel();
			addChild(currentScene);
		}
		private function launchMultiGame():void
		{
			currentScene=new MultiSamePc();
			addChild(currentScene);
		}
		public function rescaleAndRedraw(newWidth:Number,newHeight:Number):void{
			if(ResourceManager.assets){
				ResourceManager.assets.purge();
			}
			trace("scaling", newWidth,newHeight);
			var visibileTiles:Point=new Point(13,20);
			var newDimensionX:uint=1+Math.round(newWidth/visibileTiles.x);
			var newDimensionY:uint=1+Math.round(newHeight/visibileTiles.y);
			
			if(newDimensionX>2*newDimensionY){
				newDimensionX=2*newDimensionY;
			}else{
				newDimensionY=newDimensionX/2;
				newDimensionX=2*newDimensionY;
			}
			var scaleRatio:Number=Math.round(newDimensionY/8)/10;
			ResourceManager.initialise(scaleRatio);
			//trace(newDimensionY,scaleRatio);
			addEventListener(starling.events.Event.ENTER_FRAME,waitForReload);
		}
		private function waitForReload(e:starling.events.Event):void{
			if(ResourceManager.initialised){
				removeEventListener(starling.events.Event.ENTER_FRAME,waitForReload);
				
				admob=Admob.getInstance();
				var adMobId:String;
				if(DeviceManager.isAndroid){
					adMobId="XXXX";
				}else if(DeviceManager.isIpad){
					adMobId="xxxxx";
				}else{
					adMobId="xxxxx";
				}
				if (admob.isSupported)
				{
					admob.setIsLandscape(true);
					admob.createADView(AdSize.BANNER, adMobId); //create a banner ad view.this init the view 
					admob.dispatcher.addEventListener(AdEvent.onReceiveAd,onAdEvent);
				}
				
				showAd();
				launchMenu();
			}
		}
		
		public function tryBackPress():void
		{
			//this may need a cool down period of say 1 sec else too many events will be fired
			currentScene.backButtonPressed();
		}
		public override function dispose():void{
			if (admob.isSupported)
			{
				admob.dispatcher.removeEventListener(AdEvent.onReceiveAd,onAdEvent);
				admob.stopLoading();
				admob.destroyADView();
				admob.dispose();
			}
		}
		
		protected function onAdEvent(event:flash.events.Event):void
		{
			trace("ad is here",admob.getAdSize(),admob.getScreenSize());
			
			//admob.getScreenSize();
		}
	}
}