package com.csharks.flagdefense
{
	
    public class EmbeddedAssets
    {
        /** ATTENTION: Naming conventions!
         *  
         *  - Classes for embedded IMAGES should have the exact same name as the file,
         *    without extension. This is required so that references from XMLs (atlas, bitmap font)
         *    won't break.
         *    
         *  - Atlas and Font XML files can have an arbitrary name, since they are never
         *    referenced by file name.
         * 
         */
        
        // Embed the Ubuntu Font. Beware: the 'embedAsCFF'-part IS REQUIRED!!!
		[Embed(source="../../../../assets/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]
		private static const UbuntuRegular:Class;
		
		
		// Texture Atlas
		
		[Embed(source = "../../../../assets/isotiles1024.xml", mimeType = "application/octet-stream")]
		public static const atlas_xml:Class;
		
		[Embed(source="../../../../assets/isotiles1024.png")]
		public static const isotiles1024:Class;

    }
}