package com.csharks.juwalbose
{
	import com.csharks.flagdefense.EmbeddedAssets;
	
	import flash.system.Capabilities;
	import starling.utils.AssetManager;
	
	public class ResourceManager
	{
		public static var  assets:AssetManager;
		public static var initialised:Boolean=false;
		
		public static function initialise():void{
			assets= new AssetManager();
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(EmbeddedAssets);
			assets.loadQueue(function(ratio:Number):void
			{
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 
				
				if (ratio == 1){
					
					initialised=true;
				}
			});
		}
		
	}
}