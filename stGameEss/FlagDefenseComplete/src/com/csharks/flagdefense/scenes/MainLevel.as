package com.csharks.flagdefense.scenes
{
	import com.csharks.flagdefense.AiDecisions;
	import com.csharks.flagdefense.GameStates;
	import com.csharks.flagdefense.entities.GroundLayer;
	import com.csharks.flagdefense.entities.Soldier;
	import com.csharks.flagdefense.entities.WorldLayer;
	import com.csharks.flagdefense.helpers.AiManager;
	import com.csharks.flagdefense.helpers.LevelUtils;
	import com.csharks.flagdefense.ui.Dice;
	import com.csharks.flagdefense.ui.GameUi;
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.helpers.IsoHelper;
	import com.csharks.juwalbose.utils.ResourceManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
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
		
		protected var tileWidth:uint=40;/*isogrid tilewidth*/
		private var visibileTiles:Point=new Point(13,20);
		
		private var viewPort:Rectangle=new Rectangle(0,0,1024,768);
		
		protected var character:Soldier;
		private var lastDraw:uint;
		protected var diceAnim:Dice;
		protected var gameUi:GameUi;
		
		private var worldLayer:WorldLayer;
		protected var rTexImage:Image;
		protected var groundLayer:GroundLayer;
		private var groundImage:Image;
		
		protected var paintingPath:Boolean;
		
		private var assetsManager:AssetManager;
		private var uiTweening:Boolean=false;
		
		protected var gameState:uint;
		
		protected var infoText:TextField;
		protected var aiManager:AiManager;
		protected var valueUsed:uint;
		
		private var aiDecision:uint;
		
		public function MainLevel()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(GameEvent.CONTROL_TYPE,onGameEvent);
			createLevel();
		}
		public function createLevel():void{
			assetsManager=ResourceManager.assets;
			paintingPath=false;
			uiTweening=false;
			
			LevelUtils.initialise();
			
			worldLayer=new WorldLayer(viewPort.width,viewPort.height,tileWidth,screenOffset);
			rTexImage= new Image(worldLayer);
			addChildAt(rTexImage,0);
			
			rTexImage.blendMode=BlendMode.NONE;
			//rTexImage.touchable=false;
			rTexImage.smoothing=TextureSmoothing.NONE;
			
			rTexImage.x=viewPort.x;
			rTexImage.y=viewPort.y;
			
			groundLayer=new GroundLayer(viewPort.width,viewPort.height,tileWidth,screenOffset);
			groundLayer.drawGround();
			groundImage= new Image(groundLayer);
			
			aiManager=worldLayer.aiManager;
			aiManager.groundLayer=groundLayer;
			aiManager.spawnSoldier();
			aiManager.spawnSoldier(true);
			
			addGameUi();
			
			if(Math.random()<0.5){
				switchGameState(GameStates.BLUE_BOMBS_MOVE);
			}else{
				switchGameState(GameStates.GREEN_BOMBS_MOVE);
			}
			
			
			lastDraw=0;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME,loop);
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private function addGameUi():void{
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
		}
		
		/**
		 * The main game loop, nothing much can be seen here, but this is the tip of an iceberg ;) 
		 * This also checks if all soldiers have moved, all bombs have moved
		 * Also checks for game win.
		 * @param e
		 * Investigate worldLayer.render()
		 */
		private function loop(e:EnterFrameEvent):void{
			Starling.juggler.advanceTime(e.passedTime);
			
			diceAnim.update(e.passedTime);
			worldLayer.render(e.passedTime,groundImage);
			lastDraw+=e.passedTime;
			if(gameState==GameStates.GREEN_MOVE && aiManager.noneWalking()){
				aiManager.clearPath();
				switchGameState(GameStates.BLUE_BOMBS_MOVE);
			}else if(gameState==GameStates.BLUE_MOVE && aiManager.noneWalking(true)){
				aiManager.clearPath();
				switchGameState(GameStates.GREEN_BOMBS_MOVE);
			}else if(gameState==GameStates.BLUE_BOMBS_MOVE && aiManager.noneHoming()){
				aiManager.clearPath();
				switchGameState(GameStates.BLUE_DICE);
			}else if(gameState==GameStates.GREEN_BOMBS_MOVE && aiManager.noneHoming(true)){
				aiManager.clearPath();
				switchGameState(GameStates.GREEN_DICE);
			}
			if(aiManager.blueWins){
				dispatchEvent(new GameEvent("bluewin",lastDraw/1000));
			}else if(aiManager.greenWins){
				dispatchEvent(new GameEvent("greenwin",lastDraw/1000));
			}
		}
		/**
		 * Touch drag draw handler for drawing paths for green soldiers 
		 * @param e
		 * 
		 */
		protected function onTouch(e:TouchEvent):void{
			var t:Touch=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t){
				if(!paintingPath&&t.tapCount==2){
					toggleUi();
				}
				paintingPath=false;
			}
			if(gameState!=GameStates.GREEN_PATH&&gameState!=GameStates.GREEN_PATHCOMPLETE){
				return;
			}
			
			t=e.getTouch(rTexImage,TouchPhase.BEGAN);
			if(t){
				var tp:Point=new Point(t.globalX,t.globalY);
				convertTouchPoint(tp);
				tp=IsoHelper.isoToCart(tp);
				tp=IsoHelper.getTileIndices(tp,tileWidth);
				character=aiManager.hasASoldier(tp);
				if(character){
					groundLayer.repaintGround(character.path);
					paintingPath=true;
					character.path.splice(0,character.path.length);
					switchGameState(GameStates.GREEN_PATH);
					aiManager.getUpdatedCollisionArray();
					updateValueUsed();
				}
			}
			/*
			t=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t){
			paintingPath=false;
			}*/
			if(!paintingPath)
				return;
			if(valueUsed==diceAnim.value){
				paintingPath=false;
				switchGameState(GameStates.GREEN_PATHCOMPLETE);
				return;
			}
			t=e.getTouch(rTexImage,TouchPhase.MOVED);
			if(t){
				tp=new Point(t.globalX,t.globalY);
				convertTouchPoint(tp);
				tp=IsoHelper.isoToCart(tp);
				tp=IsoHelper.getTileIndices(tp,tileWidth);
				if(character.path.length!=0&&aiManager.alreadyInPath(tp)){
					return;
				}
				if(isValidPosition(tp)){//trace("push");
					groundLayer.paintGround(character.path,tp);
					character.path.push(tp);
					
				}else{//trace("invlid");
					paintingPath=false;
					character=null;
				}
				updateValueUsed();
			}
			t=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t){
				paintingPath=false;
				updateValueUsed();
			}
			
		}
		protected function convertTouchPoint(tp:Point):void{
			tp.x-=screenOffset.x;
			tp.y-=screenOffset.y;
			//image offset
			tp.x-=tileWidth;
		}
		/**
		 * Check if this new point we touched is valid, neighbour to last point touched 
		 * @param tp
		 * @return 
		 * 
		 */
		protected function isValidPosition(tp:Point):Boolean{//touch drag helper for proper path drawing
			var retVal:Boolean=false;
			var newTp:Point;
			if(character.path.length==0){//trace("0");
				if(tp.equals(character.paintPoint)){
					return(true);
				}else{
					return(false);
				}
			}else{
				newTp=character.path[character.path.length-1] as Point;
			}
			trace("tp",tp,"pp",character.paintPoint,"newTp",newTp);
			
			if(aiManager.areNeighbours(newTp,tp)){
				retVal= true;
				if(!aiManager.isWalkable(tp)){//trace("not walkable",character.paintPoint,tp,newTp);
					retVal=false;
				}
			}else{
				//trace("not neighbour");
			}
			return retVal;
		}
		
		/**
		 * Game state switch 
		 * @param newState
		 * 
		 */
		protected function switchGameState(newState:uint):void{
			switch (newState){
				case GameStates.BLUE_BOMBS_MOVE:
					gameUi.toggleButtons(0,0,0,0,true);
					infoText.color = 0x0000ff;
					aiManager.moveBombs(true);
					break;
				case GameStates.GREEN_BOMBS_MOVE:
					infoText.color = 0x009900;
					aiManager.moveBombs();
					break;
				case GameStates.BLUE_DICE:
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
					aiDecision=aiManager.makeDecision(diceAnim.value);
					
					if(aiDecision==AiDecisions.WALK){
						showInfo("Blue has path");
						Starling.juggler.delayCall(switchGameState,1,[GameStates.BLUE_MOVE]);
					}else if(aiDecision==AiDecisions.SPAWN_BOMB){
						showInfo("Blue spawned a bomb!");
						aiManager.clearPath();
						aiManager.spawnBomb(true);
						Starling.juggler.delayCall(switchGameState,0.5,[GameStates.GREEN_BOMBS_MOVE]);
					}else if(aiDecision==AiDecisions.SPAWN_SOLDIER){
						showInfo("Blue spawned a soldier!");
						aiManager.clearPath();
						aiManager.spawnSoldier(true);
						Starling.juggler.delayCall(switchGameState,0.5,[GameStates.GREEN_BOMBS_MOVE]);
					}
					
					break;
				case GameStates.BLUE_MOVE:
					aiManager.startWalk(true);
					showInfo("Blue soldier is moving!");
					break;
				case GameStates.GREEN_DICE:
					diceAnim.startRolling();
					showGameUi();
					gameUi.toggleButtons(0,0,0,1);
					showInfo("Your turn! Tap dice to stop rolling");
					break;
				case GameStates.GREEN_PATH:
					gameUi.toggleButtons(0,0,0,0);
					if(!diceAnim.settled){
						diceAnim.settleWithResult();
					}
					if(!aiManager.isSpawnPointOccuppied()){
						if(diceAnim.value==1 && aiManager.soldiersInCastle()){
							gameUi.toggleButtons(0,0,1,0);
							showInfo("Green got 1! Create new soldier(3) or touch & drag to mark path");
						}else if(diceAnim.value==6 && aiManager.bombsInCastle()){
							gameUi.toggleButtons(0,1,0,0);
							showInfo("Grren got 6! Create a homing bomb(2) or touch & drag to mark path");
						}else{
							showInfo("Green got "+diceAnim.value.toString()+"! Touch & drag from green soldier to mark path");
						}
					}else{
						showInfo("Green got "+diceAnim.value.toString()+"! Touch & drag from green soldier to mark path");
					}
					//showGameUi(true);
					break;
				case GameStates.GREEN_PATHCOMPLETE:
					if(!aiManager.isSpawnPointOccuppied()){
						if(diceAnim.value==1 && aiManager.soldiersInCastle()){
							gameUi.toggleButtons(1,0,1,0);
						}else if(diceAnim.value==6 && aiManager.bombsInCastle()){
							gameUi.toggleButtons(1,1,0,0);
						}else{
							gameUi.toggleButtons(1,0,0,0);
						}
					}else{
						gameUi.toggleButtons(1,0,0,0);	
					}
					
					showGameUi();
					showInfo("Hit play to start moving! Touch & drag from green soldier again to redo path");
					break;
				case GameStates.GREEN_MOVE:
					gameUi.toggleButtons(0,0,0,0);
					aiManager.startWalk();
					showGameUi(true);
					showInfo("Your soldier is moving! Double tap to show/hide UI");
					break;
				
			}
			gameState=newState;
		}
		
		protected function showInfo(info:String):void{
			infoText.text=info;
			infoText.x = stage.stageWidth/2-infoText.width/2;
		}
		protected function showGameUi(hide:Boolean=false):void{
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
		protected function toggleUi():void{
			if(uiTweening){
				return;
			}
			if(gameUi.y<stage.stageHeight-gameUi.height/2){
				showGameUi(true);
			}else{
				showGameUi();
			}
		}
		/**
		 * Game UI button listener 
		 * @param e
		 * 
		 */
		protected function onGameEvent(e:GameEvent):void{
			switch(e.command){
				case "dice":
					switchGameState(GameStates.GREEN_PATH);
					break;
				case "play":
					switchGameState(GameStates.GREEN_MOVE);
					break;
				case "bomb":
					//clear all new paths, ground drawing
					aiManager.clearPath();
					aiManager.spawnBomb();
					switchGameState(GameStates.BLUE_BOMBS_MOVE);
					
					break;
				case "soldier":
					//clear all new paths, ground drawing
					aiManager.clearPath();
					aiManager.spawnSoldier();
					switchGameState(GameStates.BLUE_BOMBS_MOVE);
					
					break;
			}
		}
		/**
		 * Reduce the dice value based on marked paths while drawing. 
		 */
		protected function updateValueUsed():void
		{
			valueUsed=aiManager.getAllPathsLength();
		}
		public override function dispose():void{
			
			removeEventListener(EnterFrameEvent.ENTER_FRAME,loop);
			removeEventListener(TouchEvent.TOUCH,onTouch);
			removeEventListener(GameEvent.CONTROL_TYPE,onGameEvent);
			
			groundLayer.dispose();
			worldLayer.dispose();
			
			gameUi.removeFromParent(true);
			gameUi=null;
			diceAnim=null;
			
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}
