package com.csharks.flagdefense.helpers
{
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class SkeletonScene extends DisplayObjectContainer
	{
		public function SkeletonScene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function backButtonPressed():void{
			
		}
	}
}