package com.csharks.juwalbose.utils
{
	import com.csharks.flagdefense.EmbeddedAssets;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class ResourceManager
	{
		public static var  assets:AssetManager;
		public static var initialised:Boolean=false;
		
		public static var musicChannel:SoundChannel=new SoundChannel();
		//private static var tempSound:Sound=new Sound();
		public static var fxTransform:SoundTransform=new SoundTransform();
		public static var musicTransform:SoundTransform=new SoundTransform();
		public static var gameMusic:Sound;
		public static var fxChannel:SoundChannel=new SoundChannel();
		
		public static var soundEnabled:Boolean=true;
		private static var soundStore:Dictionary=new Dictionary();
		
		private var die:DieSfx;
		private var soldier:SoldierSfx;
		private var flag:FlagSfx;
		private var button:ButtonSfx;
		private var explode:ExplodeSfx;
		private var mine:MineSfx;
		private var sword:SwordSfx;
		
		[Embed(source="../../../../../assets/flame.png")]
		private static var flame:Class;
		
		[Embed(source="../../../../../assets/flameFx.pex", mimeType="application/octet-stream")]
		private static var flame_xml:Class;
		
		[Embed(source="../../../../../assets/smoke.png")]
		private static var smoke:Class;
		
		[Embed(source="../../../../../assets/smokeFx.pex", mimeType="application/octet-stream")]
		private static var smoke_xml:Class;
		
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
		
		public static function startMusic():void {
			if(gameMusic!=null){
				return;
			}
			gameMusic=new Music();
			musicTransform.volume=0.5;
			if(ResourceManager.soundEnabled){
				try{
					musicChannel=gameMusic.play(0,0,musicTransform);
				}
				catch(e:Error){
				}
				musicChannel.addEventListener(flash.events.Event.SOUND_COMPLETE,musicCompleteHandler);
			}
		}
		public static function stopMusic():void {
			if(musicChannel.hasEventListener(flash.events.Event.SOUND_COMPLETE)){
				musicChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE,musicCompleteHandler);
			}
			
			musicChannel.stop();
			gameMusic=null;
		}
		private static function musicCompleteHandler(evnt:flash.events.Event):void {
			musicChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE,musicCompleteHandler);
			if(ResourceManager.soundEnabled){
				try{
					musicChannel=gameMusic.play(0,0,musicTransform);
				}
				catch(e:Error){
					
				}
				musicChannel.addEventListener(flash.events.Event.SOUND_COMPLETE,musicCompleteHandler);
			}
		}
		public static function playSound(which:String):void {
			if(soundStore[which]==undefined){
				//trace("snd create", which);
				var ClassReference:Class = getClass(which) as Class;
				soundStore[which] = new ClassReference();
			}
			if (ResourceManager.soundEnabled) {
				//here it attaches and plays
				fxTransform.volume=0.5;
				try{
					fxChannel = soundStore[which].play(0,0,fxTransform);
				}
				catch(e:Error){
					
				}
				
			}
		}
		public static function getClass(id:String):Object
		{
			return getDefinitionByName(id) ;
		}
	}
}