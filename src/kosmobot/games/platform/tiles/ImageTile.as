package kosmobot.games.platform.tiles
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	
	public class ImageTile extends TileBase
	{
		private var fill : Boolean;
		
		public function ImageTile(x:Number, y:Number, width:Number, height:Number, gfx:String="gfx/pillar.png", fill:Boolean=false)
		{
			super(x, y, width, height);
			
			this.fill = fill;
			var loader : Loader = new Loader();
			loader.load(new URLRequest(gfx));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
		}
		
		private function loaded(e:Event):void
		{
			graphics.clear();
			var img : Bitmap = LoaderInfo(e.target).loader.content as Bitmap;
			if (fill)
			{
				var matrix : Matrix = new Matrix();
				matrix.translate( -rect.width/2, -rect.height/2);
				graphics.beginBitmapFill(img.bitmapData, matrix);
				graphics.drawRect( -rect.width/2, -rect.height/2, rect.width, rect.height);
				graphics.endFill();
			}
			else
			{
				img.x = -rect.width/2;
				img.y = -rect.height / 2;
				addChild(img);
			}
		}
		
	}
	
}