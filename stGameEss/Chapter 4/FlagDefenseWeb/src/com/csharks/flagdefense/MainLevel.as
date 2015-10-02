package com.csharks.flagdefense
{
	import com.csharks.juwalbose.GameEvent;
	import com.csharks.juwalbose.IsoHelper;
	import com.csharks.juwalbose.ResourceManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import libs.PathFinder.PathFinder;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;
	
	public class MainLevel extends DisplayObjectContainer
	{
		private var screenOffset:Point=new Point(490,-260);
		
		private var tileWidth:uint=40;/*isogrid tilewidth*/
		private var visibileTiles:Point=new Point(13,20);
		
		private var viewPort:Rectangle=new Rectangle(0,0,1024,768);
		
		private var character:Soldier;
		private var lastDraw:uint;
		private var diceAnim:Dice;
		private var gameUi:GameUi;
		
		private var worldLayer:WorldLayer;
		private var rTexImage:Image;
		private var groundLayer:GroundLayer;
		private var groundImage:Image;
		
		private const greenSpawnPt:Point=new Point(27,18);
		private const blueSpawnPt:Point=new Point(8,16);
		
		private var paintingPath:Boolean;
		
		private var assetsManager:AssetManager;
		private var uiTweening:Boolean=false;
		
		private var gameState:uint;
		private var soldiersWithPath:Vector.<Soldier>= new Vector.<Soldier>();
		
		private var infoText:TextField;
		
		public function MainLevel()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(GameEvent.CONTROL_TYPE,onGameEvent);
			
		}
		public function createLevel():void{
			assetsManager=ResourceManager.assets;
			paintingPath=false;
			uiTweening=false;
			worldLayer=new WorldLayer(viewPort.width,viewPort.height,tileWidth,screenOffset);
			rTexImage= new Image(worldLayer);
			addChildAt(rTexImage,0);
			
			rTexImage.blendMode=BlendMode.NONE;
			//rTexImage.touchable=false;
			rTexImage.smoothing=TextureSmoothing.NONE;
			
			rTexImage.x=viewPort.x;
			rTexImage.y=viewPort.y;
			
			var soldier:Soldier=new Soldier(tileWidth,greenSpawnPt,screenOffset);
			worldLayer.addSoldier(soldier);
			
			soldier=new Soldier(tileWidth,blueSpawnPt,screenOffset,true);
			worldLayer.addSoldier(soldier);
			
			groundLayer=new GroundLayer(viewPort.width,viewPort.height,tileWidth,screenOffset);
			groundLayer.drawGround();
			groundImage= new Image(groundLayer);
			
			for(var i:int=0;i<groundLayer.rows;i++){
				worldLayer.collisionArray[i]=new Array();
				for(var j:int=0;j<groundLayer.cols;j++){
					if(worldLayer.overlayArray[i][j]!="*"||groundLayer.groundArray[i][j]=="tile4.png"){
						worldLayer.collisionArray[i].push(1);
					}else{
						worldLayer.collisionArray[i].push(0);
					}
				}
			}
			
			diceAnim=new Dice(0.5);
			gameUi=new GameUi(0.5,diceAnim);
			addChild(gameUi);
			gameUi.x=stage.stageWidth/2-gameUi.width/2;
			gameUi.y=stage.stageHeight;
			
			var ttFont:String = "Ubuntu";
			var ttFontSize:int = 26; 
			
			infoText = new TextField(800, 100, 
				"Welcome", 
				ttFont, ttFontSize);
			infoText.x = stage.stageWidth/2-infoText.width/2;
			infoText.touchable=false;
			infoText.bold = true;
			infoText.nativeFilters=[new GlowFilter(0xffff00)];
			addChild(infoText);
			
			switchGameState(GameStates.GREEN_DICE);
			
			lastDraw=getTimer();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME,loop);
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function loop(e:EnterFrameEvent):void{
			Starling.juggler.advanceTime(e.passedTime);
			
			diceAnim.update(e.passedTime);
			worldLayer.render(e.passedTime,groundImage);
			if(gameState==GameStates.GREEN_MOVE && worldLayer.noneWalking()){
				clearPath();
				switchGameState(GameStates.BLUE_DICE);
			}else if(gameState==GameStates.BLUE_MOVE && worldLayer.noneWalking(true)){
				clearPath();
				switchGameState(GameStates.GREEN_DICE);
			}
		}
		private function onTouch(e:TouchEvent):void{
			var t:Touch=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t){
				if(!paintingPath&&t.tapCount==2){
					toggleUi();
				}
				paintingPath=false;
			}
			if(gameState != GameStates.GREEN_PATH && gameState!=GameStates.GREEN_PATHCOMPLETE){
				return;
			}
			
			t=e.getTouch(rTexImage,TouchPhase.BEGAN);
			if(t){
				var tp:Point=new Point(t.globalX,t.globalY);
				tp.x-=screenOffset.x;
				tp.y-=screenOffset.y;
				//image offset
				tp.x-=tileWidth;
				tp=IsoHelper.isoToCart(tp);
				tp=IsoHelper.getTileIndices(tp,tileWidth);
				character=worldLayer.hasASoldier(tp);
				if(character){
					groundLayer.repaintGround(character.path);
					paintingPath=true;
					character.path.splice(0,character.path.length);
					switchGameState(GameStates.GREEN_PATH);
				}
			}
			/*
			t=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t){
				paintingPath=false;
			}*/
			if(!paintingPath)
				return;
			if(character.path.length>diceAnim.value){
				paintingPath=false;
				switchGameState(GameStates.GREEN_PATHCOMPLETE);
				return;
			}
			t=e.getTouch(rTexImage,TouchPhase.MOVED);
			if(t){
				tp=new Point(t.globalX,t.globalY);
				tp.x-=screenOffset.x;
				tp.y-=screenOffset.y;
				//image offset
				tp.x-=tileWidth;
				tp=IsoHelper.isoToCart(tp);
				tp=IsoHelper.getTileIndices(tp,tileWidth);
				if(character.path.length!=0&&worldLayer.alreadyInPath(tp)){
					return;
				}
				if(isValidPosition(tp)){trace("push");
					groundLayer.paintGround(character.path,tp);
					character.path.push(tp);
					
				}else{trace("invlid");
					paintingPath=false;
					character=null;
				}
				
			}
			
			
			t=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t)
				paintingPath=false;
			
		}
		
		private function isValidPosition(tp:Point):Boolean{
			var retVal:Boolean=false;
			var newTp:Point;
			if(character.path.length==0){
				newTp=character.paintPoint;
			}else{
				newTp=character.path[character.path.length-1] as Point;
			}
			if(areNeighbours(newTp,tp))
				retVal= true;
			if(worldLayer.collisionArray[tp.y][tp.x]==1){
				retVal=false;}
			return retVal;
		}
		private function areNeighbours(newTp:Point,tp:Point):Boolean{
			var retVal:Boolean=false;
			if(Math.abs(newTp.x-tp.x)==0&&Math.abs(newTp.y-tp.y)<=1){
				retVal=true;
			}
			if(Math.abs(newTp.y-tp.y)==0&&Math.abs(newTp.x-tp.x)<=1){
				retVal=true;
			}
			return retVal;
		}
		private function switchGameState(newState:uint):void{
			switch (newState){
				case GameStates.BLUE_DICE:
					infoText.color = 0x0000ff;
					diceAnim.startRolling();
					showGameUi();
					Starling.juggler.delayCall(switchGameState,2,[GameStates.BLUE_DICESTOP]);
					showInfo("Blue's turn!");
					break;
				case GameStates.BLUE_DICESTOP:
					diceAnim.settleWithResult();
					Starling.juggler.delayCall(switchGameState,1,[GameStates.BLUE_PATH]);
					showInfo("Blue got "+diceAnim.value.toString());
					break;
				case GameStates.BLUE_PATH:
					showGameUi(true);
					drawAiPath();
					showInfo("Blue has path");
					break;
				case GameStates.BLUE_MOVE:
					worldLayer.startWalk(true);
					showInfo("Blue soldier is moving!");
					break;
				case GameStates.GREEN_DICE:
					diceAnim.startRolling();
					showGameUi();
					gameUi.toggleButtons(0,0,0,1);
					infoText.color = 0x009900;
					showInfo("Your turn! Tap dice to stop rolling");
					break;
				case GameStates.GREEN_PATH:
					if(!diceAnim.settled){
						diceAnim.settleWithResult();
					}
					gameUi.toggleButtons(0,0,0,0);
					showInfo("Your got "+diceAnim.value.toString()+"! Touch & drag from green soldier to mark path");
					
					//showGameUi(true);
					break;
				case GameStates.GREEN_PATHCOMPLETE:
					gameUi.toggleButtons(1,0,0,0);
					showGameUi();
					showInfo("Hit play to start moving! Touch & drag from green soldier again to redo path");
					break;
				case GameStates.GREEN_MOVE:
					gameUi.toggleButtons(0,0,0,0);
					worldLayer.startWalk();
					showGameUi(true);
					showInfo("Your soldier is moving! Double tap to show/hide UI");
					break;
				
			}
			gameState=newState;
		}
		private function drawAiPath():void{
			character=worldLayer.findAiSoldier();
			character.path.splice(0,character.path.length);
			character.path=PathFinder.go(character.paintPoint.x,character.paintPoint.y,greenSpawnPt.x,greenSpawnPt.y,worldLayer.collisionArray);
			character.path.reverse();
			character.path.splice(diceAnim.value+1);//trace("out",character.path);
			groundLayer.repaintGround(character.path,true);
			Starling.juggler.delayCall(switchGameState,1,[GameStates.BLUE_MOVE]);
		}
		private function clearPath():void{
			soldiersWithPath.splice(0,soldiersWithPath.length);
			worldLayer.findSoldiersWithPath(soldiersWithPath);
			
			for(var id:String in soldiersWithPath){
				character=soldiersWithPath[id];
				groundLayer.repaintGround(character.path);
			}
		}
		private function showInfo(info:String):void{
			infoText.text=info;
			infoText.x = stage.stageWidth/2-infoText.width/2;
		}
		private function showGameUi(hide:Boolean=false):void{
			uiTweening=true;
			TweenLite.killTweensOf(gameUi);
			if(hide){
				TweenLite.to(gameUi,0.5,{y:stage.stageHeight,ease:Back.easeIn,onComplete:tweenComplete});
			}else{
				TweenLite.to(gameUi,0.5,{y:645,ease:Back.easeOut,onComplete:tweenComplete});
			}
		}
		private function tweenComplete():void{
			uiTweening=false;
		}
		private function toggleUi():void{
			if(uiTweening){
				return;
			}
			if(gameUi.y<stage.stageHeight-gameUi.height/2){
				showGameUi(true);
			}else{
				showGameUi();
			}
		}
		private function onGameEvent(e:GameEvent):void{
			switch(e.command){
				case "dice":
					switchGameState(GameStates.GREEN_PATH);
					break;
				case "play":
					switchGameState(GameStates.GREEN_MOVE);
					break;
				case "bomb":
					break;
			}
		}
	}
}
