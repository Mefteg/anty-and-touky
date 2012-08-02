package GameObject.Other 
{
	import GameObject.Enemy.Enemy;
	import GameObject.Enemy.EnemySmoke;
	import GameObject.PhysicalObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Generator extends Enemy 
	{
		private var m_door:String;
		
		public function Generator(X:Number, Y:Number , door:String) 
		{
			super(X, Y);
			m_url = "Images/Others/generator.png";
			m_width = 48; m_height = 48;
			setHitbox(6, 15, 36, 23);
			m_points = 400;
			m_smoke = EnemySmoke.Explosion();
			m_smoke.scale = new FlxPoint(1.5, 1.5);
			m_stats.initHP(10);
			m_door = door;
		}
		
		
		///OVERRIDES //////
		override public function addToStage():void {
			super.addToStage();
			Global.currentPlaystate.addPhysical(this as PhysicalObject);
		}
		override public function update():void { 
			if (!commonEnemyUpdate())
				return;
			if(m_state == "dead") die();
		}
		
		override public function load():void {
			super.load();
			addAnimation("idle", [0, 1], 8);
			play("idle");
		}
		
		override public function die():void {
			m_invincible = true;
			m_state = "anihilated";
			frame = 2;
			m_smoke.playSmoke(x, y);
			dropItem();
			m_killer.addScore(m_points);
			var door:Door = Global.currentPlaystate.getDoor(m_door);
			if (door)
				door.act();	
		}
		
	}

}