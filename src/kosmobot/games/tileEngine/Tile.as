package kosmobot.games.tileEngine 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Jeppe Burchardt
	 */
	public class Tile extends Sprite 
	{
		private var _addedToScreen : Boolean = false;
		
		private var _position : Rectangle;
		
		function Tile(x:Number, y:Number, width:Number, height:Number)
		{
			_position = new Rectangle(x, y, height, width);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			this.x = position.x;
			this.y = position.y;
		}
		
		protected function removed(e:Event):void 
		{
			graphics.clear();
			_addedToScreen = false;
		}
		
		protected function added(e:Event):void 
		{
			graphics.clear();
			graphics.beginFill(0x0000FF, 0.8);
			graphics.drawRect(0, 0, position.width, position.height);
			_addedToScreen = true;
		}
		
		public function render() : void
		{
			
		}
		
		public function get position():Rectangle 
		{
			return _position;
		}
		
		public function get addedToScreen():Boolean 
		{
			return _addedToScreen;
		}
		
		public function set addedToScreen(value:Boolean):void 
		{
			_addedToScreen = value;
		}
	}

}