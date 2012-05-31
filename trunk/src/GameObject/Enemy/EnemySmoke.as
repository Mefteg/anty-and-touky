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
		}
		
		override public function load():void {
			super.load();
			addAnimation("pouf", [0, 1, 2, 3, 4, 5, 6, 7], 20,false);
		}
		
		public function playSmoke(X:Number, Y:Number ):void {
			x = X; y = Y;
			m_state = "pouf";
			addToStage();
			play("pouf");
		}
		
		override public function update():void {
			if (m_state == "pouf") {
				if (finished) {
					removeFromStage();
					m_state = "idle";
				}
			}
		}
		
	}

}