package GameObject.Other 
{
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import GameObject.Player.Player1;
	/**
	 * ...
	 * @author ...
	 */
	public class FallenResetChecker extends GameObject
	{
		var anty:PlayableObject;
		var touky:PlayableObject;
		
		public function FallenResetChecker(X:Number,Y:Number) 
		{
			super(X, Y);
			anty = Global.player1;
			touky = Global.player1;
		}
		
		override public function addToStage():void {
			if (Global.nbPlayers == 1)
				return;
			super.addToStage();
		}
		override public function update():void {
			if (anty.hasFallen()) {
				anty.respawn();
				Global.currentPlaystate.rebootScene();
			}
			
			if (touky.m_stats.m_hp_current <= 0) {
				touky.respawn();
				Global.currentPlaystate.rebootScene();
			}
		}
		
	}

}