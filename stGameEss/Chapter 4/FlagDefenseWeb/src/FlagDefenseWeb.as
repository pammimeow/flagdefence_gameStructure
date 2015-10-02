package
{
	import com.csharks.flagdefense.MainLevel;
	import com.csharks.juwalbose.ResourceManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(backgroundColor = "#004400", frameRate = "30", width = "1024", height = "768")]
	
	public class FlagDefenseWeb extends Sprite
	{
		private var starling:Starling;
		private var viewPort:Rectangle;
		
		public function FlagDefenseWeb()
		{
			if (stage) init();
			else addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:flash.events.Event = null):void 
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			/*
			Todo
			Context loss using new Asset manager
			
			*/
			
			trace("starting starling ",Starling.VERSION);
			Starling.multitouchEnabled = false; // useful on mobile devices
			Starling.handleLostContext = true; // required on Windows
			
			starling = new Starling(MainLevel, stage,null,null,"auto","baseline");
			starling.showStats = true;
			starling.simulateMultitouch  = false;
			starling.enableErrorChecking = Capabilities.isDebugger;
			starling.antiAliasing=0;
			
			//starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void 
			//{
				starling.start();
				
			//});
			
			// this event is dispatched when stage3D is set up
			starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			
			this.addEventListener(flash.events.Event.ENTER_FRAME,loop);
			
		}
		private function loop(e:flash.events.Event):void{
			if(ResourceManager.initialised){
				this.removeEventListener(flash.events.Event.ENTER_FRAME,loop);
				(Starling.current.root as MainLevel).createLevel();
				
			}
		}
		
		private function onRootCreated(event:starling.events.Event, game:MainLevel):void
		{
			ResourceManager.initialise();
		}
	}
}