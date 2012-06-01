package GameObject.Enemy 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EnemySmoke extends DrawableObject 
	{
		var m_sound:FlxSound;
		
		public function EnemySmoke() 
		{
			super(0,0);
			m_url = "Images/Enemies/enemy_smoke.png";
			m_width = 48; m_height = 48;
			m_bufferGroup = DepthBufferPlaystate.s_enemyGroup;
			m_sound = new FlxSound();
		}
		
		override public function load():void {
			super.load();
			addAnimation("pouf", [0, 1, 2, 3, 4, 5, 6, 7], 20, false);
			m_sound.loadStream("FX/smoke_enemy.mp3");
			m_sound.volume = 0.5;
		}
		
		public function playSmoke(X:Number, Y:Number ):void {
			x = X; y = Y;
			m_state = "pouf";
			addToStage();
			play("pouf");
			m_sound.play();
		}
		
		override public function update():void {
			if (m_state == "pouf") {
				if (finished) {
					removeFromStage();
					m_state = "idle";
				}
			}
		}
		
		public static function Explosion():EnemySmoke {
			var smoke:EnemySmoke = new EnemySmoke();
			smoke.m_url = "Images/Enemies/explosion.png";
			return smoke;
		}
		
	}

}