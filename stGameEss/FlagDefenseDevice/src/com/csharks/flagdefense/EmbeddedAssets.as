package com.csharks.flagdefense
{
	
    public class EmbeddedAssets
    {
        
        // Embed the Ubuntu Font. Beware: the 'embedAsCFF'-part IS REQUIRED!!!
		[Embed(source="../../../../assets/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]
		public static const UbuntuRegular:Class;
		
		/*[Embed(source="../../../../assets/BaseBg.jpg")]
		public static const BaseBg:Class;*/
    }
}