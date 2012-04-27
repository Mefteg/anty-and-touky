package GameObject.Trigger 
{
	import GameObject.TriggerObject;
	import Scene.CutScene.CutScene;
	/**
	 * ...
	 * @author ...
	 */
	public class TriggerCutScene extends TriggerObject
	{
		private var m_cutscene:CutScene;
		
		public function TriggerCutScene(X:Number, Y:Number, width:int,height:int,cutscene:String ) 
		{
			super(X, Y, null, width, height);
			m_cutscene = new CutScene(cutscene);
		}
		
		override public function update():void {
			if (!m_active && ( collide(Global.player1) || collide(Global.player2))) {
				m_active = true;
				m_cutscene.start();
			}
		}
		
	}

}