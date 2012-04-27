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
			addAnimation("throw" + UP, Utils.getArrayofNumbers(11,0), 10, false);
			addAnimation("throw" + RIGHT, Utils.getArrayofNumbers(23, 12), 10, false);
			addAnimation("throw" + DOWN, Utils.getArrayofNumbers(35, 24), 10, false);
			addAnimation("throw" + LEFT, Utils.getArrayofNumbers(47, 36), 10, false);
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
			if (isBusy() || m_blocked)
				return;
				
			if (FlxG.keys.justPressed("SPACE")) {
				m_itemManager.useItem("potion");
			}
			if (isBusy())
				return;
			//defense
			if (FlxG.keys.justPressed("Q") && FlxG.keys.justPressed("D")) {
				m_state = "defense";
				play(m_state + facing);
				m_timerDefense.start(1);
				return;
			}
			
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
				m_state = "walk";
				move();
			}else {
				m_state = "idle";
			}
			play(m_state + facing);
			
			freeScrollBlocking();
		}
		
	}

}