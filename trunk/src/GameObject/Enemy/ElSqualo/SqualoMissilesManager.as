package GameObject.Enemy.ElSqualo 
{
	import flash.geom.Rectangle;
	import GameObject.GameObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class SqualoMissilesManager extends GameObject
	{
		
		private var m_pineapples:Array;
		private var NB_PINEAPPLES:int;
		
		private var m_squalo:ElSqualo;
		private var m_leftLauncher:FlxPoint;
		private var m_rightLauncher:FlxPoint;
		
		private var m_missToShoot:int=2;
		private var m_currentShot:int;
		private var m_timerShoot:FlxTimer;
		private var m_timerFirstShoot:FlxTimer;
		private var TIME_FIRST_SHOOT:int;
		
		private var m_over:Boolean = true;
		
		public function SqualoMissilesManager(nbPA:int,squalo:ElSqualo) 
		{
			super();
			visible = false;
			NB_PINEAPPLES = nbPA;
			
			m_leftLauncher = new FlxPoint();
			m_rightLauncher = new FlxPoint(30,0);
			
			m_squalo = squalo;
			
			createPineapple();
			
			m_timerShoot = new FlxTimer();
			m_timerFirstShoot = new FlxTimer();
		}
						
		private function shootPineapple():void {
			m_state = "waitForShooting";
			m_timerFirstShoot.start(TIME_FIRST_SHOOT);
			m_currentShot = 0;
		}
		
		private function waitForShoot():void {
			if(m_timerFirstShoot.finished){
				m_pineapples[0].shoot(m_squalo.x + m_rightLauncher.x, m_squalo.y +m_rightLauncher.y );
				m_timerShoot.start(0.4);
				m_state = "shooting";
			}
		}
		
		private function shooting():void {
			if (m_timerShoot.finished) {
				m_currentShot ++;
				if (m_currentShot % 2 == 0)
					m_pineapples[m_currentShot].shoot(m_squalo.x + m_rightLauncher.x, m_squalo.y +m_rightLauncher.y );
				else
					m_pineapples[m_currentShot].shoot(m_squalo.x + m_leftLauncher.x, m_squalo.y +m_leftLauncher.y );
				m_timerShoot.start(0.4);
				if (m_currentShot >= m_missToShoot-1){
					m_state = "idle";
					m_over = true;
				}
			}
		}
		
		override public function update():void {
			switch(m_state) {
				case "waitForShooting": waitForShoot(); break;
				case "shooting":shooting(); break;
				default : break;
			}
		}
		
		public function init(stage:int ):void {
			switch(stage){
				case 0 : m_over = true;
						break;
				case 1 :m_missToShoot = Utils.random( 2 , 3);
						TIME_FIRST_SHOOT = Utils.random(3, 6);
						m_over = false;
						shootPineapple();
						break;
				case 2 :m_missToShoot = Utils.random( 3 , 4);
						TIME_FIRST_SHOOT = Utils.random(2, 3);
						m_over = false;
						shootPineapple();
						break;
				case 3 :m_missToShoot = Utils.random( 5 , 6);
						TIME_FIRST_SHOOT = 1;
						m_over = false;
						shootPineapple();
						break;
			}
		}
		//////////   OVERRIDES    ///////////////::
		override public function load():void {
			super.load();
			for (var i:int = 0 ; i < NB_PINEAPPLES ; i++)
				m_pineapples[i].load();
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			m_pineapples[0].addBitmap();
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.add(this);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.remove(this);
		}
		
		public function createPineapple():void {
			m_pineapples = new Array();
			for (var i:int = 0 ; i < NB_PINEAPPLES ; i++)
				m_pineapples.push(new Pineapple(m_squalo.m_area));
		}
		
		public function isOver():Boolean {
			return m_over;
		}
		
	}

}