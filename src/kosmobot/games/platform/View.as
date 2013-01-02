package kosmobot.games.platform
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import kosmobot.games.platform.events.TileEvent;
	import kosmobot.games.platform.performance.Graph;
	import kosmobot.games.platform.Scene;
	import kosmobot.games.platform.tiles.TileBase;
	
	import flash.system.fscommand;
	
	
	public class View extends Sprite
	{
		private var scene : Scene;
		private var envioronment : Envioronment;
		private var rect : Rectangle;
		private var offset : Point;
		
		private var currentAreaPosition : Point;
		private var _visibleTilesNum : uint = 0;
		private var visibleTiles : Array = new Array();
		private var addedTiles : Array = new Array();
		private var tilesInCurrentAreas : Array = new Array();
		
		public function View(scene:Scene, envioronment:Envioronment, x:Number, y:Number)
		{
			this.envioronment = envioronment;
			this.scene = scene;
			offset = new Point(x, y);
			rect = new Rectangle(0, 0, scene.areaWidth, scene.areaHeight);
			currentAreaPosition = new Point( -1, -1);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			scene.addEventListener(TileEvent.PERMANENT_ADDED, permanentAdded);
		}
		
		private function permanentAdded(e:TileEvent):void
		{
			fscommand("trace", e.tile.toString());
			addedTiles[e.tile.id] = true;
			addChild(e.tile);
			visibleTilesNum++;
			dispatchEvent(new TileEvent(TileEvent.ADDED, e.tile));
		}
		
		private function areaChanged():void
		{
			/*
			 *  +-+-+
			 *  |A|B|
			 *  +-+-+
			 *  |C|D|
			 *  +-+-+
			 */
			var tiles : Array = new Array();
			var register : Function = function(value:Boolean, id:int, a:Array):void
			{
				tiles[id] = true;
			}
			
			var areaA : Array = scene.getTilesInArea(currentAreaPosition.x, currentAreaPosition.y);
			areaA.forEach(register);
			//tiles.unshift.apply(tiles, areaA);
			
			var areaB : Array = scene.getTilesInArea(currentAreaPosition.x+1, currentAreaPosition.y);
			areaB.forEach(register);
			//tiles.unshift.apply(tiles, areaB);
			
			var areaC : Array = scene.getTilesInArea(currentAreaPosition.x, currentAreaPosition.y+1);
			areaC.forEach(register);
			//tiles.unshift.apply(tiles, areaC);
			
			var areaD : Array = scene.getTilesInArea(currentAreaPosition.x+1, currentAreaPosition.y+1);
			areaD.forEach(register);
			//tiles.unshift.apply(tiles, areaD);
			
			
			tilesInCurrentAreas = new Array();
			tiles.forEach(function(value:Boolean, id:uint, a:Array) : void
			{
				//fscommand("trace", "platformsInCurrentAreas " + tile.toString());
				tilesInCurrentAreas[id] = true;
			});
		}
		
		private function enterFrame(e:Event):void
		{
			Graph.startTimer("tileEngine");
			
			envioronment.addRelativeTime();
			
			if (rect.x < 0)
			{
				rect.x = 0;
			}
			if (rect.y < 0)
			{
				rect.y = 0;
			}
			if (rect.right > scene.rect.right)
			{
				rect.x = scene.rect.width - rect.width;
			}
			if (rect.bottom > scene.rect.bottom)
			{
				rect.y = scene.rect.height - rect.height;
			}
			
			
			
			var areaX : uint = Math.floor(rect.x / rect.width);
			var areaY : uint = Math.floor(rect.y / rect.height);
			
			addTiles();
			
			if (areaX != currentAreaPosition.x || areaY != currentAreaPosition.y)
			{
				fscommand("trace", "new area " + areaX + " " + areaY);
				
				currentAreaPosition.x = areaX;
				currentAreaPosition.y = areaY;
				
				areaChanged();
				
				/*
				graphics.clear();
				graphics.lineStyle(0, 0x00FF00, 0.5);
				graphics.drawRect((areaX * rect.width), (areaY * rect.height), rect.width*2, rect.height*2);
				graphics.endFill();
				graphics.moveTo((areaX * rect.width)+ rect.width, (areaY * rect.height));
				graphics.lineTo((areaX * rect.width) + rect.width, (areaY * rect.height) + rect.height * 2);
				graphics.moveTo((areaX * rect.width), (areaY * rect.height) + rect.height);
				graphics.lineTo((areaX * rect.width) + rect.width * 2, (areaY * rect.height) + rect.height);
				*/
				
				//graphics.lineStyle(0, 0x0000FF);
				//graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				
			}
			else
			{
				removeTiles();
			}
			
			graphics.clear();
			graphics.lineStyle(0, 0xFFFF00);
			visibleTiles.forEach(function(value:Boolean, id:int, a:Array) : void
			{
				var tile : TileBase = TileBase.ALL[id];
				tile.render(envioronment.currentTime);
				graphics.drawRect(tile.rect.x, tile.rect.y, tile.rect.width, tile.rect.height);
			});
			
			x = Math.round(offset.x - rect.x);
			y = Math.round(offset.y - rect.y);
			
			
			Graph.stopTimer("tileEngine");
		}
		
		private function addTiles():void
		{
			visibleTiles = new Array();
			tilesInCurrentAreas.forEach(function(value:Boolean, id:uint, a:Array) : void
			{
				var tile : TileBase = TileBase.ALL[id];
				if (rect.intersects(tile.rect))
				{
					visibleTiles[id] = true;
					if (!contains(tile))
					{
						addedTiles[id] = true;
						addChild(tile);
						visibleTilesNum++;
						dispatchEvent(new TileEvent(TileEvent.ADDED, tile));
						
						//graphics.lineStyle(3, 0xFFFF00, 0.5);
						//graphics.drawRect(tile.rect.x, tile.rect.y, tile.rect.width, tile.rect.height);
					}
				}
			});
		}
		
		private function removeTiles():void
		{
			addedTiles.forEach(function(value:Boolean, id:uint, a:Array):void
			{
				
				if (!visibleTiles[id])
				{
					var tile : TileBase = TileBase.ALL[id];
					if (contains(tile))
					{
						delete addedTiles[id];
						removeChild(tile);
						visibleTilesNum--;
						dispatchEvent(new TileEvent(TileEvent.REMOVED, tile));
					}
					
				}
				
			});
		}
		
		public function get viewX():Number { return rect.x; }
		public function set viewX(value:Number):void {
			rect.x = value;
		}
		
		public function get viewY():Number { return rect.y; }
		public function set viewY(value:Number):void {
			rect.y = value;
		}
		
		public function get visibleTilesNum():uint { return _visibleTilesNum; }
		public function set visibleTilesNum(value:uint):void {
			_visibleTilesNum = value;
		}
	}
	
}