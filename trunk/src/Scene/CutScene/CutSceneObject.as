package Scene.CutScene 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CutSceneObject 
	{
		protected var m_finished:Boolean = false;
		
		public function CutSceneObject() 
		{
			
		}
		
		public function act():void{}
		
		public function isFinished():Boolean {
			return m_finished;
		}
		
	}

}