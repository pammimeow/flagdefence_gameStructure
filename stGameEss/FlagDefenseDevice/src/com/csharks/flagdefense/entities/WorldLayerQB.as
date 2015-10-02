package com.csharks.flagdefense.entities
{
	import com.csharks.flagdefense.helpers.AiManager;
	import com.csharks.flagdefense.helpers.LevelUtils;
	import com.csharks.juwalbose.helpers.IsoHelper;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.utils.AssetManager;
	
	public class WorldLayerQB
	{
		private var overlayArray:Array;
		
		private var rows:uint;
		private var cols:uint;
		private var assetsManager:AssetManager;
		private var pt:Point=new Point();
		private var img:Image;
		private var tileWidth:Number;
		private var screenOffset:Point=new Point();
		private var regPoints:Dictionary;
		private var character:Soldier;
		private var mat:Matrix;
		private var aBomb:Bomb;
		
		private var greenSoldiers:Vector.<Soldier>;
		private var blueSoldiers:Vector.<Soldier>;
		private var greenBombs:Vector.<Bomb>;
		private var blueBombs:Vector.<Bomb>;
		private var explosions:Vector.<Explosion>;
		
		public var aiManager:AiManager;
		
		private var greenFlagPt:Point;
		private var blueFlagPt:Point;
		private var explosion:Explosion;
		private var SR:Number;
		private var str:String;
		
		private var arrowArray:Array;
		private var drawDelay:Number=0.05;
		private var renderTime:Number;
		
		public var wlQb:QuadBatch;
		
		public function WorldLayerQB(_tileWidth:Number,_screenOffset:Point)
		{
			tileWidth=_tileWidth;
			screenOffset=_screenOffset;
			overlayArray=LevelUtils.overlayArray;
			rows=overlayArray.length;
			cols=overlayArray[0].length;
			assetsManager=ResourceManager.assets;
			SR=ResourceManager.scaleRatio;
			regPoints=new Dictionary();
			mat=new Matrix();
			arrowArray=LevelUtils.arrowArray;
			renderTime=drawDelay;
			img=new Image(assetsManager.getTexture("tile3"));
			wlQb=new QuadBatch();
			
			greenSoldiers= new Vector.<Soldier>();
			blueSoldiers= new Vector.<Soldier>();
			greenBombs=new Vector.<Bomb>();
			blueBombs=new Vector.<Bomb>();
			explosions= new Vector.<Explosion>();
			
			
			regPoints["bomb.png"]=new Point(53,-11);
			regPoints["bush1.png"]=new Point(19,43);
			regPoints["bush2.png"]=new Point(28,22);
			regPoints["bush3.png"]=new Point(22,37);
			regPoints["castleblue1.png"]=new Point(-48,325);
			regPoints["castleblue2.png"]=new Point(60,285);
			regPoints["castlegreen1.png"]=new Point(-50,325);
			regPoints["castlegreen2.png"]=new Point(60,285);
			regPoints["fence1.png"]=new Point(37,17);
			regPoints["fence2.png"]=new Point(37,16);
			regPoints["flagblue.png"]=new Point(65,84);
			regPoints["flaggreen.png"]=new Point(64,83);
			regPoints["rock1.png"]=new Point(2,42);
			regPoints["tree1.png"]=new Point(-10,179);
			regPoints["tree2.png"]=new Point(2,170);
			regPoints["tree3.png"]=new Point(-12,167);
			regPoints["tree4.png"]=new Point(-22,204);
			regPoints["tree5.png"]=new Point(5,164);
			regPoints["tree6.png"]=new Point(11,130);
			
			aiManager=new AiManager(greenSoldiers,blueSoldiers,greenBombs,blueBombs,explosions,tileWidth,screenOffset,this);
			greenFlagPt=aiManager.greenFlagPt;
			blueFlagPt=aiManager.blueFlagPt;
			
		}
		
		/**
		 * Draw the texture with name, at i,j 
		 * @param id
		 * @param i
		 * @param j
		 * 
		 */
		private function paintImage(i:uint,j:uint):void{
			pt.x=j*tileWidth;
			pt.y=i*tileWidth;
			pt=IsoHelper.cartToIso(pt);
			img.texture=assetsManager.getTexture(str.split(".")[0]);
			img.readjustSize();
			img.x=pt.x+screenOffset.x;
			img.y=pt.y+screenOffset.y;
			if(regPoints[str]!=null){
				img.x+=(regPoints[str].x*SR);
				img.y-=(regPoints[str].y*SR);
			}
			//draw(img);
			wlQb.addImage(img);
		}
		/**
		 * Draw world layer. Step the AI manager. 
		 * @param delta
		 * @param _img
		 * 
		 */
		public function render(delta:Number):void{
			aiManager.step(delta);
			/*renderTime+=delta;
			if(renderTime<drawDelay){
				return;
			}
			renderTime=0;*/
			var id:String;
			wlQb.reset();
				for(var i:int=0;i<rows;i++){
					for(var j:int=0;j<cols;j++){
						//draw overlay
						if(overlayArray[i][j]!="*"){
							str=overlayArray[i][j];
							paintImage(i,j);
						}else{
							if(arrowArray[i][j]!="*"){
								str=arrowArray[i][j];
								paintImage(i,j);
							}
							if(aiManager.greenFlagAtCastle && (j==greenFlagPt.x && i==greenFlagPt.y)){
								str="flaggreen.png";
								paintImage(i,j);
							}else if(aiManager.blueFlagAtCastle && (j==blueFlagPt.x && i==blueFlagPt.y)){
								str="flagblue.png";
								paintImage(i,j);
							}
						}
						for(id in greenSoldiers){
							character=greenSoldiers[id];
							if(character.paintPoint.x==j&&character.paintPoint.y==i){
								character.x=character.paintPointIso.x;
								character.y=character.paintPointIso.y;
								wlQb.addImage(character);
							}
						}
						for(id in blueSoldiers){
							character=blueSoldiers[id];
							if(character.paintPoint.x==j&&character.paintPoint.y==i){
								character.x=character.paintPointIso.x;
								character.y=character.paintPointIso.y;
								wlQb.addImage(character);							}
						}
						for(id in greenBombs){
							aBomb=greenBombs[id];
							if(aBomb.paintPoint.x==j&&aBomb.paintPoint.y==i){
								aBomb.x=aBomb.paintPointIso.x;
								aBomb.y=aBomb.paintPointIso.y;
								wlQb.addImage(aBomb);
							}
						}
						for(id in blueBombs){
							aBomb=blueBombs[id];
							if(aBomb.paintPoint.x==j&&aBomb.paintPoint.y==i){
								aBomb.x=aBomb.paintPointIso.x;
								aBomb.y=aBomb.paintPointIso.y;
								wlQb.addImage(aBomb);
							}
						}
						
					}
				}
				
			
		}
		
		public function paintGround(path:Array,tp:Point):void{
			if(path.length==0){
				arrowArray[tp.y][tp.x]="selectioncircle.png";
			}else{
				arrowArray[tp.y][tp.x]=getCorrectArrow(path,tp);
			}
		}
		private function getCorrectArrow(path:Array,tp:Point):String{
			var newTp:Point=path[path.length-1] as Point;
			return(getDirectionalArrow(newTp,tp));
		}
		private function getDirectionalArrow(newTp:Point,tp:Point):String{
			var dir:String;
			if(Math.abs(newTp.x-tp.x)==0){
				if(newTp.y>tp.y){
					dir="up";
				}else if(newTp.y<tp.y){
					dir="down";
				}
			}else if(Math.abs(newTp.y-tp.y)==0){
				if(newTp.x>tp.x){
					dir="left";
				}else if(newTp.x<tp.x){
					dir="right";
				}
			}
			return ("arrow"+dir+".png");
		}
		public function repaintGround(path:Array,withPath:Boolean=false):void{
			if(path.length==0){
				return;
			}
			for(var i:int=0;i<path.length;i++){
				if(withPath){
					if(i==0){
						arrowArray[path[i].y][path[i].x]="selectioncircle.png";
					}else{
						arrowArray[path[i].y][path[i].x]=getDirectionalArrow(path[i-1],path[i]);
					}
				}else{
					arrowArray[path[i].y][path[i].x]="*";
				}
				
			}
			
		}
		
		
		public function dispose():void{
			aiManager.dispose();
			
			for(var id:String in greenSoldiers){
				character=greenSoldiers[id];
				character.dispose();
			}
			for(id in blueSoldiers){
				character=blueSoldiers[id];
				character.dispose();
			}
			for(id in greenBombs){
				aBomb=greenBombs[id];
				aBomb.dispose();
			}
			for(id in blueBombs){
				aBomb=blueBombs[id];
				aBomb.dispose();
			}
			for(id in explosions){
				explosion=explosions[id];
				explosion.destroy();
			}
			greenSoldiers.splice(0,greenSoldiers.length);
			blueSoldiers.splice(0,blueSoldiers.length);
			greenBombs.splice(0,greenBombs.length);
			blueBombs.splice(0,blueBombs.length);
			explosions.splice(0,explosions.length);
			
			for(id in regPoints){
				delete regPoints[id];
			}
			img=null;
			character=null;
			aBomb=null;
			explosion=null;
			
			wlQb.reset();
			wlQb.dispose()
		}
	}
}