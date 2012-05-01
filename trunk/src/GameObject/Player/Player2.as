package GameObject.Player 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class Player2 extends PlayableObject
	{		
		public function Player2(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, null);
			m_url = "Images/Players/hero.png";
			Global.player2 = this;
			/*
			m_stringValidate = "NUMPADONE";
			m_stringNext = "NUMPADTWO";
			m_stringPrevious = "NUMPADTHREE";*/
			
			m_stringValidate = "K";
			m_stringNext = "L";
			m_stringPrevious = "M";
			
			m_name = "Player2";
		}
		
		override public function load():void {
			super.load();
			//IDLE ANIM
			addAnimation("idle" + UP, [49], 10, true);
			addAnimation("idle" + RIGHT, [61], 10, true);
			addAnimation("idle" + DOWN, [73], 10, true);
			addAnimation("idle" + LEFT, [85], 10, true);
			//walk anim
			addAnimation("walk" + UP, Utils.getArrayofNumbers(48,50), 10, true);
			addAnimation("walk" + RIGHT, Utils.getArrayofNumbers(60, 62), 10, true);
			addAnimation("walk" + DOWN, Utils.getArrayofNumbers(72, 74), 10, true);
			addAnimation("walk" + LEFT, Utils.getArrayofNumbers(84, 86), 10, true);	
			//attack anim
			addAnimation("attack" + UP, Utils.getArrayofNumbers(11,0), 40, false);
			addAnimation("attack" + RIGHT, Utils.getArrayofNumbers(23,12), 40, false);
			addAnimation("attack" + DOWN, Utils.getArrayofNumbers(35, 24), 40, false);
			addAnimation("attack" + LEFT, Utils.getArrayofNumbers(47, 36), 40, false);
			//attack anim
			addAnimation("attack2" + UP, Utils.getArrayofNumbers(0,11), 40, false);
			addAnimation("attack2" + RIGHT, Utils.getArrayofNumbers(12,23), 40, false);
			addAnimation("attack2" + DOWN, Utils.getArrayofNumbers(24,35), 40, false);
			addAnimation("attack2" + LEFT, Utils.getArrayofNumbers(36,47), 40, false);
			//throw anim
			addAnimation("throw" + UP, [11,0], 100, false);
			addAnimation("throw" + RIGHT,[23, 12], 100, false);
			addAnimation("throw" + DOWN, [35, 24], 100, false);
			addAnimation("throw" + LEFT, [47, 36], 100, false);
			//defense anim
			addAnimation("defense" + UP, [48], 10, false);
			addAnimation("defense" + RIGHT, [60], 10, false);
			addAnimation("defense" + DOWN, [72], 10, false);
			addAnimation("defense" + LEFT, [84], 10, false);
			//magic anim
			addAnimation("magic" + UP, Utils.getArrayofNumbers(11,0), 10, true);
			addAnimation("magic" + RIGHT, Utils.getArrayofNumbers(23, 12), 10, true);
			addAnimation("magic" + DOWN, Utils.getArrayofNumbers(35, 24), 10, true);
			addAnimation("magic" + LEFT, Utils.getArrayofNumbers(47, 36), 10, true);
			//item anim
			addAnimation("item" + UP, Utils.getArrayofNumbers(11,0), 10, false);
			addAnimation("item" + RIGHT, Utils.getArrayofNumbers(23, 12), 10, false);
			addAnimation("item" + DOWN, Utils.getArrayofNumbers(35, 24), 10, false);
			addAnimation("item" + LEFT, Utils.getArrayofNumbers(47, 36), 10, false);
		}
		
		override public function getMoves():void {
			super.getMoves();
			
			if (isBusy() || m_blocked)
				return;
				
			//defense
			if (FlxG.keys.justPressed("LEFT") && FlxG.keys.justPressed("RIGHT")){
				m_state = "defense";
				play(m_state + facing);
				m_timerDefense.start(1);
				return;
			}
			
			//moving
			var yForce:int = 0;
			var xForce:int = 0;
			var pressedDirection = false;
			
			if (FlxG.keys.UP && !m_scrollBlockUp) { 
				pressedDirection = true;
				yForce-= 1;
				facing = UP;
			}
			if (FlxG.keys.DOWN && !m_scrollBlockDown) {
				pressedDirection = true;
				yForce += 1;
				facing = DOWN;
			}
			if (FlxG.keys.LEFT && !m_scrollBlockLeft) {
				pressedDirection = true;
				xForce -= 1;
				facing = LEFT;
			}
			if (FlxG.keys.RIGHT && !m_scrollBlockRight) {
				pressedDirection = true;
				xForce += 1;
				facing = RIGHT;
			}
		
			if(pressedDirection){
				m_direction.x = xForce;
				m_direction.y = yForce;
				m_directionFacing = m_direction;
				if(m_state != "throw")
					m_state = "walk";
				move();
			}else {
				if(m_state != "throw")
					m_state = "idle";
			}
			play(m_state + facing);
			
			freeScrollBlocking();
		}
		
	}

}