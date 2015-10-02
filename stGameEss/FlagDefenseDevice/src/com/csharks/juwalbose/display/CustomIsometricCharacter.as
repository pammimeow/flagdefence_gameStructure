package com.csharks.juwalbose.display
{
	import flash.geom.Point;
	import com.csharks.juwalbose.helpers.IsoHelper;

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
		
		protected var subState:String="";
		
		private var _showGrid:Boolean;
		
		public function CustomIsometricCharacter(_imageName:String,tWidth:Number,tHeight:Number,_twoDTileWidth:Number, _paintPoint:Point=null,_offsetPoint:Point=null,_padding:uint=0,framesToHold:Number=0.1,dispathSignal:Boolean=false)
		{
			_state="walk"
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
			paintPoint.x=pt.x;//.copyFrom(pt);
			paintPoint.y=pt.y;
			paintPoint2D=IsoHelper.get2dFromTileIndices(paintPoint,twoDTileWidth);
			paintPoint2D.x+=(twoDTileWidth/2);
			paintPoint2D.y+=(twoDTileWidth/2);
		}
		public override function update(delta:Number):void{
			paintPointIso=IsoHelper.cartToIso(paintPoint2D);
			paintPointIso.x+=screenOffset.x+offsetPoint.x;
			paintPointIso.y+=screenOffset.y+offsetPoint.y;
			paintPoint=IsoHelper.getTileIndices(new Point(paintPoint2D.x,paintPoint2D.y),twoDTileWidth);
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
			newFrame=imageName+"_"+subState+state+"_"+facing+"_"+paddedStr;
			//trace("nf",imageName,state,facing,paddedStr,newFrame);
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