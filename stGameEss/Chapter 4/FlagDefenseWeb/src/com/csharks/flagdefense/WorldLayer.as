package com.csharks.flagdefense
{
	import com.csharks.juwalbose.IsoHelper;
	import com.csharks.juwalbose.ResourceManager;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.textures.RenderTexture;
	import starling.utils.AssetManager;
	
	public class WorldLayer extends RenderTexture
	{
		public var overlayArray:Array=[["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","tree1.png","tree2.png","bush3.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","bush1.png","*","tree2.png","bush3.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","bush1.png","*","*","*","*","bush3.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*","tree1.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*","*","tree1.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","tree2.png","*","*","*","*","*","*","*","*","*","*","tree4.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","tree2.png","*","*","*","*","*","*","*","tree1.png","*","*","*","*","tree4.png","*","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","bush3.png","*","*","*","*","*","*","*","*","tree2.png","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","bush1.png","*","*","*","*","*","tree3.png","*","*","*","tree2.png","*","*","*","rock1.png","*","*","tree5.png","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","bush3.png","*","*","*","*","*","*","*","*","*","*","tree2.png","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*","*","*","*"],
			["*","*","bush1.png","*","*","*","*","*","*","*","*","*","*","*","fence1.png","*","*","*","*","*","*","*","*","tree4.png","*","*","*","*","*","*","*","*","*"],
			["*","bush1.png","*","*","*","*","*","*","*","*","*","*","*","*","fence1.png","*","*","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*","*"],
			["tree1.png","tree2.png","*","*","*","*","*","*","*","tree5.png","*","*","*","*","fence1.png","*","*","*","*","*","*","*","*","*","*","tree2.png","*","*","*","*","*","*","*"],
			["*","bush3.png","tree2.png","*","*","*","*","*","castleblue2.png","*","*","*","*","*","fence1.png","*","*","*","*","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*"],
			["*","*","bush3.png","*","*","bush3.png","*","*","castleblue1.png","*","*","*","*","*","fence1.png","*","*","*","bush2.png","*","*","*","*","*","*","*","*","tree2.png","*","*","*","*","*"],
			["*","*","*","tree1.png","*","*","*","flagblue.png","*","rock1.png","*","*","*","*","fence1.png","*","*","*","*","*","*","*","*","*","*","*","*","castlegreen2.png","tree5.png","*","*","*","*"],
			["*","*","*","*","tree2.png","*","*","*","*","*","*","*","*","*","fence1.png","*","*","*","*","*","*","*","*","*","*","*","*","castlegreen1.png","*","tree5.png","*","*","*"],
			["*","*","*","*","*","tree1.png","*","*","*","*","*","*","*","*","fence1.png","*","*","*","*","*","tree3.png","*","*","*","*","tree2.png","flaggreen.png","*","*","*","tree6.png","*","*"],
			["*","*","*","*","*","*","rock1.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","tree3.png","*"],
			["*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","tree2.png","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","rock1.png","*","*","bush2.png","*","*","*","*","*","*","bush1.png","*","bush3.png","*","*","*","*","*","tree1.png","*","*"],
			["*","*","*","*","*","*","*","*","*","tree4.png","*","*","*","*","*","fence2.png","fence2.png","fence2.png","fence2.png","fence2.png","fence2.png","fence2.png","fence2.png","*","*","*","*","*","*","bush3.png","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","tree3.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","tree3.png","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","tree1.png","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","tree4.png","*","*","*","*","*","*","*","*","*","*","*","*","*","bush3.png","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","tree3.png","*","*","*","*","*","tree1.png","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","*","tree5.png","*","*","tree3.png","*","*","*","*","*","*","tree6.png","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*","tree3.png","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","bush1.png","*","*","*","*","*","bush1.png","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","bush3.png","*","*","*","tree2.png","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","tree5.png","tree2.png","tree5.png","*","*","*","*","*","*","*","*","*","*","*","*"],
			["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"]];
		
		public var collisionArray:Array=new Array();
		
		public var rows:uint;
		public var cols:uint;
		private var assetsManager:AssetManager;
		private var pt:Point=new Point();
		private var img:Image;
		private var tileWidth:Number;
		private var screenOffset:Point=new Point();
		private var regPoints:Dictionary=new Dictionary();
		private var character:Soldier;
		private var mat:Matrix=new Matrix();
		
		private var greenSoldiers:Vector.<Soldier>= new Vector.<Soldier>();
		private var blueSoldiers:Vector.<Soldier>= new Vector.<Soldier>();
		
		private var instance:WorldLayer = null;
		
		public function WorldLayer(width:int, height:int,_tileWidth:Number,_screenOffset:Point)
		{
			super(width, height);
			tileWidth=_tileWidth;
			screenOffset=_screenOffset;
			rows=overlayArray.length;
			cols=overlayArray[0].length;
			assetsManager=ResourceManager.assets;
			
			regPoints["bomb.png"]=new Point(26.5,-5.5);
			regPoints["bush1.png"]=new Point(9.5,21.5);
			regPoints["bush2.png"]=new Point(14,11);
			regPoints["bush3.png"]=new Point(11,18.5);
			regPoints["castleblue1.png"]=new Point(-24,162.5);
			regPoints["castleblue2.png"]=new Point(30,142.5);
			regPoints["castlegreen1.png"]=new Point(-25,162.5);
			regPoints["castlegreen2.png"]=new Point(30,142.5);
			regPoints["fence1.png"]=new Point(18.5,8.5);
			regPoints["fence2.png"]=new Point(18.5,8);
			regPoints["flagblue.png"]=new Point(32.5,42);
			regPoints["flaggreen.png"]=new Point(32,41.5);
			regPoints["rock1.png"]=new Point(1,21);
			regPoints["tree1.png"]=new Point(-5,89.5);
			regPoints["tree2.png"]=new Point(1,85);
			regPoints["tree3.png"]=new Point(-6,83.5);
			regPoints["tree4.png"]=new Point(-11,102);
			regPoints["tree5.png"]=new Point(2.5,82);
			regPoints["tree6.png"]=new Point(5.5,65);
		}
		public function addSoldier(soldier:Soldier):void{
			if(soldier.isAI){
				blueSoldiers.push(soldier);
			}else{
				greenSoldiers.push(soldier);
			}
		}
		public function hasASoldier(tp:Point):Soldier{
			var soldier:Soldier;
			for(var id:String in greenSoldiers){
				if(tp.equals(greenSoldiers[id].paintPoint)){
					soldier=greenSoldiers[id];
					break
				}
			}
			return soldier;
		}
		public function alreadyInPath(tp:Point):Boolean{
			var retVal:Boolean=false;
			var newTp:Point;
			for(var id:String in greenSoldiers){
				character=greenSoldiers[id];
				if(character.isAI){
					continue;
				}
				for(var i:int=0;i<character.path.length;i++){
					newTp=character.path[i] as Point;
					if(newTp.equals(tp)){
						retVal=true;
						break;
					}
				}
				if(retVal){
					break;
				}
			}
			return retVal;
		}
		public function findAiSoldier():Soldier{
			return blueSoldiers[0];
		}
		public function findSoldiersWithPath(soldiersWithPath:Vector.<Soldier>):void{
			for(var id:String in blueSoldiers){
				character=blueSoldiers[id];
				if(character.path.length>0){
					soldiersWithPath.push(character);
				}
			}
			for(id in greenSoldiers){
				character=greenSoldiers[id];
				if(character.path.length>0){
					soldiersWithPath.push(character);
				}
			}
		}
		public function noneWalking(isBlue:Boolean=false):Boolean{
			var retVal:Boolean=true;
			if(isBlue){
				for(var id:String in blueSoldiers){
					character=blueSoldiers[id];
					if(character.walking){
						retVal=false;
						break;
					}
				}
			}else{
				for(id in greenSoldiers){
					character=greenSoldiers[id];
					if(character.walking){
						retVal=false;
						break;
					}
				}
			}
			return retVal;
		}
		public function startWalk(isBlue:Boolean=false):void{
			if(isBlue){
				for(var id:String in blueSoldiers){
					character=blueSoldiers[id];
					if(character.path.length>0){
						//character.path.reverse();
						//character.path.pop();
						character.markDestination();
					}
				}
			}else{
				for(id in greenSoldiers){
					character=greenSoldiers[id];
					if(character.path.length>0){
						//character.path.reverse();
						//character.path.pop();
						character.markDestination();
						
					}
				}
			}
		}
		public function render(delta:Number,_img:Image):void{
			for(var id:String in greenSoldiers){
				character=greenSoldiers[id];
				character.move(delta);
				character.update(delta);
			}
			for(id in blueSoldiers){
				character=blueSoldiers[id];
				character.move(delta);
				character.update(delta);
			}
			this.clear();
			this.instance = this;
			this.drawBundled(function():void
			{
				instance.draw(_img);
				for(var i:int=0;i<rows;i++){
					for(var j:int=0;j<cols;j++){
						//draw overlay
						if(overlayArray[i][j]!="*"){
							pt.x=j*tileWidth;
							pt.y=i*tileWidth;
							pt=IsoHelper.cartToIso(pt);
							img=new Image(assetsManager.getTexture(String(overlayArray[i][j]).split(".")[0]));
							img.x=pt.x+screenOffset.x;
							img.y=pt.y+screenOffset.y;
							if(regPoints[overlayArray[i][j]]!=null){
								img.x+=(regPoints[overlayArray[i][j]].x);
								img.y-=(regPoints[overlayArray[i][j]].y);
							}
							instance.draw(img);
						}
						for(id in greenSoldiers){
							character=greenSoldiers[id];
							if(character.paintPoint.x==j&&character.paintPoint.y==i){
								mat.tx=character.paintPointIso.x;
								mat.ty=character.paintPointIso.y;
								instance.draw(character,mat);
							}
						}
						for(id in blueSoldiers){
							character=blueSoldiers[id];
							if(character.paintPoint.x==j&&character.paintPoint.y==i){
								mat.tx=character.paintPointIso.x;
								mat.ty=character.paintPointIso.y;
								instance.draw(character,mat);
							}
						}
					}
				}
				
			});
		}
		
	}
}