package com.csharks.flagdefense.ui
{
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	
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
		private var blueSoldierImage:Image;
		private var greenSoldierImage:Image;
		private var blueBombImage:Image;
		private var greenBombImage:Image;
		private var playImage:Image;
		
		private var disabledAlpha:Number=0.6;
		
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
			greenBombImage=new Image(assetsManager.getTexture("greenbomb"));
			blueBombImage=new Image(assetsManager.getTexture("bluebomb"));
			greenSoldierImage=new Image(assetsManager.getTexture("soldier_green_walk_down_01"));
			blueSoldierImage=new Image(assetsManager.getTexture("soldier_blue_walk_right_01"));
			playImage=new Image(assetsManager.getTexture("play"));
			playBtn.y=diceBtn.y=bombBtn.y=soldierBtn.y=40*_scaleRatio;
			playBtn.x=50*_scaleRatio;
			bombBtn.x=310*_scaleRatio;
			soldierBtn.x=580*_scaleRatio;
			diceBtn.x=830*_scaleRatio;
			
			playImage.y=playBtn.y+playBtn.height/2-playImage.height/2;
			playImage.x=playBtn.x+playBtn.width/2-playImage.width/2;
			greenBombImage.y=blueBombImage.y=bombBtn.y+bombBtn.height/2-blueBombImage.height/2;
			greenBombImage.x=blueBombImage.x=bombBtn.x+bombBtn.width/2-blueBombImage.width/2;
			blueSoldierImage.y=greenSoldierImage.y=soldierBtn.y+soldierBtn.height/2-greenSoldierImage.height/2;
			blueSoldierImage.x=greenSoldierImage.x=soldierBtn.x+soldierBtn.width/2-greenSoldierImage.width/2;
			diceAnim.x=diceBtn.x+diceBtn.width/2-diceAnim.width/2;
			diceAnim.y=30*_scaleRatio;
			addChild(playBtn);
			addChild(diceBtn);
			addChild(bombBtn);
			addChild(soldierBtn);
			addChild(playImage);
			addChild(greenBombImage);
			addChild(greenSoldierImage);
			addChild(blueBombImage);
			addChild(blueSoldierImage);
			addChild(diceAnim);
			blueSoldierImage.touchable=greenSoldierImage.touchable=playImage.touchable=greenBombImage.touchable=blueBombImage.touchable=false;
			
			
			playBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			bombBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			soldierBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			diceBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			
			//this.alpha=0.5;
		}
		
		public function toggleButtons(button1:int, button2:int, button3:int, button4:int, bluesTurn:Boolean=false):void
		{
			if(bluesTurn){
				greenSoldierImage.visible=greenBombImage.visible=false;
				blueSoldierImage.visible=blueBombImage.visible=true;
				blueSoldierImage.alpha=disabledAlpha+(1-disabledAlpha)*button3;
				blueBombImage.alpha=disabledAlpha+(1-disabledAlpha)*button2;
			}else{
				greenSoldierImage.visible=greenBombImage.visible=true;
				blueSoldierImage.visible=blueBombImage.visible=false;
				greenSoldierImage.alpha=disabledAlpha+(1-disabledAlpha)*button3;
				greenBombImage.alpha=disabledAlpha+(1-disabledAlpha)*button2;
			}
			playImage.alpha=disabledAlpha+(1-disabledAlpha)*button1;
			
			playBtn.enabled=button1;
			bombBtn.enabled=button2;
			soldierBtn.enabled=button3;
			diceBtn.enabled=button4;
		}
		private function handleButtonPress(e:Event):void{
			var evt:GameEvent=new GameEvent("dummy");
			ResourceManager.playSound("ButtonSfx");
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