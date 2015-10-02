package com.csharks.flagdefense
{
	import com.csharks.juwalbose.GameEvent;
	import com.csharks.juwalbose.ResourceManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class GameUi extends Sprite
	{
		private var playBtn:Button;
		private var diceBtn:Button;
		private var bombBtn:Button;
		private var soldierBtn:Button;
		private var diceAnim:Dice;
		
		private var assetsManager:AssetManager;
		
		public function GameUi(_scaleRatio:Number, _dice:Dice)
		{
			super();
			initialise(_scaleRatio, _dice);
		}
		public function initialise(_scaleRatio:Number, _dice:Dice):void{
			assetsManager=ResourceManager.assets;
			diceAnim=_dice;
			//diceAnim.toggle();
			addChild(new Image(assetsManager.getTexture("uibase")));
			playBtn=new Button(assetsManager.getTexture("buttonbase"));
			diceBtn=new Button(assetsManager.getTexture("buttonbase"));
			bombBtn=new Button(assetsManager.getTexture("buttonbase"));
			soldierBtn=new Button(assetsManager.getTexture("buttonbase"));
			var bomb:Image=new Image(assetsManager.getTexture("bomb"));
			var soldier:Image=new Image(assetsManager.getTexture("soldier_green_walk_down_01"));
			var play:Image=new Image(assetsManager.getTexture("play"));
			playBtn.y=diceBtn.y=bombBtn.y=soldierBtn.y=40*_scaleRatio;
			play.x=playBtn.x=50*_scaleRatio;
			bomb.x=bombBtn.x=310*_scaleRatio;
			soldier.x=soldierBtn.x=580*_scaleRatio;
			diceBtn.x=830*_scaleRatio;
			
			play.y=playBtn.y+playBtn.height/2-play.height/2;
			play.x=playBtn.x+playBtn.width/2-play.width/2;
			bomb.y=bombBtn.y+bombBtn.height/2-bomb.height/2;
			bomb.x=bombBtn.x+bombBtn.width/2-bomb.width/2;
			soldier.y=soldierBtn.y+soldierBtn.height/2-soldier.height/2;
			soldier.x=soldierBtn.x+soldierBtn.width/2-soldier.width/2;
			diceAnim.x=diceBtn.x+diceBtn.width/2-diceAnim.width/2;
			diceAnim.y=30*_scaleRatio;
			addChild(playBtn);
			addChild(diceBtn);
			addChild(bombBtn);
			addChild(soldierBtn);
			addChild(play);
			addChild(bomb);
			addChild(soldier);
			addChild(diceAnim);
			soldier.touchable=play.touchable=bomb.touchable=false;
			
			
			playBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			bombBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			soldierBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			diceBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			
			//this.alpha=0.5;
		}
		
		public function toggleButtons(playButtonEnabled:int, bombButtonEnabled:int, soldierButtonEnabled:int, diceButtonEnabled:int):void
		{
			playBtn.enabled=playButtonEnabled;
			bombBtn.enabled=bombButtonEnabled;
			soldierBtn.enabled=soldierButtonEnabled;
			diceBtn.enabled=diceButtonEnabled;
		}
		private function handleButtonPress(e:Event):void{
			var evt:GameEvent=new GameEvent("dummy");
			switch(e.target){
				case playBtn:
					evt.command="play";
					break;
				case bombBtn:
					evt.command="bomb";
					break;
				case soldierBtn:
					evt.command="soldier";
					break;
				case diceBtn:
					evt.command="dice";
					break;
			}
			dispatchEvent(evt);
		}
		public override function dispose():void{
			playBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			bombBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			soldierBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			diceBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}