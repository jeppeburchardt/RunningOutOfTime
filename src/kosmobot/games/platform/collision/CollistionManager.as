package kosmobot.games.platform.collision
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.cove.ape.AbstractParticle;
	import org.cove.ape.AngularConstraint;
	import org.cove.ape.APEngine;
	import org.cove.ape.Composite;
	import org.cove.ape.Group;
	import org.cove.ape.CircleParticle;
	import org.cove.ape.RectangleParticle;
	import org.cove.ape.SpringConstraint;
	import org.cove.ape.VectorForce;
	import org.cove.ape.WheelParticle;
	import kosmobot.games.platform.events.TileEvent;
	import kosmobot.games.platform.performance.Graph;
	import kosmobot.games.platform.Scene;
	import kosmobot.games.platform.tiles.TileBase;
	import kosmobot.games.platform.View;
	import flash.system.fscommand;
	
	
	public class CollistionManager extends AbstractCollisionManager
	{
		private var defaultGroup : Group;
		private var spritesWithParticles : Array = new Array();
		
		
		public function CollistionManager(scene:Scene, view:View)
		{
			super(scene, view);
			
			APEngine.init();
			APEngine.container = this;
			
			//gravity
			APEngine.addForce(new VectorForce(false, 0, 5));
			
			APEngine.damping = .97;
			
			defaultGroup = new Group();
			defaultGroup.collideInternal = true;
			
			APEngine.addGroup(defaultGroup);
		}
		
		protected override function tileAddedHandler(e:TileEvent):void
		{
			var tile : TileBase = e.tile;
			if (spritesWithParticles[tile.id] == null)
			{
				switch(tile.shape)
				{
					case Shape.BOX:
						var box : AbstractParticle = new RectangleParticle(tile.x, tile.y, tile.rect.width, tile.rect.height, tile.rotation, tile.fixed);
						defaultGroup.addParticle(box);
						spritesWithParticles[tile.id] = box;
						break;
						
					case Shape.CIRCLE:
						var circle : AbstractParticle = new CircleParticle(tile.x, tile.y, tile.rect.width / 2, tile.fixed);
						defaultGroup.addParticle(circle);
						spritesWithParticles[tile.id] = circle;
						break;
						
					case Shape.WHEEL:
						var wheel : AbstractParticle = new WheelParticle(tile.x, tile.y, tile.rect.width / 2, tile.fixed);
						defaultGroup.addParticle(wheel);
						spritesWithParticles[tile.id] = wheel;
						break;
						
					case Shape.RIGID_BODY:
						var rigid : RigidBody = new RigidBody(tile.x, tile.y, tile.rect.width, tile.rect.height);
						defaultGroup.addComposite(rigid);
						spritesWithParticles[tile.id] = rigid;
						break;
				}
			}
		}
		
		protected override function tileRemovedHandler(e:TileEvent):void
		{
			var tile : TileBase = e.tile;
			if (spritesWithParticles[tile.id] != null)
			{
				var obj : Object = spritesWithParticles[tile.id];
				if (obj is AbstractParticle)
				{
					defaultGroup.removeParticle(obj as AbstractParticle);
				}
				else
				{
					defaultGroup.removeComposite(obj as Composite);
				}
				delete spritesWithParticles[tile.id];
			}
		}	
		
		public function getCollisionObjectByTile(tile:TileBase) : Object
		{
			return spritesWithParticles[tile.id];
		}
		
		protected override function run(e:Event):void
		{
			Graph.startTimer("collision");
			APEngine.step();
			APEngine.paint();
			
			spritesWithParticles.forEach(function(obj:*, id:int, a:Array):void
			{
				if (obj != null)
				{
					var ape : Object = obj;
					var tile : TileBase = TileBase.ALL[id];
					
					if (ape is AbstractParticle)
					{
						scene.translateTile(tile, ape.px-tile.x, ape.py-tile.y, ape.sprite.rotation-tile.rotation);
						//tile.x = ape.px;
						//tile.y = ape.py;
						//tile.rotation = ape.sprite.rotation;
					}
					else if (ape is RigidBody)
					{
						scene.translateTile(tile, ape.x-tile.x, ape.y-tile.y, ape.rotation-tile.rotation);
						//tile.x = ape.x;
						//tile.y = ape.y;
						//tile.rotation = ape.rotation;
					}
				}
			});
			Graph.stopTimer("collision");
		}
	}
}