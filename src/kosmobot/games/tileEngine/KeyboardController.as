package kosmobot.games.tileEngine 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.WeakFunctionClosure;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Jeppe Burchardt
	 */
	public class KeyboardController 
	{
		private var xSpeed : Number = 0;
		private var ySpeed : Number = 0;
		private var xDir : Number = 0;
		private var yDir : Number = 0;
		private var screen:Screen;
		
		public function KeyboardController(screen:Screen) 
		{
			this.screen = screen;
			this.screen.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			this.screen.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			this.screen.addEventListener(Event.RENDER, render);
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.LEFT) {
				xDir = -1;
			}
			if (e.keyCode == Keyboard.RIGHT) {
				xDir = 1;
			}
			if (e.keyCode == Keyboard.UP) {
				yDir = -1;
			}
			if (e.keyCode == Keyboard.DOWN) {
				yDir = 1;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.DOWN)
			{
				yDir = 0;
			}
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT) 
			{
				xDir = 0;
			}
		}
		
		private function render(e:Event):void 
		{
			xSpeed += xDir;
			ySpeed += yDir;
			
			
			
			xSpeed *= 0.9;
			ySpeed *= 0.9;
			
			screen.renderArea.x += xSpeed;
			screen.renderArea.y += ySpeed;
		}
		
	}

}