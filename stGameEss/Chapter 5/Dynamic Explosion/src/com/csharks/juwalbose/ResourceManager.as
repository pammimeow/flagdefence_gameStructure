package com.csharks.juwalbose
{
	import com.csharks.flagdefense.EmbeddedAssets;
	
	import flash.system.Capabilities;
	
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class ResourceManager
	{
		public static var  assets:AssetManager;
		public static var initialised:Boolean=false;
		
		[Embed(source="../../../../assets/flame.png")]
		private static var flame:Class;
		
		[Embed(source="../../../../assets/flameFx.pex", mimeType="application/octet-stream")]
		private static var flame_xml:Class;
		
		[Embed(source="../../../../assets/smoke.png")]
		private static var smoke:Class;
		
		[Embed(source="../../../../assets/smokeFx.pex", mimeType="application/octet-stream")]
		private static var smoke_xml:Class;
		
		public static function get flameFx():PDParticleSystem
		{
			var f:PDParticleSystem = new PDParticleSystem(new XML(new flame_xml()), Texture.fromBitmap(new flame()));
			
			return f;
		}
		public static function get smokeFx():PDParticleSystem
		{
			var s:PDParticleSystem = new PDParticleSystem(new XML(new smoke_xml()), Texture.fromBitmap(new smoke()));
			return s;
		}
		
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