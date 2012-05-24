package GameObject.Weapon 
{
	import GameObject.DrawableObject;
	import GameObject.Enemy.Enemy;
	import GameObject.MovableObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Throwable extends Weapon
	{
		public var m_caster:MovableObject;
		protected var m_initSpeed:Number;
		public var m_straightShot:Boolean = false;
		public var m_animationSpeed:int = 10;
		
		public var m_rotative:Boolean = false;
		protected var m_currentAttackName:String;
		
		public function Throwable(power:Number , url:String, speed:Number = 2 ) 
		{
			super(power, url);
			m_speed = speed;
			m_initSpeed = m_speed;
			m_state = "idle";			
			m_width = 24;
			m_height = 32;
		}
		
		public function isFree():Boolean {
			return m_state == "idle";
		}
		
		public function touched():void {
			if (m_state == "dead")
				return;
			m_state = "dead";
			m_direction.x = 0;
			m_direction.y = 0;
			x = 0; y = 0;
			m_speed = m_initSpeed;
			play("dead");
		}
		
		override public function attack(direction:int):void {
			if (m_state != "idle")
				return;
			addToStage();
			m_FX.play();
			m_state = "attack";
			if(m_rotative)
				play("attack");
			else {
				trace(m_currentAttackName);
				play(m_currentAttackName);
			}
			computeDirection();
		}
		
		public function setAnimationAttack(rotative:Boolean,...rest):void {
			m_rotative = rotative;
			if(rotative){
				addAnimation("attack", rest, m_animationSpeed, true);
			}else {
				for (var i:int = 0; i < 8; i++)
					addAnimation("attack" + i, [i], 1, true);
				m_currentAttackName = "attack2";
			}
		}
		
		public function setAnimationDead(...rest):void {
			addAnimation("dead", rest, 1, false);
		}
		
		override public function load():void {
			loadGraphic2(Global.library.getBitmap(m_url), true, false, m_width, m_height);
						
			//sound
			m_FX.loadStream(m_FXurl);
		}
		
		override public function place(X:Number, Y:Number ) : void{ 
			if (m_state == "idle")
				super.place(X,Y);
		}
		
		public function setCaster(object:MovableObject) : void {
			m_caster = object;
		}
		
		public function CheckDamageDealt():Boolean { return false; }
		
		protected function computeDirection():void {
			m_direction.x = m_caster.m_directionFacing.x;
			m_direction.y = m_caster.m_directionFacing.y;
			if (m_straightShot)
				return;
			if (m_direction.x == 0) {
				m_direction.x = Utils.random( -0.1, 0.1);
			}else if (m_direction.y == 0) {
				m_direction.y = Utils.random( -0.1, 0.1);
			}
			m_direction = Utils.normalize(m_direction);
		}
		
		override public function update() : void {
			if (Global.frozen)
				return;
			m_canGoThrough = true;
			//if attack is on
			if (m_state == "attack") {
				move();
				//and object not on screen anymore
				if (!onScreen() || CheckDamageDealt()) {
					//deactivate the object
					touched();
				}
			}else if (m_state == "dead") {
				if(finished){
					removeFromStage();
					m_state = "idle";
				}
			}
		}
		
		override public function move() : void {
			m_oldPos.x = x; m_oldPos.y = y;
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
			interactWithEnv();
			
			// if the new position involves an environment collision
			if ( !m_canGoThrough ) {
				touched();
			}
		}
		
		public function setAnimationWithDirection(dir: FlxPoint):void {
			m_currentAttackName = "attack" + Utils.getDirectionID(dir);
		}
		
		
	}

}