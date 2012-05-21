package GameObject.Player 
{
	import flash.net.URLVariables;
	import GameObject.Item.Item;
	import GameObject.Item.ItemRestore;
	import GameObject.PlayableObject;
	import GameObject.Weapon.PlayerThrowable;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import Server.URLRequestPHP;
	/**
	 * ...
	 * @author ...
	 */
	public class Player1 extends PlayableObject
	{
		private var m_normalSpeed:Number;
		private var m_tabPlaceThrowable:Array;
		
		public function Player1(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, null);
			m_url = "Images/Players/anty.png";
			Global.player1 = this;
			m_stringNext = "G";
			m_stringPrevious = "H";
			m_stringValidate = "F";
			
			m_name = "Player1";
			setHitbox(16, 16, 16, 16);
			createTabPlaceThrowable();
			m_equipement.m_throwable = PlayerThrowable.Ant();
			
			m_normalSpeed = m_speed;
		}		
				
		override public function createThrowables():void {
			m_throwables = new Vector.<PlayerThrowable>();
			var thr:PlayerThrowable;
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
			addAnimation("idle" + UP, [32], 10, true);
			addAnimation("idle" + RIGHT, [5], 10, true);
			addAnimation("idle" + DOWN, [23], 10, true);
			addAnimation("idle" + LEFT, [14], 10, true);
			//walk anim
			addAnimation("walk" + UP, [27,28,29,28], 15, true);
			addAnimation("walk" + RIGHT, [0,1,2,1], 15, true);
			addAnimation("walk" + DOWN, [18,19,20,19], 15, true);
			addAnimation("walk" + LEFT, [9,10,11,10], 15, true);	
			//attack anim
			addAnimation("attack" + UP, [54,55,56] , 10, false);
			addAnimation("attack" + RIGHT, [36,37,38], 10, false);
			addAnimation("attack" + DOWN, [42,43,44], 10, false);
			addAnimation("attack" + LEFT, [39,40,41], 10, false);
			//attack2d anim
			addAnimation("attack2" + UP, [57,58,59], 10, false);
			addAnimation("attack2" + RIGHT, [45,46,47], 10, false);
			addAnimation("attack2" + DOWN, [51,52,53], 10, false);
			addAnimation("attack2" + LEFT, [48,49,50], 10, false);
			//throw anim
			addAnimation("throw" + UP, [30,31], 10, false);
			addAnimation("throw" + RIGHT,[3,4], 10, false);
			addAnimation("throw" + DOWN, [21,22], 10, false);
			addAnimation("throw" + LEFT, [12,13], 10, false);
			//rush attack
			addAnimation("rush" + UP, [33,34,35], 40, true);
			addAnimation("rush" + RIGHT, [6,7,8], 40, true);
			addAnimation("rush" + DOWN, [24,25,26], 40, true);
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
		
		override public function placeThrowable(thr:PlayerThrowable):void {
			var pt:FlxPoint = m_tabPlaceThrowable[Utils.getDirectionID(m_directionFacing)];
			thr.place(x + pt.x, y + pt.y);
		}
		
		private function createTabPlaceThrowable():void {
			m_tabPlaceThrowable = new Array();
			m_tabPlaceThrowable.push(new FlxPoint(10, -10)); //0
			m_tabPlaceThrowable.push(new FlxPoint(30, 13)); //1
			m_tabPlaceThrowable.push(new FlxPoint(30, 13)); //2
			m_tabPlaceThrowable.push(new FlxPoint(30, 13)); //3
			m_tabPlaceThrowable.push(new FlxPoint(10, 15)); //4
			m_tabPlaceThrowable.push(new FlxPoint(-10, 13)); //5
			m_tabPlaceThrowable.push(new FlxPoint(-10, 13)); //6
			m_tabPlaceThrowable.push(new FlxPoint(-10, 13)); //7		
		}
	}

}