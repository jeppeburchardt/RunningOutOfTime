package kosmobot.games.root
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.system.fscommand;
	import kosmobot.games.platform.collision.AbstractCollisionManager;
	import kosmobot.games.platform.collision.Shape;
	import kosmobot.games.platform.Envioronment;
	import kosmobot.games.platform.events.TileEvent;
	import kosmobot.games.platform.performance.Graph;
	import kosmobot.games.platform.tiles.ImageTile;
	import kosmobot.games.platform.tiles.TileBase;
	import kosmobot.games.platform.Scene;
	import kosmobot.games.platform.View;
	
	public class Main extends Sprite
	{
		private var scrollDirection : Point = new Point(0, 0);
		private var scene : Scene;
		private var view : View;
		private var collisionManager : AbstractCollisionManager;
		private var scrollSpeed : Point = new Point();
		
		private var tiles : TextField;
		private var fps : TextField;
		private var frameTime : int = 0;
		private var frameCount : int = 0;
		
		private var character : TileBase;
		private var envioronment;
		
		public function Main():void
		{
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			scene = new Scene(2000, 2000, 670, 350);

			envioronment = new Envioronment();
			
			view = new View(scene, envioronment, 100, 100);
			addChild(view);
			
			var border : Sprite = new Sprite();
			border.graphics.beginFill(0x000000, 0.8);
			border.graphics.drawRect(0, 0, 800, 480);
			border.graphics.lineStyle(0, 0xFFFFFF, 1);
			border.graphics.drawRect(100, 100, 670, 350);
			border.graphics.endFill();
			addChild(border);
			
			var graph : Graph = new Graph();
			addChild(graph);
			Graph.createMessure("collision", 0x0000FF);
			Graph.createMessure("tileEngine", 0x00FF00);
			
			
			
			collisionManager = new AbstractCollisionManager(scene, view);
			collisionManager.alpha = 0.4;
			addChild(collisionManager);
			
			
			
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(670, 350, Math.PI * 0.5, 100, 100);
			graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xCCEEFF], [1, 0.8], [0x00, 0xFF], matrix);
			graphics.drawRect(100, 100, 670, 350);
			graphics.endFill();
			
			/*
			for (var i : uint = 0; i < 1000; i++)
			{
				var tile : ImageTile = new ImageTile(Math.random() * 1975, Math.random() * 1810, 25, 100);
				scene.addTile(tile);
			}
			*/
			for (var r : uint = 0; r < 4; r++)
			{
				var tile : ImageTile = new ImageTile(100 + (50 * r), 214, 25, 100);
				scene.addTile(tile);
			}
			
			character = new TileBase(350, 0, 30, 40);
			scene.addTile(character, true);
			
			for (var i : int = 0; i < 100; i++ )
			{
				var floor : ImageTile = new ImageTile(100*i, 270, 100, 15, "gfx/vent.png", true);
				floor.fixed = true;
				scene.addTile(floor);
			}
			
			/*
			var stopper : ImageTile = new ImageTile(225, 40, 35, 35, "gfx/box.png");
			stopper.fixed = false;
			stopper.shape = Shape.RIGID_BODY;
			scene.addTile(stopper);
			
			var stopper2 : ImageTile = new ImageTile(325, 40, 35, 35, "gfx/box.png");
			stopper2.fixed = false;
			stopper2.shape = Shape.RIGID_BODY;
			scene.addTile(stopper2);
			
			var ball : ImageTile = new ImageTile(142, 50, 40, 40, "gfx/tilted_barrel.png");
			ball.fixed = false;
			ball.shape = Shape.WHEEL;
			scene.addTile(ball);
			*/
			
			frameTime = getTimer();
			addEventListener(Event.ENTER_FRAME, enterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyEvent);
			
			
			fps = new TextField();
			fps.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
			fps.selectable = false;
			fps.text = "FPS:";
			fps.y = 100;
			fps.x = 10;
			border.addChild(fps);
			
			var total : TextField = new TextField();
			total.defaultTextFormat = fps.defaultTextFormat;
			total.selectable = false;
			total.x = 10;
			total.y = 120;
			total.text = TileBase.ALL.length + " tiles";
			border.addChild(total);
			
			tiles = new TextField();
			tiles.defaultTextFormat = fps.defaultTextFormat;
			tiles.selectable = false;
			tiles.text = "";
			tiles.y = 140;
			tiles.x = 10;
			border.addChild(tiles);
		}
		
		private function keyEvent(e:KeyboardEvent):void
		{
			if (e.type == KeyboardEvent.KEY_DOWN)
			{
				if (e.keyCode == Keyboard.LEFT)
				{
					scrollDirection.x = -1;
				}
				else if (e.keyCode == Keyboard.RIGHT)
				{
					scrollDirection.x = 1;
				}
				
				if (e.keyCode == Keyboard.UP)
				{
					scrollDirection.y = -1;
				}
				else if (e.keyCode == Keyboard.DOWN)
				{
					scrollDirection.y = 1;
				}
			}
			else if (e.type == KeyboardEvent.KEY_UP)
			{
				if (e.keyCode == Keyboard.LEFT)
				{
					scrollDirection.x = 0;
				}
				else if (e.keyCode == Keyboard.RIGHT)
				{
					scrollDirection.x = 0;
				}
				if (e.keyCode == Keyboard.UP)
				{
					scrollDirection.y = 0;
				}
				else if (e.keyCode == Keyboard.DOWN)
				{
					scrollDirection.y = 0;
				}
			}
		}
		
		private function enterFrame(e:Event):void
		{
			frameCount++;
			var now : int = getTimer();
			if (now - frameTime > 1000)
			{
				fps.text = "FPS: ~" + frameCount.toString();
				frameTime = now;
				frameCount = 0;
			}
			tiles.text = "Visible tiles:" + view.visibleTilesNum.toString();
			
			scrollSpeed.x += scrollDirection.x * 2;
			scrollSpeed.y += scrollDirection.y * 2;
			
			scrollSpeed.x *= 0.9;
			scrollSpeed.y *= 0.9;
			/*
			try
			{
				var characterCollisionObject : Object = collisionManager.getCollisionObjectByTile(character);
				characterCollisionObject.px += scrollSpeed.x;
				characterCollisionObject.py += scrollSpeed.y;
			}
			catch (e:Error){
				
			}
			view.viewX += (character.x - view.viewX - scene.areaWidth/2) / 10;
			view.viewY += (character.y - view.viewY - scene.areaHeight/2) / 3;
			*/
			view.viewX += scrollSpeed.x;
			view.viewY += scrollSpeed.y;
			
			collisionManager.x = view.x;
			collisionManager.y = view.y;
		}
	}
}