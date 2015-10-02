package
{
	import com.csharks.flagdefense.helpers.SceneManager;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(backgroundColor = "#004400", frameRate = "30", width = "1024", height = "768")]
	
	public class FlagDefenseComplete extends Sprite
	{
		private var starling:Starling;
		private var viewPort:Rectangle;
		
		public function FlagDefenseComplete()
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
			
			starling = new Starling(SceneManager, stage,null,null,"auto","baseline");
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
				(Starling.current.root as SceneManager).launchMenu();
				
			}
		}
		
		private function onRootCreated(event:starling.events.Event, game:SceneManager):void
		{
			ResourceManager.initialise();
		}
	}
}