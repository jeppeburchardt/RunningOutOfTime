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
		private var tilesInArea : Vector.<Tile>;
		private var tilesInScreen : Vector.<Tile>;
		
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
			
			for each (var tile : Tile in tiles)
			{
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
						
						trace("adding tile " + tile.seed + " to area " + x + "," + y);
						
						areas[x][y].push(tile);
					}
				}
			}
		}
		
		public function updateTilesInArea()
		{
			var posx = Math.floor(renderArea.x / renderArea.width);
			var posy = Math.floor(renderArea.y / renderArea.height);
			
			for (var x : int = pox; x < posx + 1; x++ )
			{
				for (var y : int = poy; y < posy + 1; y++ )
				{
					for each (var tile in )
					{
						
					}
				}
			}
		}
		
		public function render() : void
		{
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000);
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, renderArea.width, renderArea.height);
			
			for each(var tile : Tile in tilesInScreen)
			{
				tile.render();
			}
		}
	}

}