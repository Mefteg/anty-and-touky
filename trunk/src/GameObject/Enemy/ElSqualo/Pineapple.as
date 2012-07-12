package GameObject.Enemy.ElSqualo 
{
	import GameObject.DrawableObject;
	import GameObject.Enemy.Enemy;
	import GameObject.Enemy.EnemySmoke;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Pineapple extends Enemy 
	{
		private var m_shadow:DrawableObject;
		private var m_goSmoke:EnemySmoke;
		
		private var m_trail:Array;
		private var m_currentTrail:int;
		private var m_lastTrailY:int;
		private var OFFSET_TRAIL:int = 15;
		
		public function Pineapple() 
		{
			super(0, 0);
			m_url = "Images/Enemies/ElSqualo/pineapple.png";
			m_width = 32; m_height = 32;
			m_invincible = true;
			m_collideEvtFree = true;
			//create shadow
			m_shadow = new DrawableObject();
			m_shadow.m_url = m_url;
			m_shadow.m_width = 32; m_shadow.m_height = 32;
			m_shadow.setHitbox(13, 14, 6, 2);
			m_shadow.m_bufferGroup = DepthBufferPlaystate.s_objectGroup;
			//create smokes
			m_smoke = EnemySmoke.Explosion();
			m_smoke.scale = new FlxPoint(1.5, 1.5);
			m_smoke.setHitbox( -18, -18, 78, 78);
			m_goSmoke = EnemySmoke.PlayerSmoke();
			m_goSmoke.scale = new FlxPoint(0.7, 0.7);
			createTrail();
		}
		
		public function shoot(X:int, Y:int):void {
			addToStage();
			x = X; y = Y;
			m_direction.x = 0; m_direction.y = -1;
			m_state = "movingUp";
			m_goSmoke.playSmoke(x-8, y-16);
			frame = 2;
			m_speed = 8;
			m_target = getRandomPlayer();
			//SHADOW
			
			var rangeX:int = Utils.random( -40, 40);
			var rangeY:int = Utils.random( -40, 40);
			m_shadow.place(m_target.x+rangeX, m_target.y + rangeY);
		}
		
		override public function update():void {
			switch(m_state) {
				case "movingUp": movingUp(); break;
				case "waitUp": if (m_timerAttack.finished) { 
									m_state = "pique";
									visible = true;
									m_currentTrail = 0;
									m_lastTrailY = y;
								} break;
				case "pique" : pique(); break;
				default : break;
			}
		}
		
		private function movingUp():void {
			move();
			if (!onScreen()) {
				m_shadow.addToStage();
				visible = false;
				m_state = "waitUp";
				m_timerAttack.start(2);
				play("fall");
				m_direction.y = 1;
				x = m_shadow.x;
			}
		}
		
		private function pique():void {
			move();
			displayTrail();
			if (y + m_height >= m_shadow.y)
				die();
		}
		
		private function displayTrail():void {
			if (y >= m_lastTrailY + OFFSET_TRAIL) {
				m_trail[m_currentTrail].shoot(x, y);
				m_currentTrail++;
				if (m_currentTrail >= m_trail.length)
					m_currentTrail = 0;
				m_lastTrailY = y;
			}
		}
		
		override public function die():void {
			m_state = "idle";
			removeFromStage();
			m_smoke.playSmoke(x, y);
			m_shadow.removeFromStage();
			if (Global.soloPlayer) {
				if (m_smoke.collide(Global.soloPlayer)) {
					Global.soloPlayer.takeDamage();
					return;
				}
			}
			if (m_smoke.collide(Global.player1))
				Global.player1.takeDamage();
			if (m_smoke.collide(Global.player2))
				Global.player2.takeDamage();
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			m_trail[0].addBitmap();
		}
		override public function load():void {
			super.load();
			m_shadow.load();
			m_shadow.frame = 3;
			m_goSmoke.load();
			addAnimation("fall", [0, 1], 10, true);
			for (var i:int = 0; i < m_trail.length ; i++)
				m_trail[i].load();
		}
		
		override public function removeFromStage():void {
			super.removeFromStage();
			m_shadow.removeFromStage();
		}
		
		private function createTrail():void {
			m_trail = new Array();
			for (var i:int = 0; i < 10; i++)
				m_trail.push(new PineappleSteam());
		}
	}

}