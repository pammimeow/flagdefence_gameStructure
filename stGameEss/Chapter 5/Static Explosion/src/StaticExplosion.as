package
{
	import com.csharks.juwalbose.ExplodingLevel;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(backgroundColor = "#000000", frameRate = "30", width = "1024", height = "768")]
	
	public class StaticExplosion extends Sprite
	{
		private var starling:Starling;
		
		public function StaticExplosion()
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
			
			starling = new Starling(ExplodingLevel, stage);
			starling.showStats = false;
			starling.simulateMultitouch  = false;
			starling.enableErrorChecking = false;
			starling.antiAliasing=0;
			
			
			starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void 
			{
				starling.start();
				
			});
		}
		
		
		
		
	}
}