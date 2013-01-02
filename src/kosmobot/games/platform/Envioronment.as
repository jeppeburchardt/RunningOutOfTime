package kosmobot.games.platform 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Jeppe Burchardt
	 */
	public class Envioronment 
	{
		private var _currentTime : Number = 0;
		private var lastTimeAdded : Number = 0;
		private var _timeFactor : Number = 1;
		
		public function addRelativeTime() : void 
		{
			var currentRealTime : Number = getTimer();
			var elapsedRealTime : Number = currentRealTime - lastTimeAdded;
			
			var elapsedGameTime : Number = elapsedRealTime * timeFactor;
			_currentTime += elapsedGameTime;
		}
		
		
		/**
		 * in-game milliseconds elapsed
		 */
		public function get currentTime():Number 
		{
			return _currentTime;
		}
		public function set currentTime(value:Number):void 
		{
			_currentTime = value;
		}
		
		/**
		 * in-game milliseconds added in real-time milliseconds
		 */
		public function get timeFactor():Number 
		{
			return _timeFactor;
		}
		public function set timeFactor(value:Number):void 
		{
			_timeFactor = value;
		}
		
		
		
	}

}