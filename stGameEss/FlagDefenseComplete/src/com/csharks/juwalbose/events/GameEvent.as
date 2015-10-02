package com.csharks.juwalbose.events
{
	import starling.events.Event;
	
	public class GameEvent extends Event
	{
		public static const CONTROL_TYPE:String = "gamecontrol";
		public var command:String;
		public var score:uint;
		public function GameEvent(command:String, score:uint=0) 
		{
			super(CONTROL_TYPE,true);
			this.command = command;
			this.score=score;
		}
	}
}