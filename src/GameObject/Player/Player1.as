package GameObject.Player 
{
	import flash.net.URLVariables;
	import GameObject.Item.Item;
	import GameObject.Item.ItemRestore;
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	import Server.URLRequestPHP;
	/**
	 * ...
	 * @author ...
	 */
	public class Player1 extends PlayableObject
	{
		public function Player1(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, null);
			m_url = "Images/Players/hero.png";
			Global.player1 = this;
			m_stringNext = "G";
			m_stringPrevious = "H";
			m_stringValidate = "F";
			
			m_name = "Player1";
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
			addAnimation("walk" + RIGHT, Utils.getArrayofNumbers(60,62), 10, true);
			addAnimation("walk" + DOWN, Utils.getArrayofNumbers(72, 74), 10, true);
			addAnimation("walk" + LEFT, Utils.getArrayofNumbers(84, 86), 10, true);	
			//attack anim
			addAnimation("attack" + UP, Utils.getArrayofNumbers(11,0), 40, false);
			addAnimation("attack" + RIGHT, Utils.getArrayofNumbers(23,12), 40, false);
			addAnimation("attack" + DOWN, Utils.getArrayofNumbers(35, 24), 40, false);
			addAnimation("attack" + LEFT, Utils.getArrayofNumbers(47, 36), 40, false);
			//attack2d anim
			addAnimation("attack2" + UP, Utils.getArrayofNumbers(0,11), 40, false);
			addAnimation("attack2" + RIGHT, Utils.getArrayofNumbers(12,23), 40, false);
			addAnimation("attack2" + DOWN, Utils.getArrayofNumbers(24,35), 40, false);
			addAnimation("attack2" + LEFT, Utils.getArrayofNumbers(36,47), 40, false);
			//throw anim
			addAnimation("throw" + UP, [11,0], 100, false);
			addAnimation("throw" + RIGHT,[23, 12], 100, false);
			addAnimation("throw" + DOWN, [35, 24], 100, false);
			addAnimation("throw" + LEFT, [47, 36], 100, false);
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
			
			//Moving
			var yForce:int = 0;
			var xForce:int = 0;
			var pressedDirection = false;
						
			if (FlxG.keys.Z && !m_scrollBlockUp) { 
				pressedDirection = true;
				yForce-= 1;
				facing = UP;
			}
			if (FlxG.keys.S && !m_scrollBlockDown) {
				pressedDirection = true;
				yForce += 1;
				facing = DOWN;
			}
			if (FlxG.keys.Q && !m_scrollBlockLeft){
				pressedDirection = true;
				xForce -= 1;
				facing = LEFT;
			}
			if (FlxG.keys.D && !m_scrollBlockRight){
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
		
		override public function special():void {
			if (!this.collide(Global.player2) || !m_timerSpecialAvailable.finished)
				return;
			m_onSpecial = true;
			m_timerSpecial.start(10);
		}
		
		override public function unspecial():void {
			m_onSpecial = false;
			m_timerSpecialAvailable.start(5);
		}
		
		override public function placeOtherPlayer():void {
			Global.player2.place(x, y + 15);
		}
		
	}

}