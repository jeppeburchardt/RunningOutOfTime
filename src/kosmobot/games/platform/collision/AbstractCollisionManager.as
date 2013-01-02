package kosmobot.games.platform.collision 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import kosmobot.games.platform.events.TileEvent;
	import kosmobot.games.platform.View;
	import kosmobot.games.platform.Scene;
	/**
	 * ...
	 * @author Jeppe Burchardt
	 */
	public class AbstractCollisionManager extends Sprite
	{
		protected var scene : Scene;
		protected var view : View;
		
		public function AbstractCollisionManager(scene:Scene, view:View) 
		{
			this.scene = scene;
			this.view = view;
			
			view.addEventListener(TileEvent.ADDED, tileAddedHandler);
			view.addEventListener(TileEvent.REMOVED, tileRemovedHandler);
			
			addEventListener(Event.ENTER_FRAME, run);
		}
		
		protected function tileRemovedHandler(e:TileEvent):void 
		{
			
		}
		
		protected function tileAddedHandler(e:TileEvent):void 
		{
			
		}
		
		protected function run(e:Event):void
		{
			
		}
		
	}

}