package GameObject.Enemy.ElSqualo 
{
	import com.adobe.protocols.dict.events.ConnectedEvent;
	import flash.geom.Rectangle;
	import GameObject.Enemy.Enemy;
	import GameObject.Enemy.EnemySmoke;
	import GameObject.PlayableObject;
	import GameObject.Weapon.Weapon;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class ElSqualo extends Enemy
	{
		private var m_rightArm:SqualoRightArm;
		private var m_leftArm:SqualoLeftArm;
		
		private var m_missilesManager:SqualoMissilesManager;
		
		protected var NB_PINEAPPLES:int = 6;
		
		public var m_area:Rectangle;
		
		private var m_stage:int = 3;
		
		private var m_dead:Boolean = false;
		
		private var m_tabExplode:Array;
		private var m_currentExplosion:int;
		
		public function ElSqualo(X:Number, Y:Number,areaWidth:int,areaHeight:int) 
		{
			super(X, Y);
			m_url = "Images/Enemies/ElSqualo/body.png";
			m_width = 64; m_height = 64;
			m_rightArm = new SqualoRightArm(this);
			m_leftArm = new SqualoLeftArm(this);
			m_area = new Rectangle(X, Y, areaWidth, areaHeight);
			m_missilesManager = new SqualoMissilesManager(NB_PINEAPPLES, this);
			m_invincible = true;
			m_tabExplode = new Array( new FlxPoint(0, 0), new FlxPoint(40, 10), new FlxPoint(10, 60), new FlxPoint(30, 30), new FlxPoint(10, 10) );
			m_state = "onGround";
			m_smoke = EnemySmoke.Explosion();
			m_collideEvtFree = true;
			m_stats.initHP(120);
		}
		
		private function jump():void {
			m_direction.y = -1;
			m_state = "jumping";
		}
		
		private function jumping():void {
			move();
			if (!onScreen()) {
				setVisible(false);
				m_state = "inAir";
				m_timerAttack.start(2);
			}
		}
		
		private function inAir():void {
			if (m_timerAttack.finished) {
				m_direction.y = 1;
				x = getRandomPlayer().x;
				m_state = "goDown";
				m_speed = 5;
				setVisible(true);
			}
		}
		
		private function goDown():void {
			move();
			if (y >= m_area.y) {
				m_direction.y = 0;
				m_state = "onGround";
				initActions();
			}
		}
		
		private function onGround():void {
			if (actionsOver())
				jump();
		}
		
		override public function update():void {
			commonEnemyUpdate();
			switch(m_state) {
				case "onGround": onGround(); break;
				case "jumping" : jumping(); break;
				case "inAir":inAir(); break;
				case "goDown":goDown(); break;
				case "dying": dying(); break;
				default : break;
			}
		}
		
		private function initActions():void {
			m_missilesManager.init(m_stage);
			if(!m_leftArm.m_dead)
				m_leftArm.init(m_stage);
			if (!m_rightArm.m_dead)
				m_rightArm.init(m_stage);
		}
		
		public function changeState(i:int) : void {
			if (i > m_stage)
				m_stage = i;
			else if (m_stage == 2 && i == 2){
				m_stage = 3;
				jump();
				m_invincible = false;
			}
		}
		
		public function loseArm(left:Boolean):void {
			if (left)
				if (m_rightArm.m_dead)
					frame = 3;
				else
					frame = 2;
					
			else
				if (m_leftArm.m_dead)
					frame = 3;
				else
					frame = 1;
		}
		
		////////////////////////////////////////////////////////////
		///////////GRAPHICS OVERLOADING//////////////////////////////
		///////////////////////////////////////////////////////////
		override public function load():void {
			super.load();
			m_rightArm.load();
			m_leftArm.load();
			m_missilesManager.load();
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			m_rightArm.addBitmap();
			m_leftArm.addBitmap();
			m_missilesManager.addBitmap();
		}
		
		override public function addToStage():void {
			super.addToStage();
			m_rightArm.addToStage();
			m_leftArm.addToStage();
			m_missilesManager.addToStage();
		}
		
		private function setVisible(vis:Boolean) {
			visible = vis;
			if (!m_rightArm.m_dead)
				m_rightArm.visible = vis;
			if (!m_leftArm.m_dead)
				m_leftArm.setVisible(vis);
		}
		
		private function actionsOver():Boolean {
			if (m_stage == 3)
				return m_missilesManager.isOver();
			var over:Boolean = true;
			if (!m_rightArm.m_dead) 
				over =  over && m_rightArm.isOver();
			if (!m_leftArm.m_dead)
				over = over && m_leftArm.isOver();	
			return over;
		}
		
		override public function takeDamage(player:PlayableObject, weapon:Weapon):void {
			if (m_invincible || m_dead)
				return;
			//calculate damage
			var damage:int = weapon.m_power ;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			m_FXhit.play();
			//check death
			if (m_stats.m_hp_current <= 0) {
				if(!Global.soloPlayer)
					m_killer = player;
				m_timerDeath.start(1);
				m_dead = true;
				m_state = "dying";
				m_smoke.playSmoke(x + m_width / 2, y + m_height / 2);
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		protected function dying():void {
			if (m_smoke.finished) {
				m_smoke.playSmoke(x + m_tabExplode[m_currentExplosion].x, y + m_tabExplode[m_currentExplosion].y);
				m_currentExplosion ++;
				if (m_currentExplosion >= m_tabExplode.length){
					removeFromStage();
					Global.currentPlaystate.end();
				}
			}
		}
	}

}