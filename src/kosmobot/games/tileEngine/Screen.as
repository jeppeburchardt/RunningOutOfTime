package kosmobot.games.tileEngine 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Jeppe Burchardt
	 */
	public class Screen extends Sprite 
	{
		private var renderArea : Rectangle;
		
		private var areas : Array;
		private var tiles : Vector.<Tile> = new Vector.<Tile>;
		private var tilesInAreas : Array;
		private var tilesInScreen : Array = new Array();
		private var currentAreaX:Number;
		private var currentAreaY:Number;
		
		public function Screen(width:Number, height:Number) 
		{
			renderArea = new Rectangle(0, 0, width, height);
		}
		
		public function addTile(tile:Tile) : void
		{
			tiles.push(tile);
		}
		
		public function initializeAreas() : void
		{
			areas = new Array();
			
			for (var i : int = 0; i < tiles.length; i++)
			{
				var tile = tiles[i];
				var minXArea : Number = Math.floor(tile.position.left / renderArea.width);
				var maxXArea : Number = Math.ceil(tile.position.right / renderArea.width);
				var minYArea : Number = Math.floor(tile.position.top / renderArea.height);
				var maxYArea : Number = Math.ceil(tile.position.bottom / renderArea.height);
				
				for (var x : int = minXArea; x < maxXArea; x++)
				{
					for (var y : int = minYArea; y < maxYArea; y++)
					{
						if (!areas[x]) {
							areas[x] = new Array();
						}
						if (!areas[x][y]) {
							areas[x][y] = new Array();
						}
						
						trace("adding tile " + i + " to area " + x + "," + y);
						
						areas[x][y][i] = true;
					}
				}
			}
		}
		
		public function updateTilesInAreas() : void
		{
			tilesInAreas = new Array();
			var posx = Math.floor(renderArea.x / renderArea.width);
			var posy = Math.floor(renderArea.y / renderArea.height);
			
			for (var x : int = posx; x < posx + 1; x++ )
			{
				for (var y : int = posy; y < posy + 1; y++ )
				{
					for (var n : String in areas[x][y])
					{
						tilesInAreas[n] = true;
					}
				}
			}
			trace("updated tiles in areas (" + tilesInAreas.length + " tiles)");
		}
		
		public function addTilesToScreen() : void
		{
			//this can be optimized...
			for (var n : String in tilesInAreas) 
			{
				if (tilesInScreen[n] == null || !tilesInScreen[n]) 
				{
					var tile : Tile = tiles[n];
					if (renderArea.intersects(tile.position))
					{
						addChild(tile);
						tilesInScreen[n] = true;
						trace("adding tile(" + n + ") to screen");
					}
				}
			}
		}
		
		public function render() : void
		{
			var areaX : Number = Math.floor(renderArea.x / renderArea.width);
			var areaY : Number = Math.floor(renderArea.y / renderArea.height);
			
			if (areaX != currentAreaX || areaY != currentAreaY) {
				currentAreaX = areaX;
				currentAreaY = areaY;
				updateTilesInAreas();
			}
			
			addTilesToScreen();
			
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000);
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, renderArea.width, renderArea.height);
			
			for (var n : String in tilesInScreen)
			{
				var tile : Tile = tiles[n];
				tile.render();
			}
		}
	}

}