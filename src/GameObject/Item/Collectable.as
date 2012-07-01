package GameObject.Item 
{
	import GameObject.DrawableObject;
	import GameObject.PlayableObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Collectable extends DrawableObject 
	{
		var m_target:PlayableObject;
		var m_power:int=1;
		
		public function Collectable(X:Number, Y:Number) 
		{
			super(X, Y);
		}
		
		override public function load():void {
			super.load();
			addAnimation("idle", [0, 1, 2], 10, true);
		}
		
		override public function addToStage():void {
			load();
			Global.currentPlaystate.addCollectable(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_nppGroup);
		}
		
		override public function act():void {
			m_target.addEnergy(m_power);
			removeFromStage();
		}
				
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_nppGroup);
		}
		
		override public function update():void {
			if (Global.soloPlayer && collide(Global.soloPlayer)) {
				m_target = Global.soloPlayer;
				act();
				return;
			}
				
			if (collide(Global.player1)) {
				m_target = Global.player1;
				act();
			}else if(collide(Global.player2)){
				m_target = Global.player2;
				act();
			}
		}
		
		public static function HeartDrop():Collectable {
			var heart:Collectable = new Collectable(0, 0);
			heart.m_url = "Images/Menu/icon_heart_basic.png";
			heart.m_width = 9; heart.m_height = 9;
			return heart;
		}
	}

}