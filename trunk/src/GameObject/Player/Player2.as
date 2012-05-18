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
			m_url = "Images/Players/touky.png";
			Global.player2 = this;
			m_width = 48;
			m_height = 48;
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
			addAnimation("idle" + UP, [49], 15, true);
			addAnimation("idle" + RIGHT, [0,1,2], 15, true);
			addAnimation("idle" + DOWN, [73], 10, true);
			addAnimation("idle" + LEFT, [6,7,8], 15, true);
			//walk anim
			addAnimation("walk" + UP, [0,1,2], 30, true);
			addAnimation("walk" + RIGHT, [0,1,2], 30, true);
			addAnimation("walk" + DOWN, Utils.getArrayofNumbers(72, 74), 10, true);
			addAnimation("walk" + LEFT, [6,7,8], 30, true);	
			//attack anim
			addAnimation("attack" + UP, Utils.getArrayofNumbers(11,0), 40, false);
			addAnimation("attack" + RIGHT, [3,4], 1, false);
			addAnimation("attack" + DOWN, Utils.getArrayofNumbers(35, 24), 40, false);
			addAnimation("attack" + LEFT, Utils.getArrayofNumbers(47, 36), 40, false);
			//attack anim
			addAnimation("attack2" + UP, Utils.getArrayofNumbers(0,11), 40, false);
			addAnimation("attack2" + RIGHT, Utils.getArrayofNumbers(12,23), 40, false);
			addAnimation("attack2" + DOWN, Utils.getArrayofNumbers(24,35), 40, false);
			addAnimation("attack2" + LEFT, Utils.getArrayofNumbers(36,47), 40, false);
			//throw anim
			addAnimation("throw" + UP, [11,0], 100, false);
			addAnimation("throw" + RIGHT,[3,4], 20, false);
			addAnimation("throw" + DOWN, [35, 24], 100, false);
			addAnimation("throw" + LEFT, [9,10], 100, false);
			//defense anim
			addAnimation("rush" + UP, [5], 10, false);
			addAnimation("rush" + RIGHT, [5], 10, false);
			addAnimation("rush" + DOWN, [72], 10, false);
			addAnimation("rush" + LEFT, [11], 10, false);
			//magic anim
			addAnimation("magic" + UP, Utils.getArrayofNumbers(11,0), 10, true);
			addAnimation("magic" + RIGHT, Utils.getArrayofNumbers(23, 12), 10, true);
			addAnimation("magic" + DOWN, Utils.getArrayofNumbers(35, 24), 10, true);
			addAnimation("magic" + LEFT, Utils.getArrayofNumbers(47, 36), 10, true);
		}
		
		override public function getMoves():void {
			//check second attack
			if (FlxG.keys.justPressed(m_stringNext) && m_state == "waitForAttack2" )
				attack();
				
			if (isBusy() || m_blocked || m_state == "rushAttack")
				return;
			
			if (FlxG.keys.justPressed(m_stringPrevious)) {
				if(!m_onSpecial)
					triggerSpecial()
				else
					unspecial();
			}
			//on special/AntySpecial state Touky can't shoot
			if (!m_onSpecial && m_state != "rushAttack"){
				if (FlxG.keys.justPressed(m_stringValidate) ){
					throwIt();
				}else if (FlxG.keys.justPressed(m_stringNext) ){
					attack();
				}
			}
							
			//moving
			var yForce:int = 0;
			var xForce:int = 0;
			var pressedDirection:Boolean = false;
			
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
		
		override public function triggerSpecial():void {
			if (!this.collide(Global.player1) || !m_timerSpecialAvailable.finished)
				return;
			m_onSpecial = true;
			m_timerSpecial.start(10);
		}
		
		override public function unspecial():void {
			m_onSpecial = false;
			m_timerSpecialAvailable.start(5);
		}
		
		override public function placeOtherPlayer():void {
			Global.player1.place(x, y + 15);
		}
		
		override public function triggerRushAttack(p1facing:uint ):void { 
			m_state = "rushAttack";
			facing = p1facing;
			play("rush" + facing);
		}
		
		override public function takeDamage():void {
			super.takeDamage();
			
			//FOR SPECIAL MOVES
			if (m_onSpecial) {
				Global.player1.takeDamage();
			}
			Global.menuPlayer2.takeDamage();
		}
	}

}