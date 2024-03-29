package GameObject.Enemy 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class PenguinJetpack extends FlyingEnemy 
	{
		var m_explosion:EnemySmoke;
		var m_targetHit:Boolean = false;
		
		public function PenguinJetpack(X:Number, Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/pingouinJetpack.png";
			m_width = 32; m_height = 32;
			m_timerAttack = new FlxTimer();
			m_timerAttack.start(4);
			switch(Global.difficulty){
				case 1 : m_stats.initHP(1); break;
				case 2 : m_stats.initHP(2); break;
				case 3 : m_stats.initHP(2); break;
			}
			m_state = "idle";
			m_explosion = EnemySmoke.Explosion();
			m_points = 40;
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
		
		public function init(X:Number, Y:Number):void {
			if (m_state =="attacking")
				return;
			x = X; y = Y;
			m_stats.initHP(2);
			m_state = "goToBeforeAction";
			facing = getFacingToTarget(m_target);
			play("idle" + facing);
			m_targetHit = false;
			addToStage();
		}
		
		public function activate():void {
			m_state = "idle";
			m_timerAttack.start(2);
		}
		
		override public function attack():void {
			m_state = "attack";
			m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			play("attack" + facing);
		}
		
		override public function update():void {
			if ( !commonEnemyUpdate()) return;
			switch(m_state) {
				case "idle": 
							facing = getFacingToTarget(m_target);
							//trace(facing);
							play("idle" + facing);
							if (m_timerAttack.finished) {
								m_state = "attack";
								play("attack" + facing);
								goTo(m_target);
								m_speed = 4;
							} break;
				case "attack":  move();
								checkExplosionOnPlayers();
								break;
				case "dead": die(); break;
				default : break;
			}
		}
		
		public function explode():void {
			m_explosion.playSmoke(x, y);
			removeFromStage();
			if (m_targetHit)
				m_target.takeDamage();
			m_state = "exploded";
		}
		
		private function checkExplosionOnPlayers():void {
			if (Global.soloPlayer) {
				if (collide(Global.soloPlayer)) {
					m_target = Global.soloPlayer;
					m_targetHit = true;
					explode();
				}
				return;
			}
			if (collide(Global.player1)) {
				m_target = Global.player1;
				m_targetHit = true;
				explode();
			}else if (collide(Global.player2)) {
				m_target = Global.player2;
				m_targetHit = true;
				explode();
			}
		}
				
		override public function move() : void {
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
			if (m_state == "goToBeforeAction")
				return;
			
			if ( this.collideWithEnv() ) {
				this.x = m_oldPos.x;
				if (m_state == "attack")
					explode();
			}
			if ( this.collideWithEnv() ) {
				this.y = m_oldPos.y;
				if (m_state == "attack")
					explode();
			}
		}
		
		override public function collideWithTileType(_type:int) : Boolean
		{
			var collide:Boolean = false;
			
			if (
			_type == TilesManager.PHYSICAL_TILE ||
			_type == TilesManager.PIPE_TILE
			)
			{
				collide = true;
			}
			
			return collide;
		}
	}

}