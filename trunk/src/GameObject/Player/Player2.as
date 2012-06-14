package GameObject.Player 
{
	import GameObject.PlayableObject;
	import GameObject.Weapon.PlayerThrowable;
	import GameObject.Weapon.Throwable;
	import GameObject.Weapon.Weapon;
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
			setHitbox(16, 16, 16, 16);
			m_stringValidate = "K";
			m_stringNext = "L";
			m_stringPrevious = "M";	
			
			m_equipement.m_throwable = PlayerThrowable.Egg();
			m_equipement.m_weapon.visible = false;
			setHitbox(8, 14, 31, 24);
			m_name = "Player2";
			if (Global.nbPlayers == 1)
				visible = false;
		}
		
		override public function createThrowables():void {
			m_throwables = new Vector.<PlayerThrowable>();
			var thr:PlayerThrowable;
			for (var i:int = 0; i < 15; i++) {
				thr = PlayerThrowable.Egg();
				thr.m_enemies = m_enemies;
				thr.setCaster(this);
				m_throwables.push(thr);
			}
		}
		
		override public function load():void {
			super.load();
			//IDLE ANIM
			addAnimation("idle" + UP, [18,19,20,19], 15, true);
			addAnimation("idle" + RIGHT, [0,1,2,1], 15, true);
			addAnimation("idle" + DOWN, [12,13,14,13], 15, true);
			addAnimation("idle" + LEFT, [6,7,8,7], 15, true);
			//walk anim
			addAnimation("walk" + UP, [18,19,20,19], 25, true);
			addAnimation("walk" + RIGHT, [0,1,2,1], 25, true);
			addAnimation("walk" + DOWN, [12,13,14,13], 25, true);
			addAnimation("walk" + LEFT, [6,7,8,7], 25, true);	
			//attack anim
			addAnimation("attack" + UP, [33,34,35], 10, false);
			addAnimation("attack" + RIGHT, [24,25,26], 10, false);
			addAnimation("attack" + DOWN, [30,31,32], 10, false);
			addAnimation("attack" + LEFT, [27,28,29], 10, false);
			//attack anim
			addAnimation("attack2" + UP, [35,34,33], 10, false);
			addAnimation("attack2" + RIGHT, [26,25,24], 10, false);
			addAnimation("attack2" + DOWN, [32,31,30], 10, false);
			addAnimation("attack2" + LEFT, [29,28,27], 10, false);
			//throw anim
			addAnimation("throw" + UP, [21,22], 10, false);
			addAnimation("throw" + RIGHT,[3,4], 10, false);
			addAnimation("throw" + DOWN, [15, 16], 10, false);
			addAnimation("throw" + LEFT, [9,10], 10, false);
			//rush anim
			addAnimation("rush" + UP, [23], 10, false);
			addAnimation("rush" + RIGHT, [5], 10, false);
			addAnimation("rush" + DOWN, [17], 10, false);
			addAnimation("rush" + LEFT, [11], 10, false);
		}
		
		override public function update():void {
			if(Global.nbPlayers == 2)
				super.update();
		}
		
		override public function getMoves():void {
			if (Global.nbPlayers == 1)
				return;
			//check second attack
			if (FlxG.keys.justPressed(m_stringNext) && m_state == "waitForAttack2" )
				attack();
				
			if (isBusy() || m_blocked || m_state == "rushAttack")
				return;
			
			if (FlxG.keys.justPressed(m_stringPrevious)) {
				if(!m_onSpecial){
					triggerSpecial();
					return;
				}else{
					unspecial();
				}
			}
			//on special/AntySpecial state Touky can't shoot
			if (!m_onSpecial && m_state != "rushAttack"){
				if (FlxG.keys.justPressed(m_stringValidate) ){
					throwIt();
					return;
				}else if (FlxG.keys.justPressed(m_stringNext) ){
					attack();
					return;
				}
			}
							
			//moving
			var yForce:int = 0;
			var xForce:int = 0;
			var pressedDirection:Boolean = false;
			
			if (FlxG.keys.UP) { 
				if(!m_scrollBlockUp){
					pressedDirection = true;
					yForce-= 1;
				}
				facing = UP;
			}
			if (FlxG.keys.DOWN ) {
				if(!m_scrollBlockDown){
					pressedDirection = true;
					yForce += 1;
				}
				facing = DOWN;
			}
			if (FlxG.keys.LEFT ) {
				if(!m_scrollBlockLeft){
					pressedDirection = true;
					xForce -= 1;
				}
				facing = LEFT;
			}
			if (FlxG.keys.RIGHT ) {
				if(!m_scrollBlockRight){
					pressedDirection = true;
					xForce += 1;
				}
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
			m_camembert.trigger(10,true);
		}
		
		override public function unspecial():void {
			m_onSpecial = false;
			m_timerSpecialAvailable.start(5);
			m_camembert.trigger(5);
		}
		
		override public function placeOtherPlayer():void {
			Global.player1.place(x, y + 15);
		}
		
		override public function triggerRushAttack(p1facing:uint ):void { 
			m_state = "rushAttack";
			facing = p1facing;
			play("rush" + facing);
		}
		
		override public function takeDamage():Boolean {
			if ( !super.takeDamage())
				return false;
			
			//FOR SPECIAL MOVES
			if (m_onSpecial) {
				Global.player1.takeDamage();
			}
			Global.menuPlayer2.takeDamage();
			return true;
		}
	}

}