package Scene.CutScene 
{
	import GameObject.GameObject;
	import GameObject.MovableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class CutSceneMovableObject extends CutSceneObject
	{
		private var m_object:GameObject.MovableObject;
		private var m_target:GameObject;
		
		public function CutSceneMovableObject(object:GameObject.MovableObject , target:GameObject ) 
		{
			m_object = object;
			m_target = target;
			if (m_target.m_hitbox == null)
				m_target.m_hitbox = new Hitbox(0, 0, 1, 1);
		}
		
		override public function act():void {
			if (m_finished)
				return;
			m_object.goTo(m_target);
			m_object.move();
			if (m_object.collide(m_target)){
				m_finished = true;
				m_object.stop();
			}
		}
				
	}

}