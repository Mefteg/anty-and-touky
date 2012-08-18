package GameObject.Enemy.ElectricSnake 
{
	import GameObject.Enemy.Enemy;
	import GameObject.Weapon.EnemyThrowable;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class ElectricSnake extends Enemy 
	{
		private var m_parts:Array;
		private var m_nbParts:int = 4;
		
		private var m_initialY:Number;
		
		private var m_angle:Number;
		
		public function ElectricSnake(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/ElectricSnake/head.png";
			m_width = 64; m_height = 64;
			m_collideEvtFree = true;
			if(Global.nbPlayers == 1)
				m_stats.initHP(12);
			else
				m_stats.initHP(20)
			setHitbox(8, 20, 48, 32);
			m_state = "MovingUp";
			m_direction = new FlxPoint(0, -1);
			m_initialY = y;
			m_angle = 0;
			createParts();
			createThrowables();
		}
		
		override protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable;
			for (var i:int = 0; i < 3; i++) {
				thr = EnemyThrowable.ElecBall();
				thr.setCaster(this);
				m_throwables.push(thr);
			}
			commomThrowPlacement();
		}
		
		private function createParts():void {
			var step:Number = 0.5 / m_nbParts;
			m_parts = new Array();
			for (var i:int = 0; i < m_nbParts; i++){
				m_parts.push(new ElectricSnakePart(x+10, y+20));
				m_parts[i].m_direction = m_direction;
				m_parts[i].scale = new FlxPoint(0.4+i*step,0.5+i*step);
			}
		}
		////////////////ACTIONS/////////////////////////////
		
		private function moveUp():void {
			move();
			if (y < m_initialY - m_nbParts * 30)
				attack();
			
			var ind:int = (m_initialY -y) / 30;
			trace(ind);
			for (var i:int = ind+1; i < m_nbParts; i++)
				m_parts[i].move();
		}
		
		override public function attack():void {
			m_target = getRandomPlayer();
			m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			if (m_target.x +m_target.m_width * 0.5 < x + m_width * 0.5)
				facing = LEFT;
			else
				facing = RIGHT;
			m_state = "Attacking";
			var thr:EnemyThrowable = getThrowable();
			thr.place(x+m_throwPlaceArray[facing].x, y+m_throwPlaceArray[facing].y);
			thr.attack(facing);
			play("attack" + facing);
			m_timerAttack.start(0.5);
		}
		
		override public function update():void {
			if (!commonEnemyUpdate())
				return;
			m_angle +=0.05;
			angle = 10 * Math.sin(m_angle);
			switch(m_state) {
				case "MovingUp": moveUp(); break;
				case "Idle": if (m_timerAttack.finished)
								attack();
							break;
				case "Attacking": if (m_timerAttack.finished) {
										m_state = "Idle";
										m_timerAttack.start(Utils.random(3, 4));
										play("walk" + facing);
									}
									break;
				case "dead" : die();
				default : break;
			}
		}
				
		////////////LOADING/////////////////////////::
		override public function addToStage() : void {
			for (var i:int = 0; i < m_nbParts; i++) {
				m_parts[i].addToStage();
			}
			super.addToStage();
		}
		
		override public function die():void {
			for (var i:int = 0; i < m_nbParts; i++) {
				m_parts[i].triggerDeath((m_nbParts-1-i) * 0.2 + 0.2);
			}
			super.die();
		}
				
		override public function addBitmap():void {
			super.addBitmap();
			m_parts[0].addBitmap();
			m_throwables[0].addBitmap();
		}
		
		override public function load():void {
			super.load();
			
			for (var i:int = 0; i < m_nbParts; i++)
				m_parts[i].load();
			for (var i:int = 0; i < m_throwables.length; i++)
				m_throwables[i].load();
				
			addAnimation("walk" + RIGHT, [1], 5, false);
			addAnimation("walk" + LEFT, [0], 5, false);
			addAnimation("attack" + RIGHT, [3], 5, false);
			addAnimation("attack" + LEFT, [2], 5, false);
			
			play("walk" + LEFT);
		}
	}

}