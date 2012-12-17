package kosmobot.games.root
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import kosmobot.games.tileEngine.Screen;
	import kosmobot.games.tileEngine.Tile;
	
	/**
	 * ...
	 * @author Jeppe Burchardt
	 */
	public class Main extends Sprite 
	{
		private var screen:Screen;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			screen = new Screen(stage.stageWidth, stage.stageHeight);
			addChild(screen);
			
			screen.addTile(new Tile(10, 10, 100, 10));
			screen.addTile(new Tile(10, 30, 500, 10));
			screen.addTile(new Tile(10, 50, 100, 10));
			
			screen.addTile(new Tile(160, 120, 320, 240));
			
			screen.initializeAreas();
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			screen.render();
		}
		
	}
	
}