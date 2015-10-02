
package
{
	import com.csharks.juwalbose.IsometricLevel;
	import com.csharks.juwalbose.TopDownLevel;
	import com.csharks.juwalbose.TopDownLevelRT;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	import starling.core.Starling;
	
	[SWF(backgroundColor = "#000000", frameRate = "30", width = "800", height = "600")]
	
	public class TopDownDemo extends Sprite
	{
		private var gstarling:Starling;
		
		public function TopDownDemo()
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
			
			gstarling = new Starling(IsometricLevel, stage);
			gstarling.start();
			//starling = new Starling(TopDownLevelRT, stage);
			//starling = new Starling(IsometricLevel, stage);
			
			gstarling.showStats = false;
			gstarling.simulateMultitouch  = false;
			gstarling.enableErrorChecking = false;
			gstarling.antiAliasing=0;
			//gstarling.start();

			
			gstarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void 
			{
				gstarling.start();
			});
		}

	}
}