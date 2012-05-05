package GameObject.Weapon 
{
	import GameObject.Enemy.BlackSquare;
	import GameObject.Enemy.Enemy;
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Sword extends Weapon 
	{
		public var m_player:PlayableObject;
		public var m_animAttackSpeed:int;
		public var m_animAttack2Speed:int;
		public var m_animAttackHeavySpeed:int;
		
		public var m_frameHitMin:int;
		public var m_frameHitMax:int;
		
		public var m_enemies:Vector.<Enemy>;
		public var m_enemiesHit:Array;
		
		public function Sword(power:Number , url:String, urlSound:String = "FX/swipe.mp3") 
		{
			super(power, url);
			setAnimAttackSpeed(10, 10, 10);
			m_enemiesHit = new Array();
		}
		
		public function setAnimAttackSpeed(attack:int, attack2:int, heavy:int) : void {
			m_animAttackSpeed = attack; m_animAttack2Speed = attack2; m_animAttackHeavySpeed = heavy;
		}
		
		public function setAttackFrameRange(min:int, max:int) : void {
			m_frameHitMin = min; m_frameHitMax = max;
		}
				
		override public function load():void {
			super.load();
			//IDLE ANIM
			addAnimation("idle" + UP, [1], 10, true);
			addAnimation("idle" + RIGHT, [1], 10, true);
			addAnimation("idle" + DOWN, [1], 10, true);
			addAnimation("idle" + LEFT, [1], 10, true);	
			//attack anim
			addAnimation("attack" + UP, Utils.getArrayofNumbers(0,2), m_animAttackSpeed, false);
			addAnimation("attack" + RIGHT, Utils.getArrayofNumbers(3,5), m_animAttackSpeed, false);
			addAnimation("attack" + DOWN, Utils.getArrayofNumbers(9,11), m_animAttackSpeed, false);
			addAnimation("attack" + LEFT, Utils.getArrayofNumbers(6, 8), m_animAttackSpeed, false);
			//attack 2 anim
			addAnimation("attack2" + UP, Utils.getArrayofNumbers(2,0), m_animAttack2Speed, false);
			addAnimation("attack2" + RIGHT, Utils.getArrayofNumbers(5,3), m_animAttack2Speed, false);
			addAnimation("attack2" + DOWN, Utils.getArrayofNumbers(11,9), m_animAttack2Speed, false);
			addAnimation("attack2" + LEFT, Utils.getArrayofNumbers(8,6), m_animAttack2Speed, false);
			
			play("idle1");
			
			//sound
			m_FX.loadStream(m_FXurl);
		}
		
		override public function attack(direction:int):void {
			m_FX.play();
			m_enemies = Global.currentPlaystate.m_enemies;
			m_enemiesHit = new Array();
			m_state = "attack";
			play("attack" + direction);
			addToStage();
		}
		
		public function attack2(direction:int):void {
			m_FX.play();
			m_enemiesHit = new Array();
			m_state = "attack";
			play("attack2" + direction);
		}
		
		override public function isAttacking():Boolean {
			return isInAttackState() &&  (_curFrame<=m_frameHitMax && _curFrame>=m_frameHitMin);
		}
		
		override public function isInAttackState():Boolean {
			return (m_state == "attack" || m_state == "attack2") ;
		}
				
		public function CheckDamageDealt():Boolean {
			var result:Boolean = false;
			//check enemies for damage
			for (var i:int = 0; i < m_enemies.length; i++) {
				var index:int = m_enemiesHit.indexOf(i);
				//if the enemy has already been hit for this swipe
				if (index!=-1)
					continue;
				var enemy:Enemy = m_enemies[i];
				if (enemy == null || enemy.isDead() )
					continue;
				//if collision with an enemy
				if (collide(enemy)) {
					result = true;
					//deal damage
					enemy.takeDamage(m_player , this);
					m_enemiesHit.push(i);
					break;
				}
			}
			return result;
		}
		
		override public function update():void {
			if (isAttacking()) {
				CheckDamageDealt();
			}
		}
		/////////////////////////////////////////////////
		////////////PRE BUILDED WEAPONS/////////////////
		////////////////////////////////////////////////
		public static function SwordBasic():Sword {
			var sword:Sword = new Sword(5, "Images/Weapons/sword.png");
			sword.setAttackFrameRange(0, 3);
			return sword;
		}
	}

}