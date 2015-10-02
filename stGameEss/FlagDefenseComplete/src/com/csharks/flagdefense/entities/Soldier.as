package com.csharks.flagdefense.entities
{
	import com.csharks.flagdefense.AiStates;
	import com.csharks.juwalbose.display.CustomIsometricCharacter;
	import com.csharks.juwalbose.helpers.IsoHelper;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.geom.Point;
	
	import starling.events.Event;
	
	
	public class Soldier extends CustomIsometricCharacter
	{
		private var speed:int=90;
		public var path:Array=new Array();
		public var isAI:Boolean=false;
		private var destination:Point=new Point(-1,-1);
		private var pathIndex:uint;
		
		private var _hasBlueFlag:Boolean;
		private var _hasGreenFlag:Boolean;
		public var isOnNewTile:Boolean;
		public var nextTile:Point=new Point(-1,-1);
		public var isDead:Boolean=false;
		private var frozen:Boolean;
		
		public var aiDestination:Point=new Point();
		public var aiState:uint=AiStates.UNDETERMINED;
		
		public function Soldier(_tileWidth:Number,_spawnPoint,_screenOffset:Point,isBlue:Boolean=false)
		{
			isAI=isBlue;
			frozen=isDead=isOnNewTile=hasBlueFlag=hasGreenFlag=false;
			
			var color:String="green";
			if(isAI){
				color="blue";
			}
			pathIndex=0;
			
			super("soldier_"+color,81,83,_tileWidth,_spawnPoint,new Point(1,-66),2,0.1,true);//offset is -5,-57(the image leg point to centre 80x40) if there is no 2D tw/2 offsets
			this.screenOffset=_screenOffset;
			this.setLabels(new Array(
				["walk",6],["idle",2],["blueflagidle",2],
				["greenflagidle",2],["attack",12],["die",5],
				["blueflagwalk",6],["blueflagattack",6],
				["greenflagwalk",6],["greenflagattack",6]));
			this.state="idle";
			/*
			if(isAI){
				subState="blueflag";
			}else{
				subState="greenflag";
			}*/
			this.gotoAndPlay(this.state+this.subState+"_"+this.facing);
			//this.animationComplete.add(animDone);
			addEventListener("animationComplete", animDone);
			
		}
		
		private function animDone(e:Event):void
		{
			if(state=="die"){
				ResourceManager.playSound("DieSfx");
				stopped=true;
				isDead=true;
			}else if(state=="attack"){
				ResourceManager.playSound("SwordSfx");
			}
		}
		
		public function markDestination():void{
			pathIndex++;
			isOnNewTile=true;
			if(pathIndex==path.length){
				this.walking=false;
				state="idle";
				pathIndex=0;
				nextTile.x=nextTile.y=-1;
			}else{
				//isOnNewTile=true;
				this.destination=path[pathIndex];
				findDirection();
				this.walking=true;
				state="walk";
			}
			
		}
		private function findDirection():void{
			if(Math.abs(paintPoint.x-destination.x)==0){
				if(paintPoint.y>destination.y){
					facing="up";
				}else if(paintPoint.y<destination.y){
					facing="down";
				}
			}else if(Math.abs(paintPoint.y-destination.y)==0){
				if(paintPoint.x>destination.x){
					facing="left";
				}else if(paintPoint.x<destination.x){
					facing="right";
				}
			}
			//isOnNewTile=true;
			nextTile=destination.clone();
			destination=IsoHelper.get2dFromTileIndices(destination,twoDTileWidth);
			destination.x+=twoDTileWidth/2;
			destination.y+=twoDTileWidth/2;
		}
		public function action(delta:Number):void{
			if(isDead || frozen){
				return;
			}
			
			if(this.walking)
			{
				switch(this.facing){
					case "down":
						this.paintPoint2D.y+=speed*delta;
						break;
					case "up":
						this.paintPoint2D.y-=speed*delta;
						break;
					case "left":
						this.paintPoint2D.x-=speed*delta;
						break;
					case "right":
						this.paintPoint2D.x+=speed*delta;
						break;
				}
				if(Point.distance(destination,paintPoint2D)<6){
					this.paintPoint2D=destination;
					markDestination();
				}
			}
		}
		
		public function get hasBlueFlag():Boolean
		{
			return _hasBlueFlag;
		}
		
		public function set hasBlueFlag(value:Boolean):void
		{
			_hasBlueFlag = value;
			if(value){
				subState="blueflag";
			}else{
				subState="";
			}
		}
		
		public function get hasGreenFlag():Boolean
		{
			return _hasGreenFlag;
		}
		
		public function set hasGreenFlag(value:Boolean):void
		{
			_hasGreenFlag = value;
			if(value){
				subState="greenflag";
			}else{
				subState="";
			}
		}
		
		
		public function actOnSpot(id:String):void
		{
			frozen=true;
			state=id;
		}
		public function unfreeze():void
		{
			frozen=false;
		}
		public function face(direction:String):void
		{
			switch(direction){
				case "down":
					this.facing="up";
					break;
				case "up":
					this.facing="down";
					break;
				case "left":
					this.facing="right";
					break;
				case "right":
					this.facing="left";
					break;
			}
		}
		public override function set state(value:String):void
		{
			_state = value;
			totalFrames=frameLabelsEnd[subState+state];
			if(value=="die"){
				subState="";
			}
		}
		
	}
}