package com.csharks.flagdefense
{
	import com.csharks.juwalbose.CustomIsometricCharacter;
	import com.csharks.juwalbose.IsoHelper;
	
	import flash.geom.Point;
	
	import starling.events.Event;
	
	
	public class Soldier extends CustomIsometricCharacter
	{
		private var speed:int=70;
		public var path:Array=new Array();
		public var isAI:Boolean=false;
		private var destination:Point=new Point(-1,-1);
		private var pathIndex:uint;
		
		public function Soldier(_tileWidth:Number,_spawnPoint,_screenOffset:Point,isBlue:Boolean=false)
		{
			isAI=isBlue;
			var color:String="green";
			if(isAI){
				color="blue";
			}
			pathIndex=0;
			super("soldier_"+color,54,68,_tileWidth,_spawnPoint,new Point(-54,-68),2,0.08,true);
			this.setLabels(new Array(["walk",6]));
			this.screenOffset=_screenOffset;
			this.state="walk";
			//this.walking=true;
			this.gotoAndPlay(this.state+"_"+this.facing);
			//this.animationComplete.add(animDone);
			addEventListener("animationComplete", animDone);
		}
		private function animDone(e:Event):void{
			//trace(e.data);
			
		}
		public function markDestination():void{
			pathIndex++;
			if(pathIndex==path.length){
				this.walking=false;
				pathIndex=0;
			}else{
				this.destination=path[pathIndex];
				findDirection();
				this.walking=true;
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
			destination=IsoHelper.get2dFromTileIndices(destination,twoDTileWidth);
			destination.x+=offsetPoint.x+twoDTileWidth/2;
			destination.y+=offsetPoint.y+twoDTileWidth/2;
		}
		public function move(delta:Number):void{
			if(this.state=="walk"){
				//this.walking=true;
			}
			
			if(this.walking)//&&checkWalkable())
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
				if(Point.distance(destination,paintPoint2D)<3){
					this.paintPoint2D=destination;
					markDestination();
				}
			}
		}
		
		
	}
}