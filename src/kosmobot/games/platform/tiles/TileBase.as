package kosmobot.games.platform.tiles
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TileBase extends Sprite
	{
		public static var ALL : Array = new Array();
		
		private static var seed : uint = 0;
		private var _id : uint;
		private var _rect : Rectangle;
		
		private var _shape : String = "box";
		private var _fixed : Boolean = false;
		private var _mass : Number = 1;
		private var _elasticity : Number = 0.3;
		private var _friction : Number = 0;
		
		public var tempCollisionObjectPosition : Point;
		
		public function TileBase(x:Number, y:Number, width:Number, height:Number)
		{
			tempCollisionObjectPosition = new Point(x, y);
			
			id = seed ++;
			ALL[id] = this;
			
			
			_rect = new Rectangle(x - (width/2), y-(height/2), width, height);
			this.x = x;
			this.y = y;
			
			graphics.lineStyle(0, 0xFF0000);
			graphics.drawRect(-width/2, -height/2, width, height);
		}
		
		public override function toString() : String
		{
			return "TileBase("+id+")";
		}
		
		public override function set x(value:Number):void
		{
			super.x = value;
			_rect.x = value - (_rect.width / 2);
		}
		
		public override function set y(value:Number):void
		{
			super.y = value;
			_rect.y = value - (_rect.height / 2);
		}
		
		
		public override function set rotation(value:Number):void
		{
			super.rotation = value;
			_rect.width = width;
			_rect.height = height;
		}
		
		
		public function get rect():Rectangle { return _rect; }
		
		public function get id():uint { return _id; }
		public function set id(value:uint):void {
			_id = value;
		}
		
		public function get fixed():Boolean { return _fixed; }
		public function set fixed(value:Boolean):void {
			_fixed = value;
		}
		
		public function get mass():Number { return _mass; }
		public function set mass(value:Number):void {
			_mass = value;
		}
		
		public function get elasticity():Number { return _elasticity; }
		public function set elasticity(value:Number):void {
			_elasticity = value;
		}
		
		public function get friction():Number { return _friction; }
		public function set friction(value:Number):void {
			_friction = value;
		}
		
		public function get shape():String { return _shape; }
		public function set shape(value:String):void {
			_shape = value;
		}
		
		public function render(time:Number) : void
		{
			// nothing...
		}
	}
}