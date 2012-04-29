package GameObject.Enemy 
{
	import GameObject.Weapon.EnemyThrowable;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Tom
	 */
	public class MonkeyTest extends Enemy 
	{
		private static var s_monkeys:Array = new Array();
		
		private var m_fsm:Object;
		
		public var m_boss:MonkeyTest;
		
		public function MonkeyTest(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Enemies/slime.png";
			m_width = 24;
			m_height = 24;
			
			m_fsm = new Object;
			m_fsm["idle"] = this.idle;
			m_fsm["lookfor"] = this.lookfor;
			m_fsm["mimic"] = this.mimic;
			m_fsm["walk"] = this.walk;
			m_fsm["hit"] = this.hit;
			m_fsm["attack"] = this.attack;
			m_fsm["dead"] = this.dead;
			
			m_state = "idle";
			
			s_monkeys.push(this);
			
			m_name = "MonkeyTest" + (s_monkeys.length - 1);
		}
		
		override public function update() : void {
			var action:Function = m_fsm[m_state];
			if ( action ) {
				action();
			}
			else {
				trace("unknown action");
			}
			
			if ( FlxG.keys.justPressed("B") ) {
				if ( s_monkeys.length > 0 ) {
					s_monkeys[0].m_state = "dead";
				}
			}
		}
		
		protected function idle() : void {
			m_state = "lookfor";
		}
		
		override public function lookfor() : void {
			// if I still have life points
			if ( m_stats.m_hp_current > 0 ) {
				// if I don't have a boss
				if ( m_boss == null ) {
					var nearest:MonkeyTest;
					// looking for the nearest monkey which doesnt have a boss
					for ( var i:int = 0; i < s_monkeys.length; i++ ) {
						if ( s_monkeys[i] != this ) {
							if ( s_monkeys[i].m_boss == null ) {
								// compute the distance ...
								//nearest = s_monkeys[i];
								s_monkeys[i].m_boss = this;
								trace(m_name + " found a subordinate : " + s_monkeys[i].m_name);
							}
						}
					}
					
					// if I'm near enough to attack
					// otherwhise I look for the nearest player
					// now I focus my target
					m_state = "walk";
				}
				else {
					// I mimic my boss
					m_state = "mimic";
				}
			}
			else {
				m_state = "dead";
			}
		}
		
		protected function mimic() : void {
			// if I still have a boss
			if ( m_boss ) {
				// I'm not a lemming... 
				if ( m_boss.m_state != "dead" ) {
					m_fsm[m_boss.m_state]();
				}
			}
			else {
				m_state = "lookfor";
			}
		}
		
		protected function walk() : void {
			m_direction = new FlxPoint(0, -1);
			this.move();
			
			m_state = "lookfor";
		}
		
		protected function hit() : void {
			
		}
		
		override public function attack() : void {
			
		}
		
		protected function dead() : void {
			//if (m_timerDeath.finished) {
				var newArray:Array = new Array();
				var monkey:MonkeyTest;
				
				for ( var i:int = 0; i < s_monkeys.length; i++ ) {
					monkey = s_monkeys[i];
					if ( monkey != this ) {
						if ( monkey.m_boss == this ) {
							monkey.m_boss = null;
						}
						newArray.push(monkey);
					}
				}
				s_monkeys = newArray;
								
				removeFromStage();
			//}
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
	}

}