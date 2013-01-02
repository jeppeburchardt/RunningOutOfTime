package kosmobot.games.root 
{
	import flash.display.BitmapData;
	
	
	//TODO: Work in progress. Load only one bitmap in ram and use same bitmapdata in more then one time.
	
	
	public class GFX 
	{
		[Embed(source = "../../../../lib/gfx/box.png")]
		private const BOX : Class;
		
		private var cache : Object;
		
	}

}