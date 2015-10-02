package com.csharks.juwalbose
{
	import starling.events.Event;
	
	public class GameEvent extends Event
	{
		public static const CONTROL_TYPE:String = "gamecontrol";
		public var command:String;
		public function GameEvent(command:String) 
		{
			super(CONTROL_TYPE,true);
			this.command = command;
		}
	}
}