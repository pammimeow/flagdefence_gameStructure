package com.csharks.juwalbose
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ExplodingLevel extends DisplayObjectContainer
	{
		[Embed(source="../../../../bin-debug/media/isotiles.png")]
		public static const AssetTex:Class;
		
		[Embed(source = "../../../../assets/isotiles.xml", mimeType = "application/octet-stream")]
		private static const AssetXml:Class;
		
		private var texAtlas:TextureAtlas;
		private var rTex:RenderTexture;
		private var rTexImage:Image;
		private var screenOffset:Point=new Point(512,-294);
		
		private var tileWidth:uint=40;
		private var regPoints:Dictionary=new Dictionary();
		
		private var groundArray:Array=[["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0001.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0001.png","tiles0001.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0002.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0002.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0003.png","tiles0001.png","tiles0001.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0003.png","tiles0003.png","tiles0001.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0005.png","tiles0001.png","tiles0005.png","tiles0002.png","tiles0004.png","tiles0004.png","tiles0004.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0002.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0001.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0005.png","tiles0005.png","tiles0005.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0006.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"],["tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png","tiles0001.png"]];
		private var overlayArray:Array=[["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0001.png","nonwalk0001.png","nonwalk0001.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","nonwalk00013.png","*","*","nonwalk0006.png","nonwalk0006.png","nonwalk0006.png","nonwalk0006.png","nonwalk0006.png","nonwalk0007.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0002.png","*","*","*","*","*","nonwalk0007.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0002.png","*","*","*","*","*","nonwalk0007.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","nonwalk00011.png","*","*","*","*","*","*","*","*","nonwalk0007.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0009.png","*","*","*","*","*","nonwalk0007.png","nonwalk0003.png","*","flag green.png","flag green.png","flag green.png","flag green.png","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0007.png","nonwalk0008.png","*","*","*","*","*","*","nonwalk0005.png","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0005.png","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0009.png","*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0005.png","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","nonwalk00011.png","*","*","nonwalk0002.png","*","*","*","*","*","nonwalk0007.png","nonwalk0008.png","*","*","*","*","*","*","nonwalk0005.png","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0007.png","nonwalk0003.png","*","flag blue.png","flag blue.png","flag blue.png","flag blue.png","*","*","nonwalk0004.png","*","nonwalk00012.png","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0007.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","blue castle.png","*","*","*","*","*","nonwalk0007.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0006.png","nonwalk0006.png","nonwalk0006.png","nonwalk0006.png","nonwalk0006.png","nonwalk0007.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","nonwalk0001.png","nonwalk0001.png","nonwalk0001.png","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","green castle.png","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"],["*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*","*"]];
		
		public function ExplodingLevel()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			regPoints["blue castle.png"]=new Point(-59.5,227.5);
			regPoints["flag blue.png"]=new Point(11.5,44.5);
			regPoints["flag green.png"]=new Point(12.5,41.5);
			regPoints["green castle.png"]=new Point(-61.5,227.5);
			regPoints["nonwalk0001.png"]=new Point(7.5,52);
			regPoints["nonwalk00010.png"]=new Point(-11,16);
			regPoints["nonwalk00011.png"]=new Point(-13,14);
			regPoints["nonwalk00012.png"]=new Point(-3.5,88.5);
			regPoints["nonwalk00013.png"]=new Point(-15,100.5);
			regPoints["nonwalk0002.png"]=new Point(9.5,50);
			regPoints["nonwalk0003.png"]=new Point(7.5,52);
			regPoints["nonwalk0004.png"]=new Point(1.5,61);
			regPoints["nonwalk0005.png"]=new Point(8.5,56);
			regPoints["nonwalk0006.png"]=new Point(6.5,52);
			regPoints["nonwalk0007.png"]=new Point(6.5,51);
			regPoints["nonwalk0008.png"]=new Point(6.5,49);
			regPoints["nonwalk0009.png"]=new Point(-12,19);
			
			var tex:Texture =Texture.fromBitmap(new AssetTex(),false);
			var img:Image;
			texAtlas=new TextureAtlas(tex,XML(new AssetXml()));
			
			rTex=new RenderTexture(stage.stageWidth,stage.stageHeight);
			rTexImage= new Image(rTex);
			addChild(rTexImage);
			
			var pt:Point=new Point();
			for(var i:int=0;i<groundArray.length;i++){
				for(var j:int=0;j<groundArray[0].length;j++){
					img=new Image(texAtlas.getTexture(String(groundArray[i][j]).split(".")[0]));
					pt.x=j*tileWidth;
					pt.y=i*tileWidth;
					pt=IsoHelper.cartToIso(pt);
					img.x=pt.x+screenOffset.x;
					img.y=pt.y+screenOffset.y;
					rTex.draw(img);
					
					//draw overlay
					if(overlayArray[i][j]!="*"){
						img=new Image(texAtlas.getTexture(String(overlayArray[i][j]).split(".")[0]));
						img.x=pt.x+screenOffset.x;
						img.y=pt.y+screenOffset.y;
						if(regPoints[overlayArray[i][j]]!=null){
							img.x+=regPoints[overlayArray[i][j]].x;
							img.y-=regPoints[overlayArray[i][j]].y;
						}
						rTex.draw(img);
					}
				}
			}
			rTexImage.addEventListener(TouchEvent.TOUCH,onTouch);
			
			addEventListener(EnterFrameEvent.ENTER_FRAME,loop);
		}
		
		private function loop(e:EnterFrameEvent):void
		{
			Starling.juggler.advanceTime(e.passedTime);
		}
		private function onTouch(e:TouchEvent):void{
			var t:Touch=e.getTouch(rTexImage,TouchPhase.ENDED);
			if(t){
				var tp:Point=new Point(t.globalX,t.globalY);
				addExplosion(tp);
			}
		}
		
		private function addExplosion(tp:Point):void
		{
			var tex:Vector.<Texture>=texAtlas.getTextures("Explosion_");
			var exp:MovieClip=new MovieClip(tex);
			addChild(exp);
			Starling.juggler.add(exp);
			exp.x=tp.x-exp.width/2;
			exp.y=tp.y-exp.height/2;
			exp.addEventListener(Event.COMPLETE,animDone);
		}
		
		private function animDone(e:Event):void
		{
			var exp:MovieClip=e.target as MovieClip;
			Starling.juggler.remove(exp);
			exp.removeFromParent(true);
		}
		
	}
}



