package
{
	import com.csharks.flagdefense.helpers.SceneManager;
	import com.csharks.juwalbose.utils.DeviceManager;
	import com.csharks.juwalbose.utils.ResourceManager;
	import com.greensock.TweenLite;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(backgroundColor = "#004400", frameRate = "30", width "100%", height = "100%")]
	/**
	 * Publishing check list
	 * 
	 * Android - Default ipad non retina image
	 * icons enable in XML
	 * 
	 * IOS - All default images
	 * icons enable in XML
	 * 
	 * AdMob set to load real ads, not test ads
	 * 
	 */
	public class FlagDefenseDevice extends Sprite
	{
		private var starling:Starling;
		private var viewPort:Rectangle;
		
		private var startupBitmap:Bitmap;
		private var loader:Loader;
		public function FlagDefenseDevice()
		{
			if (stage) init();
			else addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:flash.events.Event = null):void 
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			trace("Device is",DeviceManager.DeviceDetails.device);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			/*
			Todo
			Context loss using new Asset manager
			
			*/
			
			trace("starting starling ",Starling.VERSION);
			Starling.multitouchEnabled = false; // useful on mobile devices
			if(!DeviceManager.isIOS){
				Starling.handleLostContext = true; // required on Windows , false for iOS & true for Android
			}else{
				Starling.handleLostContext = false; // required on Windows , false for iOS & true for Android
			}
			
			
			starling = new Starling(SceneManager, stage,null,null,"auto",Context3DProfile.BASELINE);//"baseline");
			starling.showStats = true;
			starling.simulateMultitouch  = false;
			starling.enableErrorChecking = Capabilities.isDebugger;
			starling.antiAliasing=0;
			
			
			starling.start();
			
			// this event is dispatched when stage3D is set up
			starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			
			stage.addEventListener(flash.events.Event.RESIZE,onResize);
			
			showStartUpImage();
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, 
				function (e:flash.events.Event):void { trace("activate");starling.start(); if(ResourceManager.soundEnabled){
					ResourceManager.startMusic();
				}});
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, 
				function (e:flash.events.Event):void { trace("deactivate");starling.stop();ResourceManager.stopMusic();});
			
			NativeApplication.nativeApplication.systemIdleMode=SystemIdleMode.KEEP_AWAKE;
			
			this.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN,handleKeyDown);
		}
		
		private function showStartUpImage():void
		{
			loader = new Loader();
			var urlReq:URLRequest = new URLRequest("Default-Landscape~ipad.png");
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loaded);
			loader.load(urlReq);
			
		}
		private function loaded(e:flash.events.Event):void
		{
			loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loaded);
			startupBitmap=e.target.content as Bitmap;
			loader.unloadAndStop(true);
			loader=null;
			
			startupBitmap.width  = stage.fullScreenWidth;
			startupBitmap.height = stage.fullScreenHeight;
			startupBitmap.smoothing = true;
			//startupBitmap.rotation=-90;
			//startupBitmap.y=startupBitmap.height;
			this.addChild(startupBitmap);
			this.addEventListener(flash.events.Event.ENTER_FRAME,checkInitialised);
		}
		
		private function checkInitialised(event:flash.events.Event):void
		{
			if(ResourceManager.initialised){
				this.removeEventListener(flash.events.Event.ENTER_FRAME,checkInitialised);
				//load process complete
				removeChild(startupBitmap);
				startupBitmap.bitmapData.dispose();
				startupBitmap=null;
				System.gc();
			}
		}
		
		private function handleKeyDown(ev:flash.events.KeyboardEvent):void{
			switch(ev.keyCode){
				case Keyboard.ESCAPE://for testing on PC :)
				case Keyboard.BACK:
					trace("back press");
					ev.preventDefault();
					var gameRef:SceneManager=Starling.current.root as SceneManager;
					gameRef.tryBackPress();
					break;
				case Keyboard.MENU:
					trace("menu");
					ev.preventDefault();
					break;
				case Keyboard.SEARCH:
					trace("search");
					ev.preventDefault();
					break;
			}
		}
		private function onRootCreated(event:starling.events.Event, game:SceneManager):void
		{
			TweenLite.delayedCall(0.1,onResize);
			//onResize();
		}
		private function onResize(e:flash.events.Event=null):void
		{
			//trace(stage.stageWidth,stage.stageHeight,e);
			starling.stage.stageWidth=stage.stageWidth;
			starling.stage.stageHeight=stage.stageHeight;
			
			viewPort = starling.viewPort;
			viewPort.width = stage.stageWidth;
			viewPort.height = stage.stageHeight;
			
			try
			{
				starling.viewPort = viewPort;
				TweenLite.killDelayedCallsTo(scaleGame);
				TweenLite.delayedCall(0.1,scaleGame);
			}
			catch(error:Error) {trace("error");}
			
		}
		private function scaleGame():void{
			trace("resize", stage.stageWidth,stage.stageHeight,stage.fullScreenWidth,stage.fullScreenHeight);
			(Starling.current.root as SceneManager).rescaleAndRedraw(stage.stageWidth,stage.stageHeight);
		}
	}
}