package GameObject.Other.Clouds 
{
	import GameObject.GameObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class CloudManager extends GameObject
	{
		private var m_clouds:Array;
		private var m_nbClouds:int;
		
		public function CloudManager() 
		{
			super(0, 0);
			m_nbClouds = 4;
			createClouds();
			addBitmap();
		}
		
		function createClouds():void {
			m_clouds = new Array();
			for (var i:int = 0; i < m_nbClouds; i++)
				m_clouds.push( new Cloud());
		}
		
		override public function update():void {
			if (!Global.camera)
				return;
			var cam:Camera = Global.camera;
			for (var i:int = 0; i < m_nbClouds ; i++) {
			if (m_clouds[i].isReady())
					m_clouds[i].spawn(cam.scroll.x + cam.width,
										Utils.random(cam.scroll.y + cam.height, cam.scroll.y),
										Utils.random(0.2,1.4));
			}
		}
		
		
		override public function addBitmap():void {
			Global.library.addBitmap("Images/Others/cloud1.png");
			Global.library.addBitmap("Images/Others/cloud2.png");
		}
		override public function load():void {
			for (var i:int = 0 ; i < m_clouds.length; i++)
				m_clouds[i].load();
		}
	}

}