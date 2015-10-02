/**
 * DynamicAtlasCreator v0.9 AIR version which keeps links to created BitmapData & XML, need to explicitly dispose them.
 *
 * Copyright 2013 Juwal Bose, Csharks Games. All rights reserved.
 *
 * Email: juwal@csharks.com
 * Blog: http://csharksgames.blogspot.com
 * Twitter: @juwalbose
 * 
 * This code is based on the Rectangle packing algorithm developed by Ville Koskela
 * More on this can be found at http://villekoskela.org/2012/08/12/rectangle-packing/
 *
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
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.villekoskela.utils.RectanglePacker;
	
	import starling.utils.AssetManager;
	

	/**
	 * Class helps create starling textures for any size based on a 2048 based texture atlas.
	 * The created textures are read from a single packed texture, there by enabling batching.
	 * Texture creation always maintains aspect ratio.
	 * @author juwalbose
	 * Dependencies: AS3 Signals, RectanglePacker
	 */
	public class DynamicAtlasCreator
	{
		private static var scaleRatio:Number=1;
		private static var gameAtlas:Dictionary;
		private static const padding:int = 1;
		private static var mPacker:RectanglePacker;
		private static var sizeIterator:uint;
		private static var totalTextures:uint;
		private static var lookup:Dictionary;
		private static var newSize:Point=new Point();
		
		//private static var customAtlas:Texture;
		private static var assets:AssetManager;
		private static var originalXML:XML;
		private static var useTextureFrames:Boolean=true;
		/**
		 * Enable for supporting 4096 textures, but not all devices support it
		 */
		private static var support4096Textures:Boolean=false;
		private static var maxAtlasSize:uint;
		private static var saveName:String;
		
		/**
		 * the newly created atlas XML, can be accessed to save to disk
		 */
		public static var finalXML:String;
		/**
		 * the newly create atlas image bitmapdata, can be accessed to save to disk
		 */
		public static var finalAtlas:BitmapData;
		/**
		 * This AS3 Signal is dispatched on completion of texture creation or failure. Add a listener to this.
		 */
		public static var creationComplete:Signal=new Signal();
		
		/**
		 * Starts the creation of the scaled textures, packs them into a single texture, creates textures out of it & 
		 * loads into a default starling AssetManager instance
		 * 
		 * @param sourceBitmapData : 2048 based texture atlas image
		 * @param atlasXml : 2048 based texture atlas xml
		 * @param scale : the ratio to scale to. cannot be above 1 (will be set to 1) eg, for 1024 based textures, scale will be 0.5
		 * @param assetManager : the Starling AssetManager instance onto which the created textures are stored
		 * 
		 * An AS3 signal, 'creationComplete' is dispatched when the conversion is complete.
		 */
		public static function createFrom(sourceBitmapData:BitmapData, atlasXml:XML, scale:Number, assetManager:AssetManager, atlasName:String):void{
			gameAtlas=new Dictionary();
			lookup=new Dictionary();
			scaleRatio=scale;
			trace("creating dynamic scaled textures, scale:",scaleRatio);
			if(scaleRatio>1){
				scaleRatio=1;
			}
			if(useTextureFrames){
				originalXML=atlasXml;
			}
			assets=assetManager;
			saveName=atlasName;
			totalTextures = atlasXml.SubTexture.length();   
			var name:String;  
			var x:int;  
			var y:int;  
			var width:int;  
			var height:int;  
			var frameX:int;
			var frameY:int;
			var frameWidth:int;
			var frameHeight:int;
			var bData:BitmapData;
			var pt:Point=new Point(0,0);
			var clipping:Rectangle=new Rectangle();
			
			for (var i:int = 0; i < totalTextures; i++) {  
				name = atlasXml.SubTexture[i].@name;  
				x = atlasXml.SubTexture[i].@x;  
				y = atlasXml.SubTexture[i].@y;  
				width = atlasXml.SubTexture[i].@width;  
				height = atlasXml.SubTexture[i].@height;  
				
				//create source rectangle for each individual texture  
				frameX=atlasXml.SubTexture[i].@frameX;
				frameY=atlasXml.SubTexture[i].@frameY;
				frameWidth=atlasXml.SubTexture[i].@frameWidth;
				frameHeight=atlasXml.SubTexture[i].@frameHeight;
				
				clipping = new Rectangle(x, y, width, height); 
				pt.x=pt.y=0;
				
				if(!useTextureFrames && frameWidth!=0 && frameHeight!=0){
					bData=new BitmapData(frameWidth,frameHeight,true,0x000000);
					pt.x=-1*frameX;
					pt.y=-1*frameY;
				}else{
					bData=new BitmapData(clipping.width,clipping.height,true,0x000000);
				}
				bData.copyPixels(sourceBitmapData,clipping,pt);
				//add to dictionary  
				if((bData.width==1&&bData.height==1) || (scaleRatio>0.49 && int(atlasXml.SubTexture[i].@originalScale)==1024)){//skip the oves with 1024 scale
					//this is just saving a pixel for representing a rectangle with that pixel
					gameAtlas[name] =resampleBitmapData(bData,1/scaleRatio);//scaleBitmapData(bData,1/scaleRatio);
				}else if(int(atlasXml.SubTexture[i].@originalScale)==1024){
					gameAtlas[name] =resampleBitmapData(bData,2);//scaleBitmapData(bData,2); 
				}else{
					gameAtlas[name] =resampleBitmapData(bData);//scaleBitmapData(bData); 
				} 
				
				bData.dispose();
				bData=null;
			} 
			/*
			System.disposeXML(atlasXml);
			atlasXml=null;
			sourceBitmapData.dispose();
			sourceBitmapData=null;
			*/
			if(support4096Textures){
				maxAtlasSize=9;
			}else{
				maxAtlasSize=7;
			}
			
			tryPacking();
		}
		
		
		private static function tryPacking():void{
			
			if (mPacker == null)
			{
				sizeIterator=1;
			}
			else
			{
				sizeIterator++;
			}
			newSize=findAtlasSize();
			mPacker=null;
			mPacker = new RectanglePacker(newSize.x, newSize.y, padding);
			trace("trying "+newSize);
			
			var rect:Rectangle;
			var rectIterator:uint=0;
			for(var j:String in gameAtlas){
				rect=(gameAtlas[j] as BitmapData).rect;
				mPacker.insertRectangle(rect.width, rect.height, rectIterator);
				lookup[rectIterator]=j;
				rectIterator++;
			}
			
			mPacker.packRectangles();
			
			trace(mPacker.rectangleCount," packed of ",totalTextures);
			if (mPacker.rectangleCount !=totalTextures)
			{
				if(sizeIterator<9){
					tryPacking();
				}else{
					trace("cannot pack into single 4096x4096 image");
					creationComplete.dispatch("failed");
				}
			}else{
				trace("packed into "+newSize.x+"x"+newSize.y);
				createAtlas();
			}
			
		}
		
		private static function createAtlas():void{
			finalXML='<?xml version="1.0" encoding="UTF-8"?>\n<TextureAtlas imagePath="'+saveName+scaleRatio.toString()+'.png">\n';
			finalAtlas=new BitmapData(newSize.x,newSize.y,true,0x000000);
			if(useTextureFrames){
				var list:XMLList=originalXML.SubTexture;
				var frameX:int;
				var frameY:int;
				var frameWidth:int;
				var frameHeight:int;
			}
			
			
			var mat:Matrix=new Matrix();
			for (var j:int = 0; j < mPacker.rectangleCount; j++)
			{
				var rect:Rectangle = new Rectangle();
				rect = mPacker.getRectangle(j, rect).clone();
				var index:int = mPacker.getRectangleId(j);
				mat.tx=rect.x;
				mat.ty=rect.y;
				
				if(useTextureFrames){
					frameX=int(list.(@name==lookup[index]).@frameX)*scaleRatio;
					frameY=int(list.(@name==lookup[index]).@frameY)*scaleRatio;
					frameWidth=int(list.(@name==lookup[index]).@frameWidth)*scaleRatio;
					frameHeight=int(list.(@name==lookup[index]).@frameHeight)*scaleRatio;
					
					if(frameWidth!=0 && frameHeight!=0){
						finalXML+=('<SubTexture name="'+lookup[index]+'" x="'+rect.x.toString()+'" y="'+rect.y.toString()+'" width="'+rect.width.toString()+'" height="'+rect.height.toString()+'" frameX="'+frameX.toString()+'" frameY="'+frameY.toString()+'" frameWidth="'+frameWidth.toString()+'" frameHeight="'+frameHeight.toString()+'"/>\n');
					}else{
						finalXML+=('<SubTexture name="'+lookup[index]+'" x="'+rect.x.toString()+'" y="'+rect.y.toString()+'" width="'+rect.width.toString()+'" height="'+rect.height.toString()+'"/>\n');
					}
				}else{
					finalXML+=('<SubTexture name="'+lookup[index]+'" x="'+rect.x.toString()+'" y="'+rect.y.toString()+'" width="'+rect.width.toString()+'" height="'+rect.height.toString()+'"/>\n');
				}
				finalAtlas.draw(gameAtlas[lookup[index]],mat);
				(gameAtlas[lookup[index]] as BitmapData).dispose();
				gameAtlas[lookup[index]]=rect;
			}
			finalXML+="</TextureAtlas>";
			//trace(finalXML);
			
			/*
			if(customAtlas){
			customAtlas.dispose();
			}
			customAtlas=Texture.fromBitmapData(finalAtlas,false);
			
			for (j = 0; j < totalTextures; j++)
			{
				
				assets.addTexture(lookup[j],Texture.fromTexture(customAtlas,gameAtlas[lookup[j]]));
			}
			
			//or
			
			var TA:TextureAtlas=new TextureAtlas(customAtlas,XML(finalXML));
			assets.addTextureAtlas("Atlas",TA);
			*/
			list=null;
			for(var i:String in gameAtlas){
				gameAtlas[i]=null;
				lookup[i]=null;
				delete gameAtlas[i];
				delete lookup[i];
			}
			gameAtlas=null;
			lookup=null;
			mPacker=null;
			
			
			creationComplete.dispatch("success");
			
		}
		private static function findAtlasSize():Point{
			var tmp:Point=new Point();
			switch(sizeIterator){
				case 1:
					tmp.y=tmp.x=256;
					break;
				case 2:
					tmp.y=256
					tmp.x=512;
					break;
				case 3:
					tmp.y=tmp.x=512;
					break;
				case 4:
					tmp.y=512
					tmp.x=1024;
					break;
				case 5:
					tmp.y=tmp.x=1024;
					break;
				case 6:
					tmp.y=1024
					tmp.x=2048;
					break;
				case 7:
					tmp.y=tmp.x=2048;
					break;
				case 8:
					tmp.y=2048;
					tmp.x=4096;
					break;
				case 9:
					tmp.y=tmp.x=4096;
					break;
			}
			return tmp;
		}
		private static function scaleBitmapData(ARG_object:BitmapData, ratio:Number):BitmapData {
			// create a BitmapData object the size of the crop
			var bmpd:BitmapData = new BitmapData(Math.round(ARG_object.width * ratio), 
				Math.round(ARG_object.height * ratio),true,0x000000);
			// create the matrix that will perform the scaling
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(ratio, ratio);
			var colorTransform:ColorTransform = new ColorTransform();
			// draw the object to the BitmapData, applying the matrix to scale
			bmpd.draw( ARG_object, scaleMatrix ,colorTransform,null,null,true);
			ARG_object.dispose();
			ARG_object=null;
			return bmpd;
		}
		/**
		 * This function fixes scaling artifacts when scaling down by progressively scaling by 50%
		 * http://bloomfoundry.com/blog/2010/11/17/reducing_artifacts_when_resizing_transparent_pngs_in_as3/
		 */
		private static function resampleBitmapData (bmp:BitmapData, forcedAlter:Number=1):BitmapData {
			if (scaleRatio >= 1) {
				return (scaleBitmapData(bmp,scaleRatio*forcedAlter));
			}
			else {
				var bmpData:BitmapData 	= bmp.clone();
				var appliedRatio:Number = 1;
				
				do {
					if (scaleRatio*forcedAlter < 0.5 * appliedRatio) {
						bmpData = scaleBitmapData(bmpData, 0.5);
						appliedRatio = 0.5 * appliedRatio;
					}
					else {
						bmpData = scaleBitmapData(bmpData, scaleRatio*forcedAlter / appliedRatio);
						appliedRatio = scaleRatio*forcedAlter;
					}
				} while (appliedRatio != scaleRatio*forcedAlter);
				
				return (bmpData);
			}
		}
		/**
		 * Call this to dispose off the dynamically created Atlas BitmapData & 
		 * XML data store. Can be done once they are saved to disk or once creationComplete is dispatched
		 */
		public static function dispose():void{
			if(useTextureFrames){
				System.disposeXML(originalXML);
			}
			finalAtlas.dispose();
			finalAtlas=null;
			finalXML=null;
			System.pauseForGCIfCollectionImminent(0.8);
			System.gc();
		}
	}
}