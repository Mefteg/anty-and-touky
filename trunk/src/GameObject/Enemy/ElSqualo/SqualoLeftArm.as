package GameObject.Enemy.ElSqualo 
{
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
		protected var TIME_RESPAWN:int = 6;
		
		protected var m_spikes:Array;
		
		private var m_timerRetract:FlxTimer;
		private var m_timerWaitRespawn:FlxTimer;
		
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
				
		override public function update():void {
			if (!commonEnemyUpdate())
				return;
			x = m_body.x + 26; y = m_body.y +16;
			
			switch(m_state) {
				case "idle" : break;
				case "attack": if (m_timerRetract.finished) {
									m_state = "waitRespawn";
									m_timerWaitRespawn.start(TIME_RESPAWN);
									frame = 0;
								}
								break;
				case "waitRespawn": if (m_timerWaitRespawn.finished) {
										m_state = "idle";
										for (var i:int = 0; i < m_spikes.length ; i++)
											m_spikes[i].getBack();
									}
									break;
			}
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
		
	}

}