package GameObject.Item 
{
	import GameObject.DrawableObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Collectable extends DrawableObject 
	{
		var m_target:PlayableObject;
		var m_power:int = 1;
		var m_sound:FlxSound;
		var m_FXurl:String;
		
		public function Collectable(X:Number, Y:Number) 
		{
			super(X, Y);
			m_FXurl = "FX/ding.mp3";
		}
		
		override public function load():void {
			super.load();
			addAnimation("idle", [0, 1, 2], 10, true);
			
			if (m_FXurl) {
				m_sound = new FlxSound();
				m_sound.loadStream(m_FXurl);
				m_sound.volume = 0.2;
			}
		}
		
		override public function addToStage():void {
			load();
			Global.currentPlaystate.addCollectable(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_nppGroup);
		}
		
		override public function act():void {
			if (m_sound)
				m_sound.play();
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
		
		public static function Heart(X:Number, Y:Number):Collectable {
			var heart:Collectable = new Collectable(X, Y);
			heart.m_url = "Images/Menu/icon_heart_basic.png";
			heart.m_width = 9; heart.m_height = 9;
			return heart;
		}
		
		public static function HeartDrop():Collectable {
			var heart:Collectable = new Collectable(0, 0);
			heart.m_url = "Images/Menu/icon_heart_basic.png";
			heart.m_width = 9; heart.m_height = 9;
			return heart;
		}
	}

}