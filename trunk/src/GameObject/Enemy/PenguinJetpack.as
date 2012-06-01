package GameObject.Enemy 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class PenguinJetpack extends Enemy 
	{
		var m_explosion:EnemySmoke;
		
		public function PenguinJetpack(X:Number, Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/pingouinJetpack.png";
			m_width = 32; m_height = 32;
			m_timerAttack = new FlxTimer();
			m_timerAttack.start(4);
			m_stats.initHP(2);
			m_state = "idle";
			m_explosion = EnemySmoke.Explosion();
		}
		
		override public function addBitmap():void {
			m_explosion.addBitmap();
			super.addBitmap();
		}
		
		override public function load():void {
			super.load();
			//IDLE ANIM
			addAnimation("idle" + UP, [6, 7], 10, true);
			addAnimation("idle" + RIGHT, [0,1], 10, true);
			addAnimation("idle" + DOWN, [9,10], 10, true);
			addAnimation("idle" + LEFT, [3,4], 10, true);
			//attack anim
			addAnimation("attack" + UP, [8], 10, false);
			addAnimation("attack" + LEFT, [5], 10, false);
			addAnimation("attack" + DOWN, [11], 10, false);
			addAnimation("attack" + RIGHT, [2], 10, false);
			
			m_explosion.load();
			
		}
		
		
		override public function attack():void {
			m_state = "attack";
			m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			play("attack" + facing);
		}
		
		override public function update():void {
			if (!onScreen()) return;
			checkPlayersDamage();
			twinkle();
			switch(m_state) {
				case "idle": 
							facing = getFacingToTarget(m_target);
							trace(facing);
							play("idle" + facing);
							if (m_timerAttack.finished) {
								m_state = "attack";
								play("attack" + facing);
								goTo(m_target);
								m_speed *= 1.5;
							} break;
				case "attack":  move();
								if (collide(Global.player1)) {
									m_target = Global.player1;
									explode();
								}else if (collide(Global.player2)) {
									m_target = Global.player2;
									explode();
								}
								break;
				case "dead": die();
							break;
			}
		}
		
		protected function explode() {
			m_explosion.playSmoke(x, y);
			removeFromStage();
			m_target.takeDamage();
			m_state = "exploded";
		}
		
		override public function move() : void {
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
			if ( this.interactWithEnv() ) {
				this.x = m_oldPos.x;
				if (m_state == "attack")
					explode();
			}
			if ( this.interactWithEnv() ) {
				this.y = m_oldPos.y;
				if (m_state == "attack")
					explode();
			}
		}
	}

}