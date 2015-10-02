package com.csharks.flagdefense.helpers
{
	import com.csharks.flagdefense.scenes.GameOver;
	import com.csharks.flagdefense.scenes.HelpScene;
	import com.csharks.flagdefense.scenes.MainLevel;
	import com.csharks.flagdefense.scenes.MainMenu;
	import com.csharks.flagdefense.scenes.MultiSamePc;
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import starling.display.DisplayObjectContainer;
	
	public class SceneManager extends DisplayObjectContainer
	{
		private var currentScene:DisplayObjectContainer;
		
		public function SceneManager()
		{
			super();
			if(ResourceManager.soundEnabled){
				ResourceManager.startMusic();
			}
			this.addEventListener(GameEvent.CONTROL_TYPE,onGameEvent);
			
			
		}
		public function launchMenu():void{
			currentScene=new MainMenu();
			addChild(currentScene);
		}
		
		/**
		 * Listens to GameEvent & Swaps scenes 
		 * @param e
		 * 
		 */
		private function onGameEvent(e:GameEvent):void{
			switch(e.command){
				case "singlegame":
					currentScene.removeFromParent(true);
					currentScene=null;
					launchGame();
					break;
				case "multigame":
					currentScene.removeFromParent(true);
					currentScene=null;
					launchMultiGame();
					break;
				case "menu":
					currentScene.removeFromParent(true);
					currentScene=null;
					launchMenu();
					break;
				case "bluewin":
					currentScene.removeFromParent(true);
					currentScene=null;
					launchGameOver(true);
					break;
				case "greenwin":
					currentScene.removeFromParent(true);
					currentScene=null;
					launchGameOver(false,e.score);
					break;
				case "help":
					currentScene.removeFromParent(true);
					currentScene=null;
					launchHelp();
					break;
				case "lb":
					currentScene.removeFromParent(true);
					currentScene=null;
					
					break;
			}
		}
		private function launchHelp():void
		{
			currentScene=new HelpScene();
			addChild(currentScene);
		}
		private function launchGameOver(blueWins:Boolean=false,score:uint=0):void
		{
			currentScene=new GameOver(blueWins,score);
			addChild(currentScene);
		}
		
		private function launchGame():void
		{
			currentScene=new MainLevel();
			addChild(currentScene);
		}
		private function launchMultiGame():void
		{
			currentScene=new MultiSamePc();
			addChild(currentScene);
		}
	}
}