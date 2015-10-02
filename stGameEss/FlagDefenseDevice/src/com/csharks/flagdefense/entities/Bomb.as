package com.csharks.flagdefense.entities
{
	import com.csharks.juwalbose.display.CustomIsometricCharacter;
	import com.csharks.juwalbose.helpers.IsoHelper;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.geom.Point;
	
	public class Bomb extends CustomIsometricCharacter
	{
		private var speed:int;
		public var path:Array=new Array();
		public var isBlue:Boolean=false;
		private var destination:Point=new Point(-1,-1);
		private var pathIndex:uint;
		
		private var zValue:Number = 0;
		private var gravity:Number = -180;
		private var incrementValue:Number = 0;
		private var jumpMax:Number=-40;
		
		public var isOnNewTile:Boolean;
		public var exploded:Boolean;
		
		private var SR:Number;
		public function Bomb(_twoDTileWidth:Number, _paintPoint:Point=null, _screenOffset:Point=null,_isBlue:Boolean=false)
		{
			SR=ResourceManager.scaleRatio;
			speed=140*SR;
			gravity=-360*SR;
			jumpMax=-80*SR;
			
			pathIndex=0;
			isBlue=_isBlue;
			isOnNewTile=false;
			var color:String="green";
			if(isBlue){
				color="blue";
			}
			exploded=false;
			super(color+"bomb", 60*SR, 48*SR, _twoDTileWidth, _paintPoint, new Point(60*SR,-40*SR));
			
			this.screenOffset=_screenOffset;
			
			paintBg(color+"bomb");
		}
		public override function update(delta:Number):void{
			if(exploded){
				return;
			}
			incrementValue -=  gravity*delta;
			zValue -=  incrementValue*delta;
			if (zValue < 0)
			{
				zValue = 0;
				incrementValue = jumpMax;
			}
			
			paintPointIso=IsoHelper.cartToIso(paintPoint2D);
			paintPointIso.x+=screenOffset.x+offsetPoint.x;
			paintPointIso.y+=screenOffset.y+offsetPoint.y;
			paintPoint=IsoHelper.getTileIndices(new Point(paintPoint2D.x,paintPoint2D.y),twoDTileWidth);
			
			paintPointIso.y-=zValue;
		}
		public function markDestination():void{
			pathIndex++;
			isOnNewTile=true;
			if(pathIndex==path.length){
				this.walking=false;
				path.splice(0);
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
			destination.x+=twoDTileWidth/2;
			destination.y+=twoDTileWidth/2;
		}
		public function action(delta:Number):void{
			if(exploded){
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
				if(Point.distance(destination,paintPoint2D)<10*SR){
					this.paintPoint2D=destination;
					markDestination();
				}
			}
		}
		
	}
}