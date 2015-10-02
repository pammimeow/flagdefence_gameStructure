package com.csharks.juwalbose.events
{
	
	import starling.events.Event
	/**
	 * Usage
	 * dispatchEvent(new EventType("TYPE_NAME",false,false,"arg1","arg2"));
		*****************************
		addEventListener("TYPE_NAME", onHandler);
		
		function onHandler(e:EventType) {
			trace(e.arg[0]);
		}

	 * 
	 * */
	public class EventType extends Event {
		// Properties
		public var arg:*;
		// Constructor
		public function EventType(type:String, bubbles:Boolean = false, cancelable:Boolean = false, ... a:*) {
			super(type, bubbles, cancelable);
			arg = a;
		}
		
	}
	
}