package kosmobot.games.platform
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.system.fscommand;
	import kosmobot.games.platform.events.TileEvent;
	import kosmobot.games.platform.tiles.TileBase;
	
	public class Scene extends EventDispatcher
	{
		private var _rect : Rectangle;
		private var permanentTiles : Array = new Array();
		private var areas : Array = new Array();
		
		private var _areaWidth : Number;
		private var _areaHeight : Number;
		
		public function Scene(width:Number, height:Number, areaWidth:Number, areaHeight:Number)
		{
			rect = new Rectangle(0, 0, width, height);
			this.areaWidth = areaWidth;
			this.areaHeight = areaHeight;
		}
		
		public function translateTile(tile:TileBase, xIncrement:Number=0, yIncrement:Number=0, rotationIncrement:Number=0) : void
		{
			var deltaRect : Rectangle = tile.rect.clone();
			var deltaR : Number = tile.rotation;
			
			tile.x += xIncrement;
			tile.y += yIncrement;
			
			if (yIncrement > 0)
			{
				//tile is moving down
				//check if it enters a new area:
				var oldHighestYArea : int = Math.floor(deltaRect.bottom / areaHeight);
				var newHighestYArea : int = Math.floor(tile.rect.bottom / areaHeight);
				if (oldHighestYArea != newHighestYArea)
				{
					var minX : Number = Math.floor(tile.x / areaWidth);
					var maxX : Number = Math.floor((tile.x + tile.width) / areaWidth);
					for (var areaX : uint = minX; areaX <= maxX; areaX++)
					{
						registerTileToArea(areaX, newHighestYArea, tile);
					}
					fscommand("trace", tile.toString() + " enters a new Y area");
				}
			}
			else if (yIncrement < 0)
			{
				//tile is moving up
				//check if it enters a new area:
				var oldLowestYArea : int = Math.floor(deltaRect.top / areaHeight);
				var newLowestYArea : int = Math.floor(tile.rect.top / areaHeight);
				if (oldLowestYArea != newLowestYArea)
				{
					var minX : Number = Math.floor(tile.x / areaWidth);
					var maxX : Number = Math.floor((tile.x + tile.width) / areaWidth);
					for (var areaX : uint = minX; areaX <= maxX; areaX++)
					{
						registerTileToArea(areaX, newLowestYArea, tile);
					}
					fscommand("trace", tile.toString() + " enters a new Y area");
				}
			}
			
			if (xIncrement > 0)
			{
				//tile is moving right
				//check if it enters a new area:
				var oldHighestXArea : int = Math.floor(deltaRect.right / areaWidth);
				var newHighestXArea : int = Math.floor(tile.rect.right / areaWidth);
				if (oldHighestXArea != newHighestXArea)
				{
					var minY : Number = Math.floor(tile.y / areaHeight);
					var maxY : Number = Math.floor((tile.y + tile.height) / areaHeight);
					for (var areaY : uint = minY; areaY <= maxY; areaY++)
					{
						registerTileToArea(newHighestXArea, areaY, tile);
					}
					fscommand("trace", tile.toString() + " enters a new X area");
				}
			}
			else if (xIncrement < 0)
			{
				///tile is moving left
				//check if it enters a new area:
				var oldLowestXArea : int = Math.floor(deltaRect.left / areaWidth);
				var newLowestXArea : int = Math.floor(tile.rect.left / areaWidth);
				if (oldLowestXArea != newLowestXArea)
				{
					var minY : Number = Math.floor(tile.y / areaHeight);
					var maxY : Number = Math.floor((tile.y + tile.height) / areaHeight);
					for (var areaY : uint = minY; areaY <= maxY; areaY++)
					{
						registerTileToArea(newLowestXArea, areaY, tile);
					}
					fscommand("trace", tile.toString() + " enters a new X area");
				}
			}
			
			if (rotationIncrement != 0)
			{
				//update the tiles rect
				tile.rotation += rotationIncrement;
			}
		}
		
		public function addTile(tile:TileBase, permanent:Boolean=false) : void
		{
			if (!permanent)
			{
				registerTileToAreas(tile);
			}
			else
			{
				fscommand("trace", "new permanent tile");
				permanentTiles.push(tile);
				dispatchEvent(new TileEvent(TileEvent.PERMANENT_ADDED, tile));
			}
		}
		
		public function getTilesInArea(areaX:uint, areaY:uint) : Array
		{
			if (areas[areaX] != null && areas[areaX][areaY] != null)
			{
				return areas[areaX][areaY] as Array;
			}
			else
			{
				return new Array();
			}
		}
		
		private function registerTileToAreas(tile:TileBase) : void
		{
			var minX : Number = Math.floor(tile.x / areaWidth);
			var maxX : Number = Math.floor((tile.x + tile.width) / areaWidth);
			
			var minY : Number = Math.floor(tile.y / areaHeight);
			var maxY : Number = Math.floor((tile.y + tile.height) / areaHeight);
			
			for (var areaX : uint = minX; areaX <= maxX; areaX++)
			{
				for (var areaY : uint = minY; areaY <= maxY; areaY++)
				{
					registerTileToArea(areaX, areaY, tile);
				}
			}
		}
		private function unregisterTileFromAreas(tile:TileBase) : void
		{
			var minX : Number = Math.floor(tile.x / areaWidth);
			var maxX : Number = Math.floor((tile.x + tile.width) / areaWidth);
			
			var minY : Number = Math.floor(tile.y / areaHeight);
			var maxY : Number = Math.floor((tile.y + tile.height) / areaHeight);
			
			for (var areaX : uint = minX; areaX <= maxX; areaX++)
			{
				for (var areaY : uint = minY; areaY <= maxY; areaY++)
				{
					unregisterTileFromArea(areaX, areaY, tile);
				}
			}
		}
		
		private function unregisterTileFromArea(areaX:uint, areaY:uint, tile:TileBase) : void
		{
			delete areas[areaX][areaY][tile.id];
		}
		
		private function registerTileToArea(areaX:uint, areaY:uint, tile:TileBase) : void
		{
			//fscommand("trace", "register " + tile.toString() + " to " + x + "x" + y);
			if (areas[areaX] == null)
			{
				areas[areaX] = new Array();
			}
			if (areas[areaX][areaY] == null)
			{
				areas[areaX][areaY] = new Array();
			}
			areas[areaX][areaY][tile.id] = true;
		}
		
		public function debugAreas() : void
		{
			areas.forEach(function(a:Array, x:uint, aa:Array) : void
			{
				a.forEach(function(b:Array, y:uint, ab:Array) : void
				{
					fscommand("trace", "area " + x + "x" + y + " contains: " + b.toString());
				});
			});
		}
		
		public function get rect():Rectangle { return _rect; }
		public function set rect(value:Rectangle):void {
			_rect = value;
		}
		
		public function get areaWidth():Number { return _areaWidth; }
		public function set areaWidth(value:Number):void {
			_areaWidth = value;
		}
		
		public function get areaHeight():Number { return _areaHeight; }
		public function set areaHeight(value:Number):void {
			_areaHeight = value;
		}
	}
}