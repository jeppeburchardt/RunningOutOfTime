package kosmobot.games.platform.performance
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	* ...
	* @author Default
	*/
	public class Graph extends Sprite
	{
		private static var values : Object;
		private static var highestValue : int = 0;
		
		public function Graph()
		{
			values = new Object();
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void
		{
			graphics.clear();
			graphics.lineStyle(0, 0xFFFFFF);
			graphics.drawRect(100, 10, 420, 80);
			
			for (var s : String in values)
			{
				var array : Array = values[s].values as Array;
				var color : uint = values[s].color as uint;
				
				graphics.lineStyle(0, color);
				for (var i : int = 0; i < array.length; i++ )
				{
					var y : Number = (80 - (array[i] / highestValue) * 80) + 10;
					var x : Number = (420 - (i * 4.2)) + 100;
					if (i == 0)
					{
						graphics.moveTo(x, y);
					}
					else
					{
						graphics.lineTo(x, y);
					}
				}
			}
		}
		
		public static function createMessure(name:String, color:uint) : void
		{
			values[name] = new Object();
			values[name].color = color;
			values[name].values = new Array();
		}
		
		public static function startTimer(name:String) : void
		{
			values[name].a = getTimer();
		}
		
		public static function stopTimer(name:String) : void
		{
			var time : int = getTimer() - values[name].a;
			highestValue = Math.max(highestValue, time);
			var array : Array = values[name].values as Array;
			array.unshift(time);
			if (array.length > 100)
			{
				array.pop();
			}
		}
	}
	
}