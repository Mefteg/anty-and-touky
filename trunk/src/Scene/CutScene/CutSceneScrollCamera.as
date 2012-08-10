package Scene.CutScene 
{
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import GameObject.Player.Player1;
	import GameObject.Player.Player2;
	/**
	 * ...
	 * @author ...
	 */
	public class CutSceneScrollCamera extends CutSceneObject 
	{
		private var m_player1:PlayableObject;
		private var m_player2:PlayableObject;
		private var m_target:GameObject;
		private var m_mover:PlayableObject;
		private var m_running:Boolean = false;
		private var m_last:Boolean;
		
		public function CutSceneScrollCamera(target:GameObject, player1:PlayableObject,player2:PlayableObject, last:Boolean = false) 
		{
			m_player1 = player1;
			m_player2 = player2;
			m_target = target;
			if (m_target.m_hitbox == null)
				m_target.setHitbox(0, 0, 10, 10);
			m_last = last;
			m_mover = new PlayableObject();
			m_mover.m_collideEvtFree = true;
			m_mover.setHitbox(0, 0, 48, 48);
			m_mover.m_stringNext = Global.player1.m_stringNext;
			m_mover.m_stringValidate = Global.player1.m_stringValidate;
		}
		
		override public function act():void {
			if (m_finished)
				return;
			if (!m_running) {
				m_running = true;
				m_mover.place(Global.player1.x, Global.player1.y);
				Global.player1 = m_mover;
				Global.player2 = m_mover;
			}
			m_mover.goTo(m_target);
			m_mover.move();
			if (m_mover.collide(m_target)){
				m_finished = true;
				m_mover.stop();
				if (m_last) {
					Global.player1 = m_player1;
					Global.player2 = m_player2;
				}
			}
		}
		
	}

}