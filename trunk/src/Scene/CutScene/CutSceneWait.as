package Scene.CutScene 
{
	import com.adobe.fileformats.vcard.Address;
	import GameObject.Menu.MVCButton;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class CutSceneWait extends CutSceneObject 
	{
		var m_timer:FlxTimer;
		var m_time:Number;
		var m_actived:Boolean = false;
		
		public function CutSceneWait(time:Number) 
		{
			m_timer = new FlxTimer();
			m_time = time;
		}
		
		override public function act():void {
			if (m_actived)
				return;
			m_timer.start(m_time);
			m_actived = true;
		}
		
		override public function isFinished():Boolean {
			return m_timer.finished;
		}
	}

}