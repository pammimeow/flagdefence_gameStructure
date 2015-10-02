package com.csharks.flagdefense.scenes
{
	import com.csharks.flagdefense.helpers.SkeletonScene;
	import com.csharks.juwalbose.events.GameEvent;
	import com.csharks.juwalbose.utils.ResourceManager;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class ScoreScene extends SkeletonScene
	{
		private var assetManager:AssetManager;
		private var backBtn:starling.display.Button;
		private var SR:Number;
		
		private var _list:List;
		public function ScoreScene()
		{
			super();
		}
		protected override function init(e:Event):void 
		{
			super.init(e);
			
			initUi();
			
		}
		private function initUi():void{
			var container:Sprite=new Sprite();
			assetManager=ResourceManager.assets;
			SR=ResourceManager.scaleRatio;
			var base:Image=new Image(assetManager.getTexture("BaseBg"));
			container.addChild(base);
			container.flatten();
			container.scaleX=stage.stageWidth/base.width;
			container.scaleY=stage.stageHeight/base.height;
			addChild(container);
			backBtn=new starling.display.Button(assetManager.getTexture("backbtn"));
			
			backBtn.x=stage.stageWidth/2-backBtn.width/2;
			backBtn.y=stage.stageHeight-backBtn.height-(20*SR);
			
			addChild(backBtn);
			backBtn.addEventListener(Event.TRIGGERED, handleButtonPress);
			
			populateList();
		}
		private function populateList():void{
			
			var items:Array = [];
			for(var i:int = 0; i < 10; i++)
			{
				var item:Object = {text: "Name " + (i + 1).toString(), score: "Score " + (i + 1).toString()};
				items.push(item);
			}
			items.fixed = true;
			
			this._list = new List();
			this._list.width=1024*SR;
			this._list.height=1000*SR;
			this._list.dataProvider = new ListCollection(items);
			this._list.typicalItem = {text: "Item 1000", score: "Score 2000"};
			this._list.isSelectable = false;
			this._list.hasElasticEdges = true;
			//optimization to reduce draw calls.
			//only do this if the header or other content covers the edges of
			//the list. otherwise, the list items may be displayed outside of
			//the list's bounds.
			this._list.clipContent = false;
			this._list.itemRendererProperties.horizontalAlign = feathers.controls.Button.HORIZONTAL_ALIGN_CENTER;
			this._list.itemRendererProperties.verticalAlign = feathers.controls.Button.VERTICAL_ALIGN_MIDDLE;
			this._list.itemRendererProperties.iconPosition =  feathers.controls.Button.ICON_POSITION_TOP;
			this._list.itemRendererProperties.gap = 10;
			this._list.touchable=false;
			var ht:Number=this._list.height;
			this._list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				renderer.isQuickHitAreaEnabled = true;
				renderer.height=ht/10;
				renderer.itemHasIcon=false;
				renderer.accessoryLabelField="score";
				return renderer;
			};
			//this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._list);
		}
		private function handleButtonPress(e:Event=null):void{
			ResourceManager.playSound("ButtonSfx");
			backBtn.removeEventListener(Event.TRIGGERED, handleButtonPress);
			var evt:GameEvent=new GameEvent("menu");
			dispatchEvent(evt);
		}
		public override function backButtonPressed():void{
			handleButtonPress();
		}
		public override function dispose():void{
			this.removeChildren(0,-1,true);
			super.dispose();
		}
	}
}