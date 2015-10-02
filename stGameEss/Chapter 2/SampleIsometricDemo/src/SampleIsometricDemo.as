package
{
	import com.csharks.juwalbose.IsometricLevel;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(backgroundColor = "#000000", frameRate = "30", width = "1024", height = "768")]
	
	public class SampleIsometricDemo extends Sprite
	{
		private var mstarling:Starling;
		
		public function SampleIsometricDemo()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Starling.multitouchEnabled = false; // useful on mobile devices
			Starling.handleLostContext = false; // required on Android
			
			mstarling = new Starling(IsometricLevel, stage);
			mstarling.showStats = false;
			mstarling.showStats = false;
			mstarling.simulateMultitouch  = false;
			mstarling.enableErrorChecking = false;
			mstarling.antiAliasing=0;
			
			
			mstarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void 
			{
				mstarling.start();
				
			});
		}
		
		

		
	}
}