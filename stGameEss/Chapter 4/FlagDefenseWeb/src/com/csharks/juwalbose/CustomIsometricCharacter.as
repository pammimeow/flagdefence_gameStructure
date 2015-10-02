package com.csharks.juwalbose
{
	import flash.geom.Point;

	public class CustomIsometricCharacter extends CustomAnimatedItem
	{
		public var idleOffset:uint=0;
		
		public var facing:String="down";
		
		public var walking:Boolean=false;
		public var acting:Boolean=false;
		protected var twoDTileWidth:Number;
		
		public var paintPoint:Point=new Point();
		public var offsetPoint:Point=new Point();
		public var paintPoint2D:Point=new Point();
		public var paintPointIso:Point=new Point();
		public var screenOffset:Point=new Point();
		
		private var _showGrid:Boolean;
		
		public function CustomIsometricCharacter(_imageName:String,tWidth:Number,tHeight:Number,_twoDTileWidth:Number, _paintPoint:Point=null,_offsetPoint:Point=null,_padding:uint=0,framesToHold:Number=0.1,dispathSignal:Boolean=false)
		{
			twoDTileWidth=_twoDTileWidth;
			if(_offsetPoint){
				offsetPoint=_offsetPoint;
			}
			if(_paintPoint){
				updatePaintPoint(_paintPoint);
			}
			super(_imageName, tWidth, tHeight, _padding, framesToHold, dispathSignal);
		}
		public function updatePaintPoint(pt:Point):void{
			paintPoint.x=pt.x//.copyFrom(pt);
			paintPoint.y=pt.y;
			paintPoint2D=IsoHelper.get2dFromTileIndices(paintPoint,twoDTileWidth);
			paintPoint2D.x+=offsetPoint.x+twoDTileWidth/2;;
			paintPoint2D.y+=offsetPoint.y+twoDTileWidth/2;;
		}
		public override function update(delta:Number):void{
			paintPointIso=IsoHelper.cartToIso(paintPoint2D);
			//paintPointIso.add(screenOffset);
			paintPointIso.x+=screenOffset.x;
			paintPointIso.y+=screenOffset.y;
			paintPoint=IsoHelper.getTileIndices(new Point(paintPoint2D.x-offsetPoint.x,paintPoint2D.y-offsetPoint.y),twoDTileWidth);
			super.update(delta);
		}
		protected override function getNewFrame():void{
			var paddedStr:String=currentFrame.toString();
			
			if(padding>0){
				var mux:uint=1;
				for(var i:uint=0;i<padding;i++){
					mux*=10;
				}
				paddedStr=(mux+currentFrame).toString();
				paddedStr=paddedStr.substr(1,paddedStr.length-1);
			}
			newFrame=imageName+"_"+state+"_"+facing+"_"+paddedStr;
			
		}
		public override function gotoAndIdle(index:String):void{
			stopped=false;
			currentLabel=index;
			currentFrame=1;
			currentFrame+=idleOffset;
			dispathSignal=false;
			update(frameHold);
			stopped=true;
		}
		
	}
}