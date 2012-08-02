package GameObject.Enemy 
{
	import GameObject.Weapon.EnemyThrowable;
	/**
	 * ...
	 * @author ...
	 */
	public class PenguinWater extends Penguin 
	{
		private var m_appeared:Boolean = false;
		private var m_circleCount:int = 0;
		public function PenguinWater(X:Number, Y:Number ) 
		{
			super(X, Y);
			m_url = "Images/Enemies/water_penguin.png";
			m_state = "onCover";
		}
		
		override public function load():void {
			super.load();
			addAnimation("waving", [12, 13, 14], 7, false);
			addAnimation("appearing", [15, 16, 17], 3, false);
			visible = false;
		}
		
		override protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable;
			for (var i:int = 0; i < 3; i++) {
				thr = EnemyThrowable.Harpoon();
				thr.setCaster(this);
				m_throwables.push(thr);
			}
		}
		
		override public function update():void {
			if (!m_appeared) {
				if (!commonEnemyUpdate())
					return;
				switch(m_state) {
					case "onCover": if (onScreen()) {
										visible = true;
										m_state = "circling";
										play("waving");
									}break;
					case "circling": if (finished) {
										m_circleCount++;
										if (m_circleCount > 2) {
											m_state = "appearing";
											play(m_state);
										}else {
											play("waving");
										}
									}break;
					case "appearing" : if (finished) {
											m_appeared = true;
											m_state = "idle";
										}break;
				}
			}
			super.update();
		}
		
	}

}