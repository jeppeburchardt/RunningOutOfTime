package kosmobot.games.platform.collision
{
	import org.cove.ape.CircleParticle;
	import org.cove.ape.Composite;
	import org.cove.ape.SpringConstraint;
	
	
	public class RigidBody extends Composite
	{
		private var deltaRotation : Number;
		private var a:CircleParticle;
		private var b:CircleParticle;
		private var c:CircleParticle;
		private var d:CircleParticle;
		
		public function RigidBody(x:Number, y:Number, width:Number, height:Number)
		{
			a = new CircleParticle(x-(width/2), y-(height/2), 1);
			b = new CircleParticle(x+(width/2), y-(height/2), 1);
			c = new CircleParticle(x+(width/2), y+(height/2), 1);
			d = new CircleParticle(x-(width/2), y+(height/2), 1);
			addParticle(a);
			addParticle(b);
			addParticle(c);
			addParticle(d);
			var c_1 : SpringConstraint = new SpringConstraint(a, b, 1, true, 2, 1);
			var c_2 : SpringConstraint = new SpringConstraint(b, c, 1, true, 2, 1);
			var c_3 : SpringConstraint = new SpringConstraint(c, d, 1, true, 2, 1);
			var c_4 : SpringConstraint = new SpringConstraint(d, a, 1, true, 2, 1);
			var c_5 : SpringConstraint = new SpringConstraint(a, c, 1, false, 1, 1);
			var c_6 : SpringConstraint = new SpringConstraint(b, d, 1, false, 1, 1);
			addConstraint(c_1);
			addConstraint(c_2);
			addConstraint(c_3);
			addConstraint(c_4);
			addConstraint(c_5);
			addConstraint(c_6);
			
			deltaRotation = Math.atan2(x - a.px, y - a.py);
		}
		
		public function get rotation() : Number
		{
			return (deltaRotation - Math.atan2(a.px - x, a.py - y)) * 180 / Math.PI;
		}
		
		public function get x() : Number
		{
			return (a.px + c.px) / 2;
		}
		
		public function get y() : Number
		{
			return (a.py + c.py) / 2;
		}
	}
}