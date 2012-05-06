package Scene.CutScene 
{
	import GameObject.GameObject;
	import GameObject.Menu.Message;
	/**
	 * ...
	 * @author ...
	 */
	public class CutSceneMessageObject extends CutSceneObject
	{
		private var m_object:GameObject;
		private var m_messageObject:Message;
		private var m_messageText:String;
		private var m_active:Boolean = false;
		
		public function CutSceneMessageObject(object:GameObject,messageObject:Message, messageText:String) 
		{
			m_object = object;
			m_messageObject = messageObject;
			m_messageText = messageText;
		}
		
		override public function act():void {
			if (!m_active) {
				m_active = true;
				m_messageObject = new Message(m_messageText, m_object);
			}else {
				if (m_messageObject.isFinished())
					m_finished = true;
			}
		}
		
	}

}