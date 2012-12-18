package kosmobot.games.root
{
	import flash.automation.KeyboardAutomationAction;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import kosmobot.games.tileEngine.KeyboardController;
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
			
			//screen.addTile(new Tile(10, 10, 100, 10));
			//screen.addTile(new Tile(10, 30, 500, 10));
			//screen.addTile(new Tile(10, 50, 100, 10));
			
			//add sprites:
			for (var i : int = 0; i < 100; i++ ) {
				screen.addTile(new Tile(Math.random()*1024, Math.random()*1024, Math.random()*16+16, Math.random()*16+16));
			}
			
			screen.initializeAreas();
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			new KeyboardController(screen);
		}
		
		private function enterFrame(e:Event):void 
		{
			screen.render();
		}
		
	}
	
}