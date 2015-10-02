package com.csharks.flagdefense.scenes
{
	import com.csharks.flagdefense.GameStates;
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.helpers.IsoHelper;
	
	import flash.geom.Point;
	import flash.system.System;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MultiSamePc extends MainLevel
	{
		private var isBlue:Boolean=false;
		
		
		public function MultiSamePc()
		{
			super();
		}
		protected override function onTouch(e:TouchEvent):void{
			var t:Touch=e.getTouch(hitzone,TouchPhase.ENDED);
			if(t){
				if(t.tapCount==2){
					toggleUi();
				}
				if(gameState!=GameStates.GREEN_PATH&&gameState!=GameStates.GREEN_PATHCOMPLETE&&
					gameState!=GameStates.BLUE_PATH&&gameState!=GameStates.BLUE_PATHCOMPLETE
				){
					//trace("touch return");
					return;
				}
				var tp:Point=new Point(t.globalX,t.globalY);
				convertTouchPoint(tp);
				tp=IsoHelper.isoToCart(tp);
				tp=IsoHelper.getTileIndices(tp,tileWidth);
				
				anotherSoldier=aiManager.getTouchedSoldier(tp,isBlue);//.hasASoldier(tp,isBlue);
				if(anotherSoldier!=null){
					character=anotherSoldier;
					if(character){
						tp=character.paintPoint;
						worldLayer.repaintGround(character.path);
						paintingPath=true;
						character.path.splice(0,character.path.length);
						if(isBlue){
							switchGameState(GameStates.BLUE_PATH);
						}else{
							switchGameState(GameStates.GREEN_PATH);
						}
						worldLayer.paintGround(character.path,tp);
						character.path.push(character.paintPoint);
						
						aiManager.getUpdatedCollisionArray(isBlue);
						updateValueUsed();
						return;
					}
				}
				
				if(character!=null){
					tp=aiManager.findDirectionalPoint(character.path[character.path.length-1],t.globalX,t.globalY);
					if(tp.equals(minusPoint)||(character.path.length!=0&&aiManager.alreadyInPath(tp,isBlue))){
						//trace("already in");
						return;
					}
					
					if(isValidPosition(tp)){
						worldLayer.paintGround(character.path,tp);
						character.path.push(tp);
					}
					updateValueUsed();
					
					
					if(valueUsed==diceAnim.value){
						character=null;
						if(isBlue){
							switchGameState(GameStates.BLUE_PATHCOMPLETE);
						}else{
							switchGameState(GameStates.GREEN_PATHCOMPLETE);
						}
					}
				}
				
			}
		}
		
		protected override function switchGameState(newState:uint):void{
			switch (newState){
				case GameStates.BLUE_BOMBS_MOVE:
					gameUi.toggleButtons(0,0,0,0,true);
					infoText.color = 0x0000ff;
					isBlue=true;
					aiManager.moveBombs(isBlue);
					break;
				case GameStates.GREEN_BOMBS_MOVE:
					gameUi.toggleButtons(0,0,0,0);
					infoText.color = 0x009900;
					isBlue=false;
					aiManager.moveBombs();
					break;
				case GameStates.BLUE_DICE:
					character=null;
					System.gc();
					diceAnim.startRolling();
					showGameUi();
					gameUi.toggleButtons(0,0,0,1,true);
					
					showInfo("Blue's turn! Tap dice to stop rolling");
					break;
				case GameStates.BLUE_PATH:
					gameUi.toggleButtons(0,0,0,0,true);
					if(!diceAnim.settled){
						diceAnim.settleWithResult();
					}
					if(!aiManager.isSpawnPointOccuppied(true)){
						if(diceAnim.value==1 && aiManager.soldiersInCastle(isBlue)){
							gameUi.toggleButtons(0,0,1,0,true);
							showInfo("Blue got 1! Create new soldier(3) or tap to select soldier, tap screen (top, bottom, left, right) to add path");
						}else if(diceAnim.value==6 && aiManager.bombsInCastle(isBlue)){
							gameUi.toggleButtons(0,1,0,0,true);
							showInfo("Blue got 6! Create a homing bomb(2) or tap to select soldier, tap screen (top, bottom, left, right) to add path");
						}else{
							showInfo("Blue got "+diceAnim.value.toString()+"! Tap to select soldier, tap screen (top, bottom, left, right) to add path");
						}
					}else{
						showInfo("Blue got "+diceAnim.value.toString()+"! Tap to select soldier, tap screen (top, bottom, left, right) to add path");
					}
					
					break;
				case GameStates.BLUE_PATHCOMPLETE:
					if(!aiManager.isSpawnPointOccuppied(true)){
						if(diceAnim.value==1 && aiManager.soldiersInCastle(isBlue)){
							gameUi.toggleButtons(1,0,1,0,true);
						}else if(diceAnim.value==6 && aiManager.bombsInCastle(isBlue)){
							gameUi.toggleButtons(1,1,0,0,true);
						}else{
							gameUi.toggleButtons(1,0,0,0,true);
						}
					}else{
						gameUi.toggleButtons(1,0,0,0,true);
					}
					showGameUi();
					showInfo("Hit play to start moving! Tap to reselect soldier, tap screen (top, bottom, left, right) to add path");
					
					break;
				case GameStates.BLUE_MOVE:
					gameUi.toggleButtons(0,0,0,0,true);
					aiManager.startWalk(true);
					showGameUi(true);
					showInfo("Blue soldier is moving! Double tap to show/hide UI");
					break;
				case GameStates.GREEN_DICE:
					character=null;
					System.gc();
					diceAnim.startRolling();
					showGameUi();
					gameUi.toggleButtons(0,0,0,1);
					
					showInfo("Green's turn! Tap dice to stop rolling");
					break;
				case GameStates.GREEN_PATH:
					gameUi.toggleButtons(0,0,0,0);
					if(!diceAnim.settled){
						diceAnim.settleWithResult();
					}
					if(!aiManager.isSpawnPointOccuppied()){
						if(diceAnim.value==1 && aiManager.soldiersInCastle()){
							gameUi.toggleButtons(0,0,1,0);
							showInfo("Green got 1! Create new soldier(3) or tap to select soldier, tap screen (top, bottom, left, right) to add path");
						}else if(diceAnim.value==6 && aiManager.bombsInCastle()){
							gameUi.toggleButtons(0,1,0,0);
							showInfo("Grren got 6! Create a homing bomb(2) or tap to select soldier, tap screen (top, bottom, left, right) to add path");
						}else{
							showInfo("Green got "+diceAnim.value.toString()+"! Tap to select soldier, tap screen (top, bottom, left, right) to add path");
						}
					}else{
						showInfo("Green got "+diceAnim.value.toString()+"! Tap to select soldier, tap screen (top, bottom, left, right) to add path");
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
					showInfo("Hit play to start moving! Tap to reselect soldier, tap screen (top, bottom, left, right) to add path");
					break;
				case GameStates.GREEN_MOVE:
					gameUi.toggleButtons(0,0,0,0);
					aiManager.startWalk();
					showGameUi(true);
					showInfo("Green soldier is moving! Double tap to show/hide UI");
					break;
				
			}
			gameState=newState;
		}
		protected override function onGameEvent(e:GameEvent):void{
			switch(e.command){
				case "dice":
					if(gameState==GameStates.GREEN_DICE){
						switchGameState(GameStates.GREEN_PATH);
					}else if(gameState=GameStates.BLUE_DICE){
						switchGameState(GameStates.BLUE_PATH);
					}
					break;
				case "play":
					if(gameState==GameStates.GREEN_PATHCOMPLETE){
						switchGameState(GameStates.GREEN_MOVE);
					}else if(gameState=GameStates.BLUE_PATHCOMPLETE){
						switchGameState(GameStates.BLUE_MOVE);
					}
					break;
				case "bomb"://clear all new paths, ground drawing
					aiManager.clearPath();
					aiManager.spawnBomb(isBlue);
					if(isBlue){
						switchGameState(GameStates.GREEN_BOMBS_MOVE);
					}else{
						switchGameState(GameStates.BLUE_BOMBS_MOVE);
					}
					break;
				case "soldier"://clear all new paths, ground drawing
					aiManager.clearPath();
					aiManager.spawnSoldier(isBlue);
					if(isBlue){
						switchGameState(GameStates.GREEN_BOMBS_MOVE);
					}else{
						switchGameState(GameStates.BLUE_BOMBS_MOVE);
					}
					break;
			}
		}
	}
}