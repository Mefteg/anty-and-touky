package GameObject.Enemy.ElSqualo 
{
	import GameObject.Enemy.Enemy;
	import GameObject.GameObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SqualoRightArm extends Enemy 
	{
		protected var m_body:GameObject.Enemy.Enemy;
		
		protected var m_flames:Array;
		
		protected var NB_FLAMES:int = 10;
		protected var FLAME_OFFSET:int = 20;
		protected var m_currentFlame:int;
		
		protected var m_baseFlamePos:Array;
		
		protected var m_dirTab:Array = new Array(false, false);
		
		protected var m_timerSwing:FlxTimer;
		protected var m_dir:int;
		
		private var m_over:Boolean = true;
		
		public function SqualoRightArm(body:Enemy) 
		{
			m_body = body;
			m_url = "Images/Enemies/ElSqualo/right_arm.png";
			m_width = 64; m_height = 64;
			m_activeOffscreen = true;
			createFlames();
			m_timerSwing = new FlxTimer();
		}
		
		public function isOver():Boolean {
			 return m_over;
		}
		
		override public function update():void {
			if (!commonEnemyUpdate())
				return;
			switch(m_state) {
				case "drawFlames": drawFlames(); break;
				case "swinging" : swingingFlames(); break;
				default : break;
			}
			x = m_body.x - 26; y = m_body.y +16;
		}
		
		public function init(stage:int):void {
			switch(stage) {
				case 0 : break;
			}
		}
		
		override public function attack():void {
			frame = 1;
			m_state = "drawFlames";
			m_currentFlame = 0;
			m_flames[0].place(x+12, y+45);
			m_flames[0].addToStage();
		}
		
		private function createFlames():void {
			m_flames = new Array();
			var scale:Number = 0.5;
			var step:Number = (1 - scale) / NB_FLAMES;
			for (var i:int = 0; i < NB_FLAMES; i++){
				m_flames.push( new GameObject.Enemy.ElSqualo.SqualoFlame(i, this));
				m_flames[i].scale = new FlxPoint(scale, scale);
				scale += step;
			}
		}
		
		private function drawFlames():void {
			if (m_flames[m_currentFlame].m_state == "idle") {
				m_currentFlame++;
				if (m_currentFlame >= NB_FLAMES) {
					m_baseFlamePos = new Array();
					for (var i:int = 0; i < NB_FLAMES ; i++)
						m_baseFlamePos.push(new FlxPoint(m_flames[i].x, m_flames[i].y));
					swingFlames(-1);
					return;
				}
				m_flames[m_currentFlame].addToStage();
				m_flames[m_currentFlame].place(m_flames[m_currentFlame-1].x, m_flames[m_currentFlame-1].y);
				m_flames[m_currentFlame].moveTo(new FlxPoint(m_flames[m_currentFlame].x, m_flames[m_currentFlame].y + FLAME_OFFSET));
			}
		}
		
		private function swingFlames(dir:int) {
			m_state = "swinging";
			m_dir = dir;
			if (m_dir == -1)
				m_dirTab[0] = true;
			if (m_dir == 1)
				m_dirTab[1] = true;
			var off:int = 0;
			//if it goes to the right
			for (var i:int = 0; i < NB_FLAMES; i++) {
				m_flames[i].moveTo(new FlxPoint(m_baseFlamePos[i].x + off, m_baseFlamePos[i].y ));
				m_flames[i].m_speed = 2;
				off += m_dir * 10;
			}
		}
		
		private function swingingFlames():void {
			var done:Boolean = true;
			for (var i:int = 0; i < NB_FLAMES; i++)
				done = done && (m_flames[i].m_state == "idle") ;
			if (done) {
				if(m_dir == -1 || m_dir == 1){
					swingFlames(0);
				}else {
					if (m_dirTab[0] == false)
						swingFlames( -1);
					else if (m_dirTab[1] == false)
						swingFlames(1);
					else
						hideFlames();
				}
			}
		}
		
		private function hideFlames():void {
			m_state = "idle";
			m_over = true;
			frame = 0;
			m_dirTab[0] = false; m_dirTab[1] = false;
			for (var i:int = 0; i < NB_FLAMES; i++) {
				m_flames[i].removeFromStage();
			}
		}
		
		///////////// OVERRIDES /////////////////
		override public function addBitmap():void {
			super.addBitmap();
			m_flames[0].addBitmap();
		}
		
		override public function load():void {
			super.load();
			for (var i:int = 0; i < m_flames.length; i++)
				m_flames[i].load();
		}
	
	}

}