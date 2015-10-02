package com.csharks.juwalbose.utils
{
	// =================================================================================================
	//
	//  ctp2nd's constants / iOS device detect-o-matic
	//	This is probably far from optimal, but, as I tell my wife, 'It was good for me.'
	//  <a href="http://www.ctpstudios.com" rel="nofollow">http://www.ctpstudios.com</a> | ctp2nd @ gmail / gtalk / twitter
	//
	// =================================================================================================
	
	
	//
	
	import flash.system.Capabilities;
	
	public class DeviceManager
	{
		
		// first check to see if we're on the device or in the debugger //
		public static const isDebugger:Boolean = Capabilities.isDebugger;
		// set a few variables that'll help us deal with the debugger//
		public static var isLandscape:Boolean = true;  // most of my games are in landscape
		//public static const debuggerDevice:String = "iPhone3"; // iPhone3 = iPhone4,4s, etc.
		
		// we create an object here that'll keep a detailed abount of the current environment.
		public static var DeviceDetails:Object = getDeviceDetails();
		
		public static var isAndroid:Boolean=false;
		public static var isIOS:Boolean=false;
		public static var isPC:Boolean=false;
		public static var isIpad:Boolean=false;
		public static var isRetina:Boolean=false;
		public static var isSimulator:Boolean=false;
		
		
		private static function getDeviceDetails():Object{
			//detect device
			var OS:String=Capabilities.manufacturer;
			trace("OS:"+OS);
			if (OS.lastIndexOf("Android")!=-1) {
				isAndroid=true;
				return(loadAndroidDefaults());
			} else if (OS.lastIndexOf("iOS")!=-1) {
				//iOS
				isIOS=true;
				return(getIOSDeviceDetails());
			}else{
				//PC
				isPC=true;
				return(loadDesktopDefaults());
			}
		}
		
		public static function loadAndroidDefaults():Object {
			trace("Android defaults");
			var retObj:Object = {};
			retObj.device = "android";
			return retObj;
		}
		public static function loadDesktopDefaults():Object {
			trace("PC defaults");
			var retObj:Object = {};
			retObj.device = "PC";
			return retObj;
		}
		public static function loadIOSDefaults():Object {
			trace("IOS defaults");
			var retObj:Object = {};
			retObj.device = "iphone";
			isRetina=false;
			isIpad=false;
			return retObj;
		}
		public static function getIOSDeviceDetails():Object {
			var retObj:Object = {};
			
			var devStr:String = Capabilities.os;
			trace(devStr);
			var devStrArr:Array = devStr.split(" ");
			devStr = devStrArr.pop();
			if(devStr.indexOf("iPad")>-1){
				isIpad=true;
				trace("iPad yeah");
				if (w <= 1024)
				{
				retObj.device = "ipad";
				}else{
					retObj.device = "ipad retina";
					isRetina=true;
				}
			}else if(devStr.indexOf("iPhone")>-1||devStr.indexOf("iPod")>-1){
				isIpad=false;
				var w:int = Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
				var h:int = Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
				if (w <= 480)
				{
					isRetina=false;
					retObj.device = "iphone";
					
				}
				else if (w<=960)
				{
					isRetina=true;
					trace("Retina Yeah");
					retObj.device = "iphone4";
				}
				else
				{
					isRetina=true;
					trace("4' Retina Yeah");
					retObj.device = "iphone 5";
				}
				
			}else if(devStr.indexOf(",") == -1){
				isSimulator=true;
				devStr = Capabilities.os;
				
				w = Math.max(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
				h = Math.min(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
				if (w <= 480)
				{
					isRetina=false;
					retObj.device = "iphone sim";
					
				}else if (w<=960)
				{
					isRetina=true;
					trace("Retina Sim Yeah");
					retObj.device = "iphone4 sim";
				}else if (w<=1136 && h<=640)
				{
					isRetina=true;
					trace("Retina Sim Yeah");
					retObj.device = "4' iphone 5 sim";
				}
				else if (w<=1024)
				{
					isRetina=false;
					isIpad=true;
					trace("iPad Sim yeah");
					retObj.device = "ipad sim";
				}else{
					isRetina=true;
					isIpad=true;
					trace("iPad Sim yeah");
					retObj.device = "ipad retina sim";
				}
				trace("Hmm Simulator");
			}else {
				trace("Hmm Unknown IOS device");
				retObj=loadIOSDefaults();
			}
			
			trace("IOS device:"+retObj.device);
			return retObj;
		}
		
	}
	
}