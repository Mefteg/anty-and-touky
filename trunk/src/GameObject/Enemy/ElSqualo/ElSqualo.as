package GameObject.Enemy.ElSqualo 
{
	import flash.geom.Rectangle;
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class ElSqualo extends Enemy
	{
		private var m_rightArm:SqualoRightArm;
		private var m_leftArm:SqualoLeftArm;
		
		private var m_missilesManager:SqualoMissilesManager;
		
		protected var NB_PINEAPPLES:int = 6;
		
		private var m_area:Rectangle;
		
		public function ElSqualo(X:Number, Y:Number,areaWidth:int,areaHeight:int) 
		{
			super(X, Y);
			m_url = "Images/Enemies/ElSqualo/body.png";
			m_width = 64; m_height = 64;
			m_rightArm = new SqualoRightArm(this);
			m_leftArm = new SqualoLeftArm(this);
			m_area = new Rectangle(X, Y, areaWidth, areaHeight);
			m_missilesManager = new SqualoMissilesManager(NB_PINEAPPLES,this);
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("R"))
				m_rightArm.attack();
			if (FlxG.keys.justPressed("L"))
				m_leftArm.attack();
			if (FlxG.keys.justPressed("P"))
				m_missilesManager.shootPineapple();
		}
		
		////////////////////////////////////////////////////////////
		///////////GRAPHICS OVERLOADIN//////////////////////////////
		///////////////////////////////////////////////////////////
		override public function load():void {
			super.load();
			m_rightArm.load();
			m_leftArm.load();
			m_missilesManager.load();
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			m_rightArm.addBitmap();
			m_leftArm.addBitmap();
			m_missilesManager.addBitmap();
		}
		
		override public function addToStage():void {
			super.addToStage();
			m_rightArm.addToStage();
			m_leftArm.addToStage();
			m_missilesManager.addToStage();
		}
	}

}