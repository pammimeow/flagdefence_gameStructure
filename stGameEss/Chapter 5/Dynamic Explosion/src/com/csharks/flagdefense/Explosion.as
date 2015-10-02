package com.csharks.flagdefense
{
	
	import com.csharks.juwalbose.ResourceManager;
	
	import flash.geom.Point;
	
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;

	public class Explosion
	{
		public var f:PDParticleSystem;
		public var s:PDParticleSystem;
		private var disposeCount:uint;
		public var paintPoint:Point=new Point();
		public var paintPointIso:Point=new Point();
		
		public var completed:Boolean;
		
		public function Explosion(tilePoint:Point,isoPoint:Point)
		{
			f = ResourceManager.flameFx;
			s = ResourceManager.smokeFx;
			
			paintPoint.copyFrom(tilePoint);
			paintPointIso.copyFrom(isoPoint);
			
			s.addEventListener("complete", removeS);
			f.addEventListener("complete", removeF);
			
			f.start(0.05);
			s.start(0.1);
			disposeCount=0;
			completed=false;
			
		}
		public function update(delta:Number):void{
			f.advanceTime(delta);
			s.advanceTime(delta);
		}
		private function removeS(event:Event=null):void
		{
			
			s.removeEventListener("complete", removeS);
			s.stop(true);
			disposeCount++;
			if(disposeCount==2){
				completed=true;
			}
		}
		private function removeF(event:Event=null):void
		{
			f.removeEventListener("complete", removeS);
			f.stop(true);
			disposeCount++;
			if(disposeCount==2){
				completed=true;
			}
		}
		
		public function destroy():void{
			if(f.hasEventListener("complete")){
				removeF();
			}
			if(s.hasEventListener("complete")){
				removeS();
			}
			f.dispose();
			s.dispose();
			s=null;
			f=null;
		}
		
	}
}