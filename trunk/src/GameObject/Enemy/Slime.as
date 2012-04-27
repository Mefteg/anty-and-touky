package GameObject.Enemy 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Slime extends Enemy 
	{
		
		public function Slime(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)  
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Enemies/slime.png";
			m_width = 24;
			m_height = 24;
			m_distanceToAttack = 40;
			m_target = getRandomPlayer();
		}
		
		override public function update() : void {
			if (m_blocked) return;
							
			switch ( m_state ) {
				case "idle":
					m_anim = "idle";
					break;
				case "walk":
					m_anim = "walk";
					move();
					break;
				case "lookfor":
					m_anim = "walk";
					lookfor();
					break;
				case "hit":
					m_anim = "hit";
					facing = m_hit;
					if (m_timerHit.finished)
						m_state = "lookfor";
					break;
				case "attacking":
					if (finished) {
						giveDamage();
						m_state = "lookfor";
						m_timerAttack.start(m_attackTime);
					}
					break;
				case "attack":
					if (m_timerAttack.finished) {
						m_anim = "attack";
						m_state = "attacking";
					}
					break;
				case "dead": if (m_timerDeath.finished)
									removeFromStage();
							break;
				default:
					break;
			}
			
			//plays the animation
			play(m_anim + facing);
		}
		
		override public function load():void {
			super.load();
			//IDLE ANIM
			addAnimation("idle" + UP, [0,1,2,1], 5, true);
			addAnimation("idle" + RIGHT, [0,1,2,1], 5, true);
			addAnimation("idle" + DOWN, [0,1,2,1], 5, true);
			addAnimation("idle" + LEFT, [0,1,2,1], 5, true);	
			//walk anim
			addAnimation("walk" + UP, [0,1,2,1], 3, true);
			addAnimation("walk" + RIGHT,[0,1,2,1], 3, true);
			addAnimation("walk" + DOWN, [0,1,2,1], 3, true);
			addAnimation("walk" + LEFT, [0,1,2,1], 3, true);
			//attack anim
			addAnimation("attack" + UP, [15,18,19,8,9], 3, false);
			addAnimation("attack" + LEFT, [5,6,7,8,9], 3, false);
			addAnimation("attack" + DOWN, [15,16,17,8,9], 3, false);
			addAnimation("attack" + RIGHT, [10,11,12,13,14], 3, false);
			//hit
			addAnimation("hit" + m_hit, [14], 1);
			
			play("idle" + UP);
			
		}
		
		override public function lookfor():void {
			if (m_pushed)
				return;
			goTo(m_target);
			//check if an attack is available
			if (Utils.distance(getCenter(), m_target.getCenter()) < m_distanceToAttack) {
				m_state = "attack";
			}else{
				m_state = "walk";
			}
		}
	
	}

}