package com.csharks.flagdefense
{
	import com.csharks.juwalbose.CustomAnimatedItem;
	
	
	public class Dice extends CustomAnimatedItem
	{
		public var value:uint=1;
		public var settled:Boolean=false;
		public function Dice(_scaleRatio:Number=1)
		{
			super("dice",205*_scaleRatio,170*_scaleRatio,4,0.05);
			this.setLabels(new Array(["roll",4]));
			this.state="roll";
			settled=false;
			
		}
		
		public function settleWithResult(result:uint=0):uint{
			if(result==0){
				value=1+int(Math.random()*6);
			}else{
				value=result;
			}
			
			settled=true;
			return value;
		}
		public function startRolling():void{
			this.state="roll";
			settled=false;
			value=0;
			gotoAndPlay(state);
		}
		protected override function getNewFrame():void{
			if(settled){
				var paddedStr:String=value.toString();
				newFrame=imageName+paddedStr;
				stopped=true;
			}else{
				super.getNewFrame();
			}
			
		}
	}
}