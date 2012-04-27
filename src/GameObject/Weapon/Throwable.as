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
		public var m_caster:DrawableObject;
		public var m_player:PlayableObject;
		public var m_enemy:Enemy;
		protected var m_isPlayerCaster:Boolean = true;
		public var m_enemies:Vector.<Enemy>;
		
		public function Throwable(power:Number , url:String, speed:Number = 2 ) 
		{
			super(power, url);
			m_speed = speed;
			m_state = "idle";			
			m_width = 24;
			m_height = 32;
		}
		
		public function isFree():Boolean {
			return m_state == "idle";
		}
		
		public function touched():void {
			removeFromStage();
			m_state = "idle";
			m_direction.x = 0;
			m_direction.y = 0;
			x = 0; y = 0;
		}
		
		override public function attack(direction:int):void {
			if (m_state != "idle")
				return;
			addToStage();
			m_FX.play();
			m_state = "attack";
			play("attack" + direction);
			if (direction == UP){ 
				m_direction.y = -1;
			}else if (direction == DOWN){
				m_direction.y = 1;
			} else	if (direction == LEFT){
				m_direction.x = -1;
			}else if (direction == RIGHT){
				m_direction.x = 1;
			}
		}
		
		override public function load():void {
			loadGraphic2(Global.library.getBitmap(m_url), true, false, m_width, m_height);
			m_hitbox = new Hitbox(0, 0, m_width, m_height);
			
			addAnimation("attack" + UP, [0,1,2,3], 5, true);
			addAnimation("attack" + RIGHT,[0,1,2,3], 5, true);
			addAnimation("attack" + DOWN, [0,1,2,3], 5, true);
			addAnimation("attack" + LEFT, [0,1,2,3], 5, true);
			play("attack" + facing);
			
			//sound
			m_FX.loadStream(m_FXurl);
		}
		
		override public function place(X:Number, Y:Number ) : void{ 
			if (m_state == "idle")
				super.place(X,Y);
		}
		
		public function setCasterPlayer(object:PlayableObject) {
			m_caster = object;
			m_player = object as PlayableObject;
			m_isPlayerCaster = true;
		}
		public function setCasterEnemy(object:Enemy) {
			m_caster = object;
			m_enemy = object as Enemy;
			m_isPlayerCaster = false;
		}
		
		public function CheckDamageDealt():Boolean {
			m_enemies = Global.currentState.m_enemies;
			var result:Boolean = false;
			if (m_isPlayerCaster) {
				//check enemies for damage
				for (var i:int = 0; i < m_enemies.length; i++) {
					var enemy:Enemy = m_enemies[i];
					if (enemy == null || enemy.isDead() )
						continue;
					//if collision with an enemy
					if (collide(enemy)) {
						result = true;
						//deal damage
						enemy.takeDamage(m_player , this);
						break;
					}
				}
			}else {
				//check players for damage
				if (collide(Global.player1)){
					Global.player1.takeDamage(m_enemy, this);
					result = true;
				}
				if (collide(Global.player2)){
					Global.player2.takeDamage(m_enemy, this);
					result = true;
				}
			}
			return result;
		}
		
		override public function update():void {
			//if attack is on
			if (m_state == "attack")
				//and object not on screen anymore
				if (!onScreen() || CheckDamageDealt()) {
					//deactivate the object
					touched();
				}
			move();
		}
		
		override public function move() : void {
			m_oldPos.x = x; m_oldPos.y = y;
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			// if the new position involves an environment collision
			if ( collideWithEnv() ) {
				touched();
			}
		}
		
		///////////////////////////////////////////////
		//////////PREBUILDED THROWABLES///////////////
		//////////////////////////////////////////////
		
		public static function Slipper() : Throwable{
			return new Throwable(2, "Images/Weapons/slipper.png", 2);
		}
		
	}

}