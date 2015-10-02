package com.csharks.juwalbose
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;
	
	public class CustomAnimatedItem extends Image
	{
		protected var frameHold:Number;
		private var frameCounter:Number=0;
		public var animationComplete:Signal=new Signal();
		protected var dispathSignal:Boolean;
		private var srcRect:Rectangle;
		private var destPoint:Point=new Point(0,0);
		protected var frameLabelsEnd:Dictionary;
		public var currentLabel:String;
		public var stopped:Boolean;
		public var currentFrame:uint;
		private var imageHeight:Number;
		private var imageWidth:Number;
		protected var totalFrames:uint;
		protected var newFrame:String;
		protected var _state:String="walk";
		private var matrix:Matrix=new Matrix();
		
		protected var imageName:String;
		protected var padding:uint;
		private var assetsManager:AssetManager;
		
		public function CustomAnimatedItem(_imageName:String,tWidth:Number,tHeight:Number, _padding:uint=0,framesToHold:Number=0.1,dispathSignal:Boolean=false)
		{
			assetsManager=ResourceManager.assets;
			this.smoothing=TextureSmoothing.NONE;
			
			imageWidth=tWidth;
			imageHeight=tHeight;
			stopped=false;
			this.dispathSignal=dispathSignal;
			frameHold=framesToHold;
			srcRect=new Rectangle(0,0,imageWidth,imageHeight);
			imageName=_imageName;
			padding=_padding;
			currentFrame=1;
			
			super(Texture.empty(imageWidth,imageHeight));
			
			update(frameHold);
			this.touchable=false;
		}
		public function update(delta:Number):void{
			if(!stopped){
				frameCounter+=delta;
				if(frameCounter<frameHold){
					return;
				}
				currentFrame++;
			}
			frameCounter=0;
			if(currentFrame>totalFrames){
				currentFrame=1;
				if(dispathSignal){
					animationComplete.dispatch(this);
				}
				
			}
			getNewFrame();
			paintBg(newFrame);
			
		}
		protected function getNewFrame():void{
			var paddedStr:String=currentFrame.toString();
			if(padding>0){
				var mux:uint=1;
				for(var i:uint=0;i<padding;i++){
					mux*=10;
				}
				paddedStr=(mux+currentFrame).toString();
				paddedStr=paddedStr.substr(1,paddedStr.length-1);
			}
			newFrame=imageName+paddedStr;
		}
		private function paintBg(brush:String):void{
			this.texture=assetsManager.getTexture(brush);
		}
		public function gotoAndPlay(index:String):void{
			stopped=false;
			if(!dispathSignal){
				dispathSignal=true;
			}
			currentLabel=index;
			currentFrame=1;
			
		}
		public function gotoAndStop(index:*):void{
			stopped=false;
			var exampleType:Class = Object(index).constructor;
			if(exampleType == String){
				currentLabel=index;
				currentFrame=1;
			}else{
				currentFrame=index-1;
			}
			dispathSignal=false;
			update(frameHold);
			stopped=true;
			
		}
		public function gotoAndIdle(index:String):void{
			stopped=false;
			currentLabel=index;
			currentFrame=1;
			//currentFrame+=idleOffset;
			dispathSignal=false;
			update(frameHold);
			stopped=true;
		}
		public function setLabels(labelArray:Array):void{
			frameLabelsEnd=new Dictionary();
			for(var i:uint=0;i<labelArray.length;i++){
				frameLabelsEnd[labelArray[i][0]]=labelArray[i][1];
			}
		}
		public function destroy():void{
			
			this.dispose();
			
		}
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			totalFrames=frameLabelsEnd[state];
		}
	}
}