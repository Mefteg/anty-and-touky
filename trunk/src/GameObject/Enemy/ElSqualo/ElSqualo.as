package GameObject.Enemy.ElSqualo 
{
	import com.adobe.protocols.dict.events.ConnectedEvent;
	import flash.geom.Rectangle;
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
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
		
		private var m_stage:int = 0;
		
		public function ElSqualo(X:Number, Y:Number,areaWidth:int,areaHeight:int) 
		{
			super(X, Y);
			m_url = "Images/Enemies/ElSqualo/body.png";
			m_width = 64; m_height = 64;
			m_rightArm = new SqualoRightArm(this);
			m_leftArm = new SqualoLeftArm(this);
			m_area = new Rectangle(X, Y, areaWidth, areaHeight);
			m_missilesManager = new SqualoMissilesManager(NB_PINEAPPLES, this);
			m_state = "onGround";
		}
		
		private function jump():void {
			m_direction.y = -1;
			m_state = "jumping";
		}
		
		private function jumping():void {
			move();
			if (!onScreen()) {
				setVisible(false);
				m_state = "inAir";
				m_timerAttack.start(2);
			}
		}
		
		private function inAir():void {
			if (m_timerAttack.finished) {
				m_direction.y = 1;
				m_state = "goDown";
				setVisible(true);
			}
		}
		
		private function goDown():void {
			move();
			if (y >= m_area.y) {
				m_direction.y = 0;
				m_state = "onGround";
				initActions();
			}
		}
		
		private function onGround():void {
			if (actionsOver())
				jump();
		}
		
		override public function update():void {
			/*if (FlxG.keys.justPressed("R"))
				m_rightArm.attack();
			if (FlxG.keys.justPressed("L"))
				m_leftArm.attack();
			if (FlxG.keys.justPressed("P"))
				m_missilesManager.init(1);
			if (FlxG.keys.justPressed("J"))
				jump();
				*/
			switch(m_state) {
				case "onGround": onGround(); break;
				case "jumping" : jumping(); break;
				case "inAir":inAir(); break;
				case "goDown":goDown(); break;
				default : break;
			}
		}
		
		private function initActions():void {
			m_missilesManager.init(m_stage);
			if(m_leftArm)
				m_leftArm.init(m_stage);
			if (m_rightArm)
				m_rightArm.init(m_stage);
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
		
		private function setVisible(vis:Boolean) {
			visible = vis;
			if (m_rightArm)
				m_rightArm.visible = vis;
			if (m_leftArm)
				m_leftArm.setVisible(vis);
		}
		
		private function actionsOver():Boolean {
			var over:Boolean = true;
			if (m_rightArm) 
				over =  over && m_rightArm.isOver();
			if (m_leftArm)
				over = over && m_leftArm.isOver();	
			return over;
		}
	}

}