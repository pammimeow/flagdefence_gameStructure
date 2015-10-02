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
	import starling.textures.RenderTexture;
	import starling.utils.AssetManager;
	
	public class WorldLayer extends RenderTexture
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
		
		public function WorldLayer(width:int, height:int,_tileWidth:Number,_screenOffset:Point)
		{
			super(width, height);
			tileWidth=_tileWidth;
			screenOffset=_screenOffset;
			overlayArray=LevelUtils.overlayArray;
			rows=overlayArray.length;
			cols=overlayArray[0].length;
			assetsManager=ResourceManager.assets;
			
			regPoints=new Dictionary();
			mat=new Matrix();
			
			greenSoldiers= new Vector.<Soldier>();
			blueSoldiers= new Vector.<Soldier>();
			greenBombs=new Vector.<Bomb>();
			blueBombs=new Vector.<Bomb>();
			explosions= new Vector.<Explosion>();
			
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
			
			aiManager=new AiManager(greenSoldiers,blueSoldiers,greenBombs,blueBombs,explosions,tileWidth,screenOffset);
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
		private function paintImage(id:String,i:uint,j:uint):void{
			pt.x=j*tileWidth;
			pt.y=i*tileWidth;
			pt=IsoHelper.cartToIso(pt);
			img=new Image(assetsManager.getTexture(id.split(".")[0]));
			img.x=pt.x+screenOffset.x;
			img.y=pt.y+screenOffset.y;
			if(regPoints[id]!=null){
				img.x+=(regPoints[id].x);
				img.y-=(regPoints[id].y);
			}
			draw(img);
		}
		/**
		 * Draw world layer. Step the AI manager. 
		 * @param delta
		 * @param _img
		 * 
		 */
		public function render(delta:Number,_img:Image):void{
			aiManager.step(delta);
			
			this.clear();
			this.drawBundled(function():void
			{
				draw(_img);
				for(var i:int=0;i<rows;i++){
					for(var j:int=0;j<cols;j++){
						//draw overlay
						if(overlayArray[i][j]!="*"){
							paintImage(overlayArray[i][j],i,j);
						}else{
							if(aiManager.greenFlagAtCastle && (j==greenFlagPt.x && i==greenFlagPt.y)){
								paintImage("flaggreen.png",i,j);
							}else if(aiManager.blueFlagAtCastle && (j==blueFlagPt.x && i==blueFlagPt.y)){
								paintImage("flagblue.png",i,j);
							}
						}
						for(var id:String in greenSoldiers){
							character=greenSoldiers[id];
							if(character.paintPoint.x==j&&character.paintPoint.y==i){
								mat.tx=character.paintPointIso.x;
								mat.ty=character.paintPointIso.y;
								draw(character,mat);
							}
						}
						for(id in blueSoldiers){
							character=blueSoldiers[id];
							if(character.paintPoint.x==j&&character.paintPoint.y==i){
								mat.tx=character.paintPointIso.x;
								mat.ty=character.paintPointIso.y;
								draw(character,mat);
							}
						}
						for(id in greenBombs){
							aBomb=greenBombs[id];
							if(aBomb.paintPoint.x==j&&aBomb.paintPoint.y==i){
								mat.tx=aBomb.paintPointIso.x;
								mat.ty=aBomb.paintPointIso.y;
								draw(aBomb,mat);
							}
						}
						for(id in blueBombs){
							aBomb=blueBombs[id];
							if(aBomb.paintPoint.x==j&&aBomb.paintPoint.y==i){
								mat.tx=aBomb.paintPointIso.x;
								mat.ty=aBomb.paintPointIso.y;
								draw(aBomb,mat);
							}
						}
						for(id in explosions){
							explosion=explosions[id];
							if(explosion.paintPoint.x==j&&explosion.paintPoint.y==i){
								mat.tx=explosion.paintPointIso.x;
								mat.ty=explosion.paintPointIso.y;
								draw(explosion.s,mat);
								draw(explosion.f,mat);
							}
						}
					}
				}
				
			});
		}
		public override function dispose():void{
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
			super.dispose();
		}
	}
}