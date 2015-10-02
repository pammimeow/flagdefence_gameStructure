package com.csharks.flagdefense.helpers
{
	import com.csharks.flagdefense.AiDecisions;
	import com.csharks.flagdefense.AiStates;
	import com.csharks.flagdefense.entities.Bomb;
	import com.csharks.flagdefense.entities.Explosion;
	import com.csharks.flagdefense.entities.Soldier;
	import com.csharks.flagdefense.entities.WorldLayerQB;
	import com.csharks.flagdefense.scenes.MainLevel;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import flash.geom.Point;
	
	import libs.PathFinder.PathFinder;
	
	import starling.core.Starling;
	
	public class AiManager
	{
		private var greenSoldiers:Vector.<Soldier>;
		private var blueSoldiers:Vector.<Soldier>;
		private var greenBombs:Vector.<Bomb>;
		private var blueBombs:Vector.<Bomb>;
		private var explosions:Vector.<Explosion>;
		
		private var character:Soldier;
		private var aBomb:Bomb;
		private var explosion:Explosion;
		
		private const greenSpawnPt:Point=new Point(27,18);
		private const blueSpawnPt:Point=new Point(8,16);
		
		public const greenFlagPt:Point=new Point(26,18);
		public const blueFlagPt:Point=new Point(7,16);
		public var greenFlagAtCastle:Boolean=true;
		public var blueFlagAtCastle:Boolean=true;
		
		private var soldiersWithPath:Vector.<Soldier>= new Vector.<Soldier>();
		private var groundLayer:WorldLayerQB;
		
		private var realtimeCollision:Array;
		
		private var tileWidth:Number;
		private var screenOffset:Point;
		private const minusPoint:Point=new Point(-1,-1);
		
		private const maxBombs:uint=2;
		private const maxSoldiers:uint=3;
		private const maxBombSteps:uint=1;
		
		public var blueWins:Boolean=false;
		public var greenWins:Boolean=false;
		
		private const soldierTreshold:uint=5;
		private const flagTreshold:uint=10;
		private var stageSize:Point;
		private var _stageRef:MainLevel;
		
		/**
		 * Create AI Manager with references to Vectors keeping all dynamic items in level , screen offset & tilewidth 
		 * @param _greenSoldiers
		 * @param _blueSoldiers
		 * @param _greenBombs
		 * @param _blueBombs
		 * @param _explosions
		 * @param _tileWidth
		 * @param _screenOffset
		 * 
		 */
		public function AiManager(_greenSoldiers:Vector.<Soldier>,_blueSoldiers:Vector.<Soldier>,_greenBombs:Vector.<Bomb>,_blueBombs:Vector.<Bomb>,_explosions:Vector.<Explosion>,_tileWidth:Number,_screenOffset:Point,_world:WorldLayerQB)
		{
			groundLayer=_world;
			blueWins=greenWins=false;
			tileWidth=_tileWidth;
			screenOffset=_screenOffset;
			greenSoldiers=_greenSoldiers;
			blueSoldiers=_blueSoldiers;
			greenBombs=_greenBombs;
			blueBombs=_blueBombs;
			explosions=_explosions;
			realtimeCollision=new Array();
			getUpdatedCollisionArray();
		}
		
		/**
		 *	THis function is called every frame to advance through 
		 * AI movements & decision making 
		 * @param delta : time passed
		 * 
		 */
		public function step(delta:Number):void{
			for(var id:int=0;id<greenSoldiers.length;id++){
				character=greenSoldiers[id];
				if(character.isDead){
					greenSoldiers.splice(id,1);
					character.dispose();
					character=null;
				}else{
					character.action(delta);
					if(character.isOnNewTile){
						checkForAxn(character);
					}
					character.update(delta);
				}
			}
			for(id=0;id<blueSoldiers.length;id++){
				character=blueSoldiers[id];
				if(character.isDead){
					blueSoldiers.splice(id,1);
					character.dispose();
					character=null;
				}else{
					character.action(delta);
					if(character.isOnNewTile){
						checkForAxn(character);
					}
					character.update(delta);
				}
			}
			for(id=0;id<blueBombs.length;id++){
				aBomb=blueBombs[id];
				if(aBomb.exploded){
					blueBombs.splice(id,1);
					aBomb.dispose();
					aBomb=null;
				}else{
					aBomb.action(delta);
					if(aBomb.isOnNewTile){
						checkForExplosion(aBomb);
					}
					aBomb.update(delta);
				}
			}
			for(id=0;id<greenBombs.length;id++){
				aBomb=greenBombs[id];
				if(aBomb.exploded){
					greenBombs.splice(id,1);
					aBomb.dispose();
					aBomb=null;
				}else{
					aBomb.action(delta);
					if(aBomb.isOnNewTile){
						checkForExplosion(aBomb);
					}
					aBomb.update(delta);
				}
			}
			for(id=0;id<explosions.length;id++){
				explosion=explosions[id];
				if(explosion.completed){
					explosions.splice(id,1);
					explosion.s.removeFromParent(true);
					explosion.f.removeFromParent(true);
					explosion.destroy();
					explosion=null;
				}else{
					explosion.update(delta);
				}
			}
			if(blueSoldiers.length==0){
				trace("Game Over");
				greenWins=true;
			}else if(greenSoldiers.length==0){
				trace("Game Over");
				blueWins=true;
				
			}
			
		}
		
		
		/**
		 * Check if there is a soldier on the bomb tile 
		 * @param _bomb
		 * 
		 */
		private function checkForExplosion(_bomb:Bomb):void
		{
			var _soldier:Soldier;
			if(_bomb.isBlue){
				_soldier=hasASoldier(_bomb.paintPoint);
			}else{
				_soldier=hasASoldier(_bomb.paintPoint,true);
			}
			_bomb.isOnNewTile=false;
			if(_soldier!=null && _soldier.state!="die"){
				explodeBomb(_bomb,_soldier);
			}
		}
		
		/**
		 * Bomb explodes & soldier dies, flags reset 
		 * @param _bomb
		 * @param _soldier
		 * 
		 */
		private function explodeBomb(_bomb:Bomb, _soldier:Soldier):void
		{
			if(_bomb.exploded){
				return;
			}
			trace("bomb explodes");
			if(_soldier.hasBlueFlag){
				_soldier.hasBlueFlag=false;
				blueFlagAtCastle=true;
			}
			if(_soldier.hasGreenFlag){
				_soldier.hasGreenFlag=false;
				greenFlagAtCastle=true;
			}
			spawnExplosion(_bomb.paintPoint,_bomb.paintPointIso);
			_bomb.exploded=true;
			_soldier.walking=false;
			_soldier.state="die";
			groundLayer.repaintGround(_soldier.path);
		}
		
		/**
		 * Soldier is on a new tile, check if he walked over a bomb, or the flag tiles 
		 * & take aproprioate actions
		 * If the next tile in the soldiers path has a enemy then start fight, freeze movement 
		 * @param _soldier
		 * 
		 */
		private function checkForAxn(_soldier:Soldier):void
		{
			var bomb:Bomb=hasABomb(_soldier.paintPoint,_soldier.isAI);
			if(bomb!=null){
				explodeBomb(bomb,_soldier);
				return;
			}
			if(_soldier.isAI){
				if(_soldier.paintPoint.equals(blueFlagPt)){
					trace("blue at blue flag");
					if(blueFlagAtCastle && _soldier.hasGreenFlag){
						trace("blue wins");
						blueWins=true;
					}else if(!blueFlagAtCastle && _soldier.hasBlueFlag){
						trace("blue brings back flag");
						blueFlagAtCastle=true;
						_soldier.hasBlueFlag=false;
						ResourceManager.playSound("FlagSfx");
					}
				}else if(_soldier.paintPoint.equals(greenFlagPt)){
					trace("blue at green flag");
					if(greenFlagAtCastle && !_soldier.hasBlueFlag){
						trace("blue takes green flag");
						greenFlagAtCastle=false;
						_soldier.hasGreenFlag=true;
						ResourceManager.playSound("FlagSfx");
					}
				}
			}else{
				if(_soldier.paintPoint.equals(blueFlagPt)){
					trace("green at blue flag");
					if(blueFlagAtCastle && !_soldier.hasGreenFlag){
						trace("green takes blue flag");
						blueFlagAtCastle=false;
						_soldier.hasBlueFlag=true;
						ResourceManager.playSound("FlagSfx");
					}
				}else if(_soldier.paintPoint.equals(greenFlagPt)){
					trace("green at green flag");
					if(greenFlagAtCastle && _soldier.hasBlueFlag){
						trace("green wins");
						greenWins=true;
					}else if(!greenFlagAtCastle && _soldier.hasGreenFlag){
						trace("green brings back flag");
						greenFlagAtCastle=true;
						_soldier.hasGreenFlag=false;
						ResourceManager.playSound("FlagSfx");
					}
				}
			}
			_soldier.isOnNewTile=false;
			if(_soldier.nextTile.equals(minusPoint)){
				return;
			}
			var anotherSoldier:Soldier;
			if(_soldier.isAI){
				anotherSoldier=hasASoldier(_soldier.nextTile);
			}else{
				anotherSoldier=hasASoldier(_soldier.nextTile,true);
			}
			if(anotherSoldier!=null && (anotherSoldier.state!="die" || anotherSoldier.state!="attack")){
				trace("has enemy soldier in path");
				Starling.juggler.delayCall(moveOn,4,_soldier,anotherSoldier);
				_soldier.actOnSpot("attack");
				anotherSoldier.actOnSpot("attack");
				anotherSoldier.face(_soldier.facing);
			}
		}
		/**
		 * Continue frozen walk after killing enemy soldier 
		 * @param _soldier : Winner, needs to move on
		 * @param anotherSoldier : Killed soldier
		 * 
		 */		
		private function moveOn(_soldier:Soldier,anotherSoldier:Soldier):void{
			if(anotherSoldier.hasBlueFlag){
				if(!_soldier.hasGreenFlag){
					_soldier.hasBlueFlag=anotherSoldier.hasBlueFlag;
				}else{
					blueFlagAtCastle=true;
				}
				anotherSoldier.hasBlueFlag=false;
			}
			if(anotherSoldier.hasGreenFlag){
				if(!_soldier.hasBlueFlag){
					_soldier.hasGreenFlag=anotherSoldier.hasGreenFlag;
				}else{
					greenFlagAtCastle=true;
				}
				anotherSoldier.hasGreenFlag=false;
			}
			anotherSoldier.state="die";
			_soldier.state="walk";
			_soldier.unfreeze();
		}
		
		/**
		 * Spawn a soldier 
		 * @param isAI : isBlue?
		 * 
		 */
		public function spawnSoldier(isAI:Boolean=false):void{
			ResourceManager.playSound("SoldierSfx");
			if(!isAI){
				var soldier:Soldier=new Soldier(tileWidth,greenSpawnPt,screenOffset);
				greenSoldiers.push(soldier);
			}else{
				soldier=new Soldier(tileWidth,blueSpawnPt,screenOffset,isAI);
				blueSoldiers.push(soldier);
			}
			
		}
		
		/**
		 * Spawn a bomb 
		 * @param isAI : isBlue?
		 * 
		 */
		public function spawnBomb(isAI:Boolean=false):void{
			ResourceManager.playSound("MineSfx");
			if(!isAI){
				var bomb:Bomb=new Bomb(tileWidth,greenSpawnPt,screenOffset);
				greenBombs.push(bomb);
			}else{
				bomb=new Bomb(tileWidth,blueSpawnPt,screenOffset,isAI);
				blueBombs.push(bomb);
			}
		}
		/**
		 * Check if the point has a bomb 
		 * @param tp
		 * @param isAI
		 * @return : The bomb
		 * 
		 */		
		public function hasABomb(tp:Point, isAI:Boolean=false):Bomb{
			var bomb:Bomb;
			if(isAI){
				for(var id:String in greenBombs){
					if(tp.equals(greenBombs[id].paintPoint)){
						bomb=greenBombs[id];
						break
					}
				}
			}else{
				for(id in blueBombs){
					if(tp.equals(blueBombs[id].paintPoint)){
						bomb=blueBombs[id];
						break
					}
				}
			}
			return bomb;
		}
		
		/**
		 * Check if point has a soldier 
		 * @param tp
		 * @param isAI
		 * @return : The soldier
		 * 
		 */
		public function hasASoldier(tp:Point, isAI:Boolean=false):Soldier{
			var soldier:Soldier;
			if(!isAI){
				for(var id:String in greenSoldiers){
					if(tp.equals(greenSoldiers[id].paintPoint)){
						soldier=greenSoldiers[id];
						break
					}
				}
			}else{
				for(id in blueSoldiers){
					if(tp.equals(blueSoldiers[id].paintPoint)){
						soldier=blueSoldiers[id];
						break
					}
				}
			}
			return soldier;
		}
		/**
		 * The main AI decision maker logic. Simple AI, can be improved :) 
		 * @param value : Dice value
		 * @return : AIDecision value to find is AI decided to spawn instead of moving.
		 * 
		 */		
		public function makeDecision(value:uint):uint
		{
			trace("***************",value);
			var _soldier:Soldier;
			var _anotherSoldier:Soldier;
			var _soldierWithFlag:Soldier;
			var _bomb:Bomb;
			var isCritical:Boolean=false;
			var valueLeft:int=value;
			var aiDecision:uint=AiDecisions.WALK;
			for(var id:String in blueSoldiers){
				_soldier=blueSoldiers[id];
				_soldier.aiState=AiStates.UNDETERMINED;
				for(var i:uint=0;i<greenBombs.length;i++){//any near by bombs?
					_bomb=greenBombs[i];
					if(areNeighbours(_soldier.paintPoint,_bomb.paintPoint)){
						_soldier.aiState=AiStates.AVOID_BOMB;
						_soldier.aiDestination=_bomb.paintPoint;
						isCritical=true;
						valueLeft-=addAiPath(_soldier,0,true);trace("found close bomb");
						
						if(valueLeft==0){groundLayer.repaintGround(_soldier.path,true);
							return(aiDecision);
						}
					}
				}
				if(_soldier.aiState==AiStates.UNDETERMINED){//are flag points close?
					if(blueFlagAtCastle && _soldier.hasGreenFlag && minStepsBetween(_soldier.paintPoint,blueFlagPt)<flagTreshold){
						_soldier.aiState=AiStates.GET_TO_CASTLE;
						_soldier.aiDestination=blueFlagPt;
						isCritical=true;
						valueLeft-=addAiPath(_soldier,valueLeft);trace("found finishing chance");
						
						if(valueLeft==0){groundLayer.repaintGround(_soldier.path,true);
							return(aiDecision);
						}
					}else if(greenFlagAtCastle && !_soldier.hasBlueFlag && minStepsBetween(_soldier.paintPoint,greenFlagPt)<flagTreshold){
						_soldier.aiState=AiStates.GET_FLAG;
						_soldier.aiDestination=greenFlagPt;
						isCritical=true;
						valueLeft-=addAiPath(_soldier,valueLeft);trace("found green castle");
						
						if(valueLeft==0){groundLayer.repaintGround(_soldier.path,true);
							return(aiDecision);
						}
					}else if(_soldier.hasBlueFlag && minStepsBetween(_soldier.paintPoint,blueFlagPt)<flagTreshold){
						_soldier.aiState=AiStates.GET_TO_CASTLE;
						_soldier.aiDestination=blueFlagPt;
						isCritical=true;
						valueLeft-=addAiPath(_soldier,valueLeft);trace("found blue castle");
						
						if(valueLeft==0){groundLayer.repaintGround(_soldier.path,true);
							return(aiDecision);
						}
					}else{//any enemy soldiers close?
						for(i=0;i<greenSoldiers.length;i++){
							_anotherSoldier=greenSoldiers[i];
							if(_anotherSoldier.hasGreenFlag&&_soldierWithFlag==null){
								_soldierWithFlag=_anotherSoldier;
							}else if(_anotherSoldier.hasBlueFlag){
								_soldierWithFlag=_anotherSoldier;
							}
							if(minStepsBetween(_soldier.paintPoint,_anotherSoldier.paintPoint)<soldierTreshold){
								_soldier.aiState=AiStates.KILL_SOLDIER;
								_soldier.aiDestination=_anotherSoldier.paintPoint;
								valueLeft-=addAiPath(_soldier,valueLeft);trace("found enemy close");
								isCritical=true;
								if(valueLeft==0){groundLayer.repaintGround(_soldier.path,true);
									return(aiDecision);
								}
							}
						}
					}
				}
			}
			
			var canSpawn:Boolean=!isSpawnPointOccuppied(true);
			var normalMove:Boolean=false;
			if(!isCritical){
				if(value==1 &&canSpawn && soldiersInCastle(true)){
					//can place soldier or move
					aiDecision=AiDecisions.SPAWN_SOLDIER;
				}else if (value==6 &&canSpawn &&bombsInCastle(true)){
					//can place bomb or move
					aiDecision=AiDecisions.SPAWN_BOMB;
				}else{
					normalMove=true;
				}
			}else{
				normalMove=true;
			}
			//trace("none critical");
			if(normalMove){
				for(id in blueSoldiers){
					_soldier=blueSoldiers[id];
					if(_soldier.aiState==AiStates.UNDETERMINED){
						if(blueFlagAtCastle && _soldier.hasGreenFlag){
							_soldier.aiState=AiStates.GET_TO_CASTLE;
							_soldier.aiDestination=blueFlagPt;
							trace("back to blue castle");
						}else if(!blueFlagAtCastle && _soldier.hasBlueFlag){
							_soldier.aiState=AiStates.GET_TO_CASTLE;
							_soldier.aiDestination=blueFlagPt;
							trace("back to blue castle");
						}else if(greenFlagAtCastle){
							if(Math.random()<0.3){trace("roam random");
								_soldier.aiDestination=findRandomDestination();
							}else{trace("get green flag");
								if(_soldier.hasBlueFlag){
									_soldier.aiState=AiStates.GET_TO_CASTLE;
									_soldier.aiDestination=blueFlagPt;
								}else {
									_soldier.aiState=AiStates.GET_FLAG;
									_soldier.aiDestination=greenFlagPt;
								}
							}
						}else if(_soldierWithFlag!=null){
							if(Math.random()<0.3){trace("roam random");
								_soldier.aiDestination=findRandomDestination();
							}else{trace("kill flag soldier");
								_soldier.aiState=AiStates.KILL_SOLDIER;
								_soldier.aiDestination=_soldierWithFlag.paintPoint;
							}
						}
					}
					if(_soldier.path.length>0){
						groundLayer.repaintGround(_soldier.path,true);
					}
				}
				var loopCount:uint=0;
				while(valueLeft>0){
					loopCount++;
					_soldier=findAiSoldier();
					if(loopCount>6){
						valueLeft-=addAiPath(_soldier,valueLeft,false,true);
					}else{
						valueLeft-=addAiPath(_soldier,valueLeft);
					}
					groundLayer.repaintGround(_soldier.path,true);
				}
				
			}
			return aiDecision;
		}
		/**
		 * Find random AI soldier 
		 * @return : AI soldier
		 * 
		 */		
		private function findAiSoldier():Soldier{
			var index:uint=uint(Math.random()*blueSoldiers.length);
			return blueSoldiers[index];
		}
		/**
		 * Adds path to AI soldier based on certain logic
		 * @param _soldier
		 * @param value : How many steps can be moved
		 * @param isBomb : whether he has a bomb on next tile
		 * @param forced : Skip AI, just move towards some random spot as we are running out of time
		 * @return : How many steps he moved
		 * 
		 */		
		private function addAiPath(_soldier:Soldier,value:uint, isBomb:Boolean=false, forced:Boolean=false):int
		{
			
			var retPt:Point;
			var retVal:int=0;
			if(isBomb){
				if(_soldier.paintPoint.x==_soldier.aiDestination.x){
					if(_soldier.paintPoint.y>_soldier.aiDestination.y){
						retPt=stepAway("down",_soldier.paintPoint);//+y
					}else {
						retPt=stepAway("up",_soldier.paintPoint);
					}
				}else {
					if(_soldier.paintPoint.x>_soldier.aiDestination.x){
						retPt=stepAway("right",_soldier.paintPoint);
					}else {
						retPt=stepAway("left",_soldier.paintPoint);
					}
				}
				if(!retPt.equals(minusPoint)){
					_soldier.path.push(_soldier.paintPoint);
					_soldier.path.push(retPt);
					groundLayer.repaintGround(_soldier.path,true);
					retVal=1;
				}
			}else{//trace("adding ",_soldier.path.length);
				if(_soldier.aiState==AiStates.AVOID_BOMB && !forced){
					return 0;
				}
				getUpdatedCollisionArray(true);
				markFellowPaths(forced);//add all fellow paths to collision array
				if(forced){trace("forcing");
					_soldier.aiDestination=findRandomDestination();
				}
				if(_soldier.path.length==0){
					realtimeCollision[_soldier.paintPoint.y][_soldier.paintPoint.x]=0;
					_soldier.path=PathFinder.go(_soldier.paintPoint.x,_soldier.paintPoint.y,_soldier.aiDestination.x,_soldier.aiDestination.y,realtimeCollision);
					_soldier.path.reverse();
					_soldier.path.splice(value+1);
					//trace("adding new path", value,_soldier.path.length);
					retVal=_soldier.path.length-1;
					if(retVal>-1){
						if((_soldier.path[retVal] as Point).equals(_soldier.aiDestination)){trace("reached, go random");
							_soldier.aiDestination=findRandomDestination();
						}
					}else{
						retVal=0;
						_soldier.aiDestination=findRandomDestination();
					}
				}else{
					retPt=_soldier.path[_soldier.path.length-1];
					//trace(_soldier.path,retPt);
					realtimeCollision[retPt.y][retPt.x]=0;
					if(retPt.equals(_soldier.aiDestination)){trace("reached, go random");
						_soldier.aiDestination=findRandomDestination();
					}
					var addedPath:Array=PathFinder.go(retPt.x,retPt.y,_soldier.aiDestination.x,_soldier.aiDestination.y,realtimeCollision);
					addedPath.pop();
					addedPath.reverse();
					addedPath.splice(value);
					
					retVal=addedPath.length;
					for(var i:int=0;i<addedPath.length;i++){
						_soldier.path.push(addedPath[i]);
					}
					trace("adding more path", value);
				}
				
			}
			//trace("retVal", retVal);
			return retVal;
		}
		
		/**
		 * Find an empty spot on the entire level to which we can random roam 
		 * @return 
		 * 
		 */
		private function findRandomDestination():Point
		{
			var newTp:Point=new Point();
			newTp.x=int(Math.random()*realtimeCollision[0].length);
			newTp.y=int(Math.random()*realtimeCollision.length);
			
			while(!isWalkable(newTp)){
				newTp.x=int(Math.random()*realtimeCollision[0].length);
				newTp.y=int(Math.random()*realtimeCollision.length);
			}
			
			return newTp;
		}
		/**
		 * For AI moving we need to mark already captured paths for other AI soldiers as non walkable else they will walk over to same tile.
		 * Also we need to mark enemy bomb's neighbouring tiles as non walkable else they will end up committing suicide ;) 
		 * @param forced : if forced then he may need to walk over bombs, or bomb's neighbour tiles.
		 * 
		 */		
		public function markFellowPaths(forced:Boolean=false):void{
			var newTp:Point;
			var _soldier:Soldier;
			var _bomb:Bomb;
			for(var id:String in blueSoldiers){
				_soldier=blueSoldiers[id];
				for(var i:int=0;i<_soldier.path.length;i++){
					newTp=_soldier.path[i] as Point;
					realtimeCollision[newTp.y][newTp.x]=1;
				}
			}
			
			for(id in greenBombs){
				_bomb=greenBombs[id];
				newTp=_bomb.paintPoint;
				if(!forced){
					realtimeCollision[newTp.y-1][newTp.x]=1;
					realtimeCollision[newTp.y+1][newTp.x]=1;
					realtimeCollision[newTp.y][newTp.x-1]=1;
					realtimeCollision[newTp.y][newTp.x+1]=1;
				}else{
					realtimeCollision[newTp.y][newTp.x]=0;
				}
			}
			
		}
		
		/**
		 * Take one step away based on a direction string. ie, we can move in all the other directions except it. 
		 * @param direction
		 * @param startPt : Point from which we should move away
		 * @return : Point decided to move into among 3 possible directions, creates a random path never returning to the start point.
		 * 
		 */
		private function stepAway(direction:String,startPt:Point):Point{
			var possibleOptions:Vector.<Point>=new Vector.<Point>();
			switch(direction){
				case "up":
					possibleOptions.push(new Point(startPt.x,startPt.y+1));
					possibleOptions.push(new Point(startPt.x+1,startPt.y));
					possibleOptions.push(new Point(startPt.x-1,startPt.y));
					break;
				case "down":
					possibleOptions.push(new Point(startPt.x,startPt.y-1));
					possibleOptions.push(new Point(startPt.x+1,startPt.y));
					possibleOptions.push(new Point(startPt.x-1,startPt.y));
					break;
				case "right":
					possibleOptions.push(new Point(startPt.x,startPt.y+1));
					possibleOptions.push(new Point(startPt.x,startPt.y-1));
					possibleOptions.push(new Point(startPt.x-1,startPt.y));
					break;
				case "left":
					possibleOptions.push(new Point(startPt.x,startPt.y+1));
					possibleOptions.push(new Point(startPt.x,startPt.y-1));
					possibleOptions.push(new Point(startPt.x+1,startPt.y));
					break;
			}
			shuffle(possibleOptions);
			var tp:Point;
			for(var y:uint = 0; y <possibleOptions.length ; y++){
				tp=possibleOptions.pop();
				if(isWalkable(tp)){
					return(tp);
				}
			}
			return(minusPoint);
		}
		/**
		 * Vector randomiser 
		 * @param sourceVector
		 * 
		 */
		private function shuffle(sourceVector:Vector.<Point>):void {
			var shuffled:Vector.<Point>=new Vector.<Point>();
			var length:uint=sourceVector.length
			for(var y:uint = 0; y <length ; y++){
				var index:uint=uint(Math.random()*sourceVector.length);
				shuffled.push(sourceVector[index]);
				sourceVector.splice(index,1);
			}
			for(y = 0; y <length ; y++){
				sourceVector.push(shuffled[y]);
			}
		}
		/**
		 * Remove the path array for all soldiers, green & blue 
		 * Reset ground layer, remove all path drawings.
		 */
		public function clearPath():void{
			soldiersWithPath.splice(0,soldiersWithPath.length);
			findSoldiersWithPath(soldiersWithPath);
			for(var id:String in soldiersWithPath){
				character=soldiersWithPath[id];
				groundLayer.repaintGround(character.path);
				character.path.splice(0);
			}
			
		}
		/**
		 * Move the bombs by finding path to the closest enemy 
		 * @param isBlue
		 * 
		 */
		public function moveBombs(isBlue:Boolean=false):void{
			var _bomb:Bomb;
			if(isBlue){
				for(var id:String in blueBombs){
					_bomb=blueBombs[id];
					_bomb.path.splice(0);
					_bomb.path=getPathToClosestEnemy(_bomb.paintPoint,maxBombSteps,isBlue);
					if(_bomb.path.length>0){
						_bomb.markDestination();
					}else{
						trace("no path blue");
					}
				}
			}else{
				for(id in greenBombs){
					_bomb=greenBombs[id];
					_bomb.path.splice(0);
					_bomb.path=getPathToClosestEnemy(_bomb.paintPoint,maxBombSteps);
					if(_bomb.path.length>0){
						_bomb.markDestination();
					}else{
						trace("no path green");
					}
				}
			}
			
		}
		/**
		 * For moving bombs we need to mark all paths set for other bombs to be non walkable or they will overlap
		 * which essentially make them act as one :(, to be avoided 
		 * @param isBlue
		 * 
		 */
		public function markBombPaths(isBlue:Boolean=false):void{
			var newTp:Point;
			if(!isBlue){
				for(var id:String in greenBombs){
					aBomb=greenBombs[id];
					for(var i:int=0;i<aBomb.path.length;i++){
						newTp=aBomb.path[i] as Point;
						realtimeCollision[newTp.y][newTp.x]=1;
					}
					
				}
			}else{
				for(id in blueBombs){
					aBomb=blueBombs[id];
					for(i=0;i<aBomb.path.length;i++){
						newTp=aBomb.path[i] as Point;
						realtimeCollision[newTp.y][newTp.x]=1;
					}
					
				}
			}
			
		}
		/**
		 * For manual path drawing, check if this point is already in any soldiers path 
		 * @param tp
		 * @param isAI
		 * @return 
		 * 
		 */
		public function alreadyInPath(tp:Point,isAI:Boolean=false):Boolean{
			var retVal:Boolean=false;
			var newTp:Point;
			if(!isAI){
				for(var id:String in greenSoldiers){
					character=greenSoldiers[id];
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
			}else{
				for(id in blueSoldiers){
					character=blueSoldiers[id];
					for(i=0;i<character.path.length;i++){
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
			}
			return retVal;
		}
		
		/**
		 * Populate all soldiers with a path 
		 * @param soldiersWithPath
		 * 
		 */
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
		/**
		 * Check if all bombs have completed movement 
		 * @param isBlue
		 * @return 
		 * 
		 */
		public function noneHoming(isBlue:Boolean=false):Boolean{
			var retVal:Boolean=true;
			if(isBlue){
				for(var id:String in blueBombs){
					aBomb=blueBombs[id];
					if(aBomb.walking){
						retVal=false;
						break;
					}
				}
			}else{
				for(id in greenBombs){
					aBomb=greenBombs[id];
					if(aBomb.walking){
						retVal=false;
						break;
					}
				}
			}
			return retVal;
		}
		/**
		 * Check if all soldiers have completed movement 
		 * @param isBlue
		 * @return 
		 * 
		 */
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
		/**
		 * Start walking, make all soldiers follow their set paths 
		 * @param isBlue
		 * 
		 */
		public function startWalk(isBlue:Boolean=false):void{
			if(isBlue){
				for(var id:String in blueSoldiers){
					character=blueSoldiers[id];
					if(character.path.length>0){
						character.markDestination();
					}
				}
			}else{
				for(id in greenSoldiers){
					character=greenSoldiers[id];
					if(character.path.length>0){
						character.markDestination();
						
					}
				}
			}
		}
		/**
		 * Is the spawn points at castle door occuppied by anything, cant spawn then 
		 * @param isBlue
		 * @return 
		 * 
		 */
		public function isSpawnPointOccuppied(isBlue:Boolean=false):Boolean{
			var retVal:Boolean=false;
			var checkPt:Point;
			if(isBlue){
				checkPt=blueSpawnPt;
			}else{
				checkPt=greenSpawnPt;
			}
			for(var id:String in blueSoldiers){
				character=blueSoldiers[id];
				if(character.paintPoint.equals(checkPt)){
					retVal=true;
					break;
				}
			}
			for(id in blueBombs){
				aBomb=blueBombs[id];
				if(aBomb.paintPoint.equals(checkPt)){
					retVal=true;
					break;
				}
			}
			for(id in greenSoldiers){
				character=greenSoldiers[id];
				if(character.paintPoint.equals(checkPt)){
					retVal=true;
					break;
				}
			}
			for(id in greenBombs){
				aBomb=greenBombs[id];
				if(aBomb.paintPoint.equals(checkPt)){
					retVal=true;
					break;
				}
			}
			
			return retVal;
		}
		/**
		 * Find a path of given length to the closest enemy 
		 * @param paintPoint : starting point
		 * @param value : path length
		 * @param isBlue
		 * @return 
		 * 
		 */
		private function getPathToClosestEnemy(paintPoint:Point,value:uint,isBlue:Boolean=false):Array{
			var temp:Array=new Array();
			var distance:uint=500;
			var newDistance:uint;
			var destPt:Point=new Point();
			if(!isBlue){
				for(var id:String in blueSoldiers){
					character=blueSoldiers[id];
					newDistance=minStepsBetween(character.paintPoint,paintPoint);
					if(newDistance<distance){
						distance=newDistance;
						destPt.x=character.paintPoint.x;
						destPt.y=character.paintPoint.y;
					}
				}
			}else{
				for(id in greenSoldiers){
					character=greenSoldiers[id];
					newDistance=minStepsBetween(character.paintPoint,paintPoint);
					if(newDistance<distance){
						distance=newDistance;
						destPt.x=character.paintPoint.x;
						destPt.y=character.paintPoint.y;
					}
				}
			}
			getUpdatedCollisionArray(isBlue);
			markBombPaths(isBlue);
			realtimeCollision[paintPoint.y][paintPoint.x]=0;
			temp=PathFinder.go(paintPoint.x,paintPoint.y,destPt.x,destPt.y,realtimeCollision);
			temp.reverse();
			temp.splice(value+1);
			//trace("temp path",temp);
			return temp;
			
		}
		/**
		 * Very crude way to determine steps between 2 points in the grid, this effectively ignores 
		 * any non walkable tiles in between. Can be made better, but this is very simple. 
		 * @param fp
		 * @param sp
		 * @return 
		 * 
		 */		
		private function minStepsBetween(fp:Point,sp:Point):uint{
			return Math.abs(fp.x-sp.x)+Math.abs(fp.y-sp.y);
		}
		/**
		 * Recalculate the realtimeCollision array. Original level collision values get copied.
		 * All same color bombs, soldiers get marked as non walkable. 
		 * @param isBlue
		 * 
		 */
		public function getUpdatedCollisionArray(isBlue:Boolean=false):void{
			realtimeCollision.splice(0);
			var collArray:Array=LevelUtils.collisionArray;
			var rows:uint=collArray.length;
			var cols:uint=collArray[0].length;
			for(var i:int=0;i<rows;i++){
				realtimeCollision[i]=new Array();
				for(var j:int=0;j<cols;j++){
					realtimeCollision[i].push(collArray[i][j]);
				}
			}
			
			if(isBlue){
				for(var id:String in blueSoldiers){
					character=blueSoldiers[id];
					realtimeCollision[character.paintPoint.y][character.paintPoint.x]=1;
				}
				for(id in blueBombs){
					aBomb=blueBombs[id];
					realtimeCollision[aBomb.paintPoint.y][aBomb.paintPoint.x]=1;
				}
			}else{
				for(id in greenSoldiers){
					character=greenSoldiers[id];
					realtimeCollision[character.paintPoint.y][character.paintPoint.x]=1;
				}
				for(id in greenBombs){
					aBomb=greenBombs[id];
					realtimeCollision[aBomb.paintPoint.y][aBomb.paintPoint.x]=1;
				}
			}
			
		}
		/**
		 * Check the realtimeCollision array if the point is walkable 
		 * @param tp
		 * @return 
		 * 
		 */
		public function isWalkable(tp:Point):Boolean{
			return (realtimeCollision[tp.y][tp.x]!=1);
		}
		/**
		 * Return if passed points are neighbours. Diagonal neighbours are not valaid in this game. 
		 * @param newTp
		 * @param tp
		 * @return 
		 * 
		 */
		public function areNeighbours(newTp:Point,tp:Point):Boolean{
			var retVal:Boolean=false;
			if(Math.abs(newTp.x-tp.x)==0&&Math.abs(newTp.y-tp.y)<=1){
				retVal=true;
			}
			if(Math.abs(newTp.y-tp.y)==0&&Math.abs(newTp.x-tp.x)<=1){
				retVal=true;
			}
			return retVal;
		}
		
		/**
		 * Total length of paths of all soldiers 
		 * @return 
		 * 
		 */
		public function getAllPathsLength():uint
		{
			var retVal:uint=0;
			soldiersWithPath.splice(0,soldiersWithPath.length);
			findSoldiersWithPath(soldiersWithPath);
			for(var id:String in soldiersWithPath){
				character=soldiersWithPath[id];
				retVal+=character.path.length-1;
			}
			return retVal;
			
		}
		
		/**
		 * Check whether we have soldiers left to spawn 
		 * @param isBlue
		 * @return 
		 * 
		 */
		public function soldiersInCastle(isBlue:Boolean=false):Boolean
		{
			if(isBlue){
				return(maxSoldiers-blueSoldiers.length>0);
			}else{
				return(maxSoldiers-greenSoldiers.length>0);
			}
		}
		
		/**
		 * Check if we have bombs left to spawn 
		 * @param isBlue
		 * @return 
		 * 
		 */
		public function bombsInCastle(isBlue:Boolean=false):Boolean
		{
			if(isBlue){
				return(maxBombs-blueBombs.length>0);
			}else{
				return(maxBombs-greenBombs.length>0);
			}
		}
		
		/**
		 * Create an explosion  
		 * @param tp : 2D tile point
		 * @param ip : Isometric position
		 * 
		 */
		private function spawnExplosion(tp:Point,ip:Point):void
		{
			ResourceManager.playSound("ExplodeSfx");
			var explosion:Explosion=new Explosion(tp,ip);
			explosions.push(explosion);
			
			explosion.f.x=explosion.s.x=explosion.paintPointIso.x;
			explosion.f.y=explosion.s.y=explosion.paintPointIso.y;
			stageRef.addChild(explosion.s);
			stageRef.addChild(explosion.f);
		}
		public function dispose():void{
			character=null;
			aBomb=null;
			soldiersWithPath.splice(0,soldiersWithPath.length);
			groundLayer=null;
			
			realtimeCollision.splice(0,realtimeCollision.length);
		}
		
		/**
		 * Find a soldier around the touch point, effective for small screen devices 
		 * @param newTp
		 * @param isBlue
		 * @return 
		 * 
		 */
		public function getTouchedSoldier(newTp:Point, isBlue:Boolean=false):Soldier
		{
			var tp:Point=newTp.clone();
			var soldier:Soldier;
			soldier=hasASoldier(tp,isBlue);
			if(soldier){
				return soldier;
			}
			var clon:Point=new Point();
			for (var i:int = -1; i < 2; i++) {
				for (var j:int = -1; j < 2; j++) {
					
					
					clon.x = tp.x + i;
					clon.y = tp.y + j;
					
					soldier=hasASoldier(clon,isBlue);
					if(soldier){
						return soldier;
					}
				}
			}
			return soldier;
		}
		
		/**
		 * From a screen touch point find which direction to move & return point in that direction 
		 * for selected character 
		 * @param lastTp
		 * @param tx
		 * @param ty
		 * @return 
		 * 
		 */
		public function findDirectionalPoint(lastTp:Point, tx:Number,ty:Number):Point
		{
			var tp:Point=lastTp.clone();
			var deltaY:Number=stageSize.y/6;
			var deltaX:Number=stageSize.x/6;
			if(tx<stageSize.x/2+deltaX && tx>stageSize.x/2-deltaX){
				if(ty>stageSize.y/2+deltaY){
					//trace("down");
					tp.y+=1;
				}else if(ty<stageSize.y/2-deltaY){
					//trace("up");
					tp.y-=1;
				}else{
					return minusPoint;
				}
			}else if(ty<stageSize.y/2+deltaY && ty>stageSize.y/2-deltaY){
				if(tx>stageSize.x/2+deltaX){
					//trace("right");
					tp.x+=1;
				}else if(tx<stageSize.x/2-deltaX){
					//trace("left");
					tp.x-=1;
				}else{
					return minusPoint;
				}
			}else{
				
				return minusPoint;
				
			}
			return tp;
		}

		public function get stageRef():MainLevel
		{
			return _stageRef;
		}

		public function set stageRef(value:MainLevel):void
		{
			_stageRef = value;
			stageSize=new Point(_stageRef.stage.stageWidth,_stageRef.stage.stageHeight);
		}

	}
	
}