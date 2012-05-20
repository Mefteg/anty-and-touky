package GameObject.Player 
{
	import flash.net.URLVariables;
	import GameObject.Item.Item;
	import GameObject.Item.ItemRestore;
	import GameObject.PlayableObject;
	import GameObject.Weapon.PlayerThrowable;
	import org.flixel.FlxG;
	import Server.URLRequestPHP;
	/**
	 * ...
	 * @author ...
	 */
	public class Player1 extends PlayableObject
	{
		private var m_normalSpeed:Number;
		
		public function Player1(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, null);
			m_url = "Images/Players/anty.png";
			Global.player1 = this;
			m_stringNext = "G";
			m_stringPrevious = "H";
			m_stringValidate = "F";
			
			m_name = "Player1";
			
			m_equipement.m_throwable = PlayerThrowable.Ant();
			
			m_normalSpeed = m_speed;
		}		
				
		override public function createThrowables():void {
			m_throwables = new Vector.<PlayerThrowable>();
			var thr:PlayerThrowable = m_equipement.m_throwable;
			thr.m_enemies = m_enemies;
			thr.setCaster(this);
			m_throwables.push(thr);
			for (var i:int = 0; i < 15; i++) {
				thr = PlayerThrowable.Ant();
				thr.m_enemies = m_enemies;
				thr.setCaster(this);
				m_throwables.push(thr);
			}
		}
		
		override public function load():void {
			super.load();
			//IDLE ANIM
			addAnimation("idle" + UP, [49], 10, true);
			addAnimation("idle" + RIGHT, [5], 10, true);
			addAnimation("idle" + DOWN, [73], 10, true);
			addAnimation("idle" + LEFT, [14], 10, true);
			//walk anim
			addAnimation("walk" + UP, Utils.getArrayofNumbers(48,50), 10, true);
			addAnimation("walk" + RIGHT, [0,1,2,1], 10, true);
			addAnimation("walk" + DOWN, Utils.getArrayofNumbers(72, 74), 10, true);
			addAnimation("walk" + LEFT, [9,10,11,10], 10, true);	
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
			addAnimation("throw" + RIGHT,[3,4], 10, false);
			addAnimation("throw" + DOWN, [35, 24], 100, false);
			addAnimation("throw" + LEFT, [12,13], 100, false);
			//rush attack
			addAnimation("rush" + UP, [23], 40, true);
			addAnimation("rush" + RIGHT, [6,7,8], 40, true);
			addAnimation("rush" + DOWN, [17], 40, true);
			addAnimation("rush" + LEFT, [15,16,17], 40, true);
		}
		
		override public function getMoves():void {	
			//check second attack
			if (FlxG.keys.justPressed(m_stringNext) && m_state == "waitForAttack2" )
				attack();
			//if busy or blocked or on special(for Anty) return
			if (isBusy() || m_blocked || m_onSpecial)
				return;
			
			//in special state Anty can't shoot
			if (!m_onSpecial) {
				if (FlxG.keys.justPressed(m_stringPrevious)) {
					triggerSpecial()
					return;
				}else if (FlxG.keys.justPressed(m_stringValidate) ){
					throwIt();
					return;
				}else if (FlxG.keys.justPressed(m_stringNext) ){
					attack();
					return;
				}
			}
			
			//Moving
			var yForce:int = 0;
			var xForce:int = 0;
			var pressedDirection:Boolean = false;
						
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
				if (m_state != "throw" ) {
					m_state = "idle";
				}
			}
			play(m_state + facing);
			
			freeScrollBlocking();
		}
		
		override public function triggerSpecial():void {
			if (!this.collide(Global.player2) || !m_timerSpecialAvailable.finished)
				return;
			m_onSpecial = true;
			m_state = "rushAttack";
			//player 2
			Global.player2.triggerRushAttack(facing);
			m_timerSpecial.start(10);
			//put the right direction
			m_direction = m_directionFacing;
			//...and speed
			m_speed *= 4;
			play("rush"+facing);
		}
		
		override public function unspecial():void {
			m_onSpecial = false;
			m_state = "idle";
			m_speed = m_normalSpeed;
			Global.player2.m_state = "idle";
			m_timerSpecialAvailable.start(5);
		}
		
		override public function placeOtherPlayer():void {
			Global.player2.place(x+5, y - 15);
		}
		
		override public function rushAttack():void {
			if (interactWithEnv())
				unspecial();
			else
				move();
		}
		
		override public function takeDamage():void {
			super.takeDamage();
			Global.menuPlayer1.takeDamage();
		}
	}

}