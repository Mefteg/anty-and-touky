package Scene.CutScene 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CutSceneMusicObject extends CutSceneObject 
	{
		var m_url:String;
		
		public function CutSceneMusicObject(url:String) 
		{
			m_url = url;
		}
		
		override public function act():void {
			Global.currentPlaystate.chargeMusic(m_url);
			m_finished = true;
		}
		
	}

}