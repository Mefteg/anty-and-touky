package GameObject.Enemy.ElSqualo 
{
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
		
		private var m_missToShoot:int;
		private var m_currentShot:int;
		private var m_timerShoot:FlxTimer;
		
		public function SqualoMissilesManager(nbPA:int,squalo:ElSqualo) 
		{
			super();
			visible = false;
			NB_PINEAPPLES = nbPA;
			createPineapple();
			
			m_leftLauncher = new FlxPoint();
			m_rightLauncher = new FlxPoint(30,0);
			
			m_squalo = squalo;
			
			m_timerShoot = new FlxTimer();
		}
		
		public function shootPineapple(nb:int = 2):void {
			m_state = "shooting";
			m_pineapples[0].shoot(m_squalo.x + m_rightLauncher.x, m_squalo.y +m_rightLauncher.y );
			m_missToShoot = nb;
			m_timerShoot.start(1);
			m_currentShot = 0;
		}
		
		private function shooting():void {
			if (m_timerShoot.finished) {
				m_currentShot ++;
				if (m_currentShot % 2 == 0)
					m_pineapples[m_currentShot].shoot(m_squalo.x + m_rightLauncher.x, m_squalo.y +m_rightLauncher.y );
				else
					m_pineapples[m_currentShot].shoot(m_squalo.x + m_leftLauncher.x, m_squalo.y +m_leftLauncher.y );
				if (m_currentShot >= m_missToShoot-1)
					m_state = "idle";
			}
		}
		
		override public function update():void {
			switch(m_state) {
				case "shooting":shooting(); break;
				default : break;
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
				m_pineapples.push(new Pineapple());
		}
		
		public function over():Boolean {
			return m_state != "shooting";
		}
		
	}

}