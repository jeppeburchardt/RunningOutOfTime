package kosmobot.games.platform.events
{
	import flash.events.Event;
	import kosmobot.games.platform.tiles.TileBase;
	
	public class TileEvent extends Event
	{
		
		public static const ADDED : String = "tileAdded";
		public static const REMOVED : String = "tileRemoved";
		public static const PERMANENT_ADDED : String = "permaneneAdded";
		
		private var _tile : TileBase;
		
		public function TileEvent(type:String, tile:TileBase)
		{
			super(type);
			this.tile = tile;
		}
		
		public function get tile():TileBase { return _tile; }
		public function set tile(value:TileBase):void {
			_tile = value;
		}
		
	}
	
}