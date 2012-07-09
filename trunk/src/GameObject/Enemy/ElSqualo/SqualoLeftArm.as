package GameObject.Enemy.ElSqualo 
{
	import adobe.utils.CustomActions;
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SqualoLeftArm extends Enemy 
	{
		protected var m_body:GameObject.Enemy.Enemy;
		
		protected var TIME_RETRACT:int = 2;
		protected var TIME_RESPAWN:int = 3;
		
		protected var TIME_MIN:int;
		protected var TIME_MAX:int;
		
		protected var m_spikes:Array;
		
		private var m_timerRetract:FlxTimer;
		private var m_timerWaitRespawn:FlxTimer;
		
		private var m_attackCount:int;
		private var m_attackMax:int;
		private var TIME_ATTACK:Number;
		
		private var m_over:Boolean = true;
		
		public function SqualoLeftArm(body:Enemy) 
		{
			m_body = body;
			m_url = "Images/Enemies/ElSqualo/left_arm.png";
			m_width = 64; m_height = 64;
			m_activeOffscreen = true;
			m_spikes = new Array();
			m_spikes.push(new SqualoSpike(0,this));
			m_spikes.push(new SqualoSpike(1,this));
			m_spikes.push(new SqualoSpike(2, this));
			
			m_timerRetract = new FlxTimer();
			m_timerWaitRespawn = new FlxTimer();
			
			m_state = "idle";
		}
		
		override public function attack():void {
			m_state = "attack";
			m_timerRetract.start(TIME_RETRACT);
			frame = 1;
			for (var i:int = 0; i < m_spikes.length ; i++)
				m_spikes[i].prepare();
		}
		
		public function isOver():Boolean {
			 return m_over;
		}
				
		override public function update():void {
			if (!commonEnemyUpdate())
				return;
			x = m_body.x + 26; y = m_body.y +16;
			
			switch(m_state) {
				case "idle" : break;
				case "waitForAttack": if (m_timerAttack.finished)
										attack();
										break;
				case "attack": if (m_timerRetract.finished) {
									m_state = "waitRespawn";
									m_timerWaitRespawn.start(TIME_RESPAWN);
									frame = 0;
								}
								break;
				case "waitRespawn": if (m_timerWaitRespawn.finished) {
										for (var i:int = 0; i < m_spikes.length ; i++)
											m_spikes[i].getBack();
										m_attackCount++;
										if (m_attackCount >= m_attackMax) {
											m_state = "idle";
											m_over = true;
										}else {
											m_state = "waitForAttack";
											m_timerAttack.start(TIME_ATTACK);
										}
										
									}
									break;
			}
		}
		
		public function init(stage:int) {
			m_attackCount = 0;
			switch(stage) {
				case 0 : m_attackMax = 2;
						TIME_MIN = 2;
						TIME_MAX = 5;
						break;
			}
			
			TIME_ATTACK = Utils.random(TIME_MIN, TIME_MAX);
			m_timerAttack.start(TIME_ATTACK);
			m_over = false;
			m_state = "waitForAttack";
		}
				
		///////////// OVERRIDES /////////////////
		override public function addBitmap():void {
			super.addBitmap();
			m_spikes[0].addBitmap();
		}
		
		override public function load():void {
			super.load();
			for (var i:int = 0; i < m_spikes.length; i++)
				m_spikes[i].load();
		}
		
		override public function addToStage():void {
			super.addToStage();
			for (var i:int = 0; i < m_spikes.length; i++)
				m_spikes[i].addToStage();
		}
		
		override public function removeFromStage():void {
			super.removeFromStage();
			for (var i:int = 0; i < m_spikes.length; i++)
				m_spikes[i].removeFromStage();
		}
		
		public function setVisible(v:Boolean) {
			visible = v;
			for (var i:int = 0; i < m_spikes.length; i++)
				m_spikes[i].visible = v;
		}
		
	}

}