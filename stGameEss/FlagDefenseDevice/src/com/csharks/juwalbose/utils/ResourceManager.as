/**
 *
 * Copyright 2013 Juwal Bose, Csharks Games. All rights reserved.
 *
 * Email: juwal@csharks.com
 * Blog: http://csharksgames.blogspot.com
 * Twitter: @juwalbose
 
 * You may redistribute, use and/or modify this source code freely
 * but this copyright statement must not be removed from the source files.
 *
 * The package structure of the source code must remain unchanged.
 * Mentioning the author in the binary distributions is highly appreciated.
 *
 * If you use this utility it would be nice to hear about it so feel free to drop
 * an email.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. *
 *
 */
package com.csharks.juwalbose.utils
{
	import com.adobe.images.PNGEncoder;
	import com.csharks.flagdefense.EmbeddedAssets;
	import com.csharks.juwalbose.utils.DynamicAtlasCreator;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class ResourceManager
	{
		public static var  assets:AssetManager;
		public static var initialised:Boolean=false;
		private static var loader:Loader;
		private static var loadCount:uint;
		
		private static var data:XML;
		private static var XhdpiPng:Bitmap;
		public static var scaleRatio:Number=1;
		
		private static var file:File=new File();
		//name for saving texture image & xml
		private static var atlasName:String="dsa";
		
		public static var musicChannel:SoundChannel=new SoundChannel();
		//private static var tempSound:Sound=new Sound();
		public static var fxTransform:SoundTransform=new SoundTransform();
		public static var musicTransform:SoundTransform=new SoundTransform();
		public static var gameMusic:Sound;
		public static var fxChannel:SoundChannel=new SoundChannel();
		public static var soundEnabled:Boolean=true;
		private static var soundStore:Dictionary=new Dictionary();
		
		private static var die:DieSfx;
		private static var soldier:SoldierSfx;
		private static var flag:FlagSfx;
		private static var button:ButtonSfx;
		private static var explode:ExplodeSfx;
		private static var mine:MineSfx;
		private static var sword:SwordSfx;
		
		[Embed(source="../../../../../assets/flame.png")]
		private static var flame:Class;
		
		[Embed(source="../../../../../assets/flameFx.pex", mimeType="application/octet-stream")]
		private static var flame_xml:Class;
		
		[Embed(source="../../../../../assets/smoke.png")]
		private static var smoke:Class;
		
		[Embed(source="../../../../../assets/smokeFx.pex", mimeType="application/octet-stream")]
		private static var smoke_xml:Class;
		
		[Embed(source = "../../../../../assets/characters2048.xml", mimeType = "application/octet-stream")]
		private static const charactersXml:Class;
		
		[Embed(source = "../../../../../assets/rest2048.xml", mimeType = "application/octet-stream")]
		private static const restXml:Class;
		
		public static function initialise(_scaleRatio:Number):void{
			
			///Users/juwalbose/Library/Application Support/com.csharks.flagdefense/Local Store
			
			initialised=false;
			var intConv:uint=Math.round(_scaleRatio*10);
			scaleRatio=intConv/10;
			
			loadCount=1;
			assets= new AssetManager(1,false);
			assets.verbose = Capabilities.isDebugger;
			
			atlasName="characters";
			if(scaleRatio>1){
				scaleRatio=1;
			}
			if(scaleRatio==1){
				loadOriginal();
			}else{
				loadNext();
			}
		}
		
		private static function loadOriginal():void
		{
			assets.enqueue(File.applicationDirectory.resolvePath("media/characters2048.png"),
				File.applicationDirectory.resolvePath("media/rest2048.png"),
				File.applicationDirectory.resolvePath("media/characters2048.xml"),
				File.applicationDirectory.resolvePath("media/rest2048.xml"),
				File.applicationDirectory.resolvePath("media/BaseBg.jpg"),
				File.applicationDirectory.resolvePath("media/WoodBase.jpg"),
				EmbeddedAssets
			);
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1){
					dispose();
					initialised=true;
				}
			});
			
		}
		private static function loadNext():void{
			var hasSavedAtlas:Boolean=false;
			file=File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".png");
			if(file.exists){
				file=File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".xml");
				if(file.exists){
					//load those files instead
					hasSavedAtlas=true;
				}
			}
			
			if(!hasSavedAtlas){
				loadImage("media/"+atlasName+"2048.png");
			}else{
				whatsNext();
			}
		}
		private static function loadImage(fileName:String):void
		{
			loader = new Loader();
			var urlReq:URLRequest = new URLRequest(fileName);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.load(urlReq);
		}
		private static function loaded(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
			XhdpiPng=e.target.content as Bitmap;
			if(loadCount==1){
				data=XML(new charactersXml());
			}else{
				data=XML(new restXml());
			}
			loader.unloadAndStop(true);
			loader=null;
			
			DynamicAtlasCreator.creationComplete.add(creationComplete);
			DynamicAtlasCreator.createFrom(XhdpiPng.bitmapData,data,scaleRatio,assets,atlasName);
		}
		private static function creationComplete(result:String):void {  
			DynamicAtlasCreator.creationComplete.remove(creationComplete);
			
			System.disposeXML(data);
			data=null;
			XhdpiPng.bitmapData.dispose();
			XhdpiPng=null;
			
			if(result=="success"){
				saveAtlas();
			}
			
			
		}
		
		private static function saveAtlas():void{//Users/<userName>/Library/Application Support/<applicationID>/Local Store
			trace("saving atlas",atlasName);
			file=File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".xml");
			var filestream:FileStream=new FileStream();
			filestream.open(file,FileMode.WRITE);
			filestream.writeUTFBytes(DynamicAtlasCreator.finalXML);
			filestream.close();
			// Encode the image as a PNG.
			var pngEncoder:PNGEncoder = new PNGEncoder();
			var imageByteArray:ByteArray = PNGEncoder.encode(DynamicAtlasCreator.finalAtlas);
			
			var imageFile:File = File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".png");
			
			// Write the image data to a file.
			var imageFileStream:FileStream = new FileStream();
			imageFileStream.open(imageFile, FileMode.WRITE);
			imageFileStream.writeBytes(imageByteArray);
			imageFileStream.close();  
			
			imageByteArray=null;
			pngEncoder=null;
			
			//dispose explicitly
			DynamicAtlasCreator.dispose();
			
			whatsNext();
		}
		private static function whatsNext():void{
			loadCount++;
			if(loadCount==3){
				loadThemAll();
			}else{
				atlasName="rest";
				loadNext();
			}
		}
		private static function loadThemAll():void
		{
			assets.enqueue(File.applicationStorageDirectory.resolvePath("characters"+scaleRatio.toString()+".png"),
				File.applicationStorageDirectory.resolvePath("characters"+scaleRatio.toString()+".xml"),
				File.applicationStorageDirectory.resolvePath("rest"+scaleRatio.toString()+".png"),
				File.applicationStorageDirectory.resolvePath("rest"+scaleRatio.toString()+".xml"),
				File.applicationDirectory.resolvePath("media/BaseBg.jpg"),
				File.applicationDirectory.resolvePath("media/WoodBase.jpg"),
				EmbeddedAssets
			);
			assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1){
					dispose();
					initialised=true;
				}
			});
			
		}
		
		public static function get flameFx():PDParticleSystem
		{
			var f:PDParticleSystem = new PDParticleSystem(new XML(new flame_xml()), Texture.fromBitmap(new flame(),false));
			
			return f;
		}
		public static function get smokeFx():PDParticleSystem
		{
			var s:PDParticleSystem = new PDParticleSystem(new XML(new smoke_xml()), Texture.fromBitmap(new smoke(),false));
			
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
		private static function dispose():void{
			file=null;
			die=null;
			soldier=null;
			button=null;
			explode=null;
			mine=null;
			sword=null;
		}
	}
}