package Scene 
{
	import flash.geom.Rectangle;
	import GameObject.PhysicalObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class CollisionManager extends FlxBasic
	{
		public var m_physicalObjects:Vector.<PhysicalObject>;
		
		private var m_length:int;
		
		private var m_currentObject:PhysicalObject;
		private var m_currentOther:PhysicalObject;
		
		public function CollisionManager() 
		{
			m_physicalObjects = new Vector.<PhysicalObject>();
			visible = false;
		}
		
		public function addObject(object:PhysicalObject) : void {
			m_physicalObjects.push(object);
		}
		
		public function removeObject(object:PhysicalObject) : void {
			var i:int = m_physicalObjects.indexOf(object);
			if (i < 0)
				return;
			m_physicalObjects.splice(i, 1);
		}
		
		override public function postUpdate():void {
			m_length = m_physicalObjects.length;
			for (var i:int = 0; i < m_length ; i++) {
				m_currentObject = m_physicalObjects[i];
				//if the object does not collide, do not go further
				if (!m_currentObject.m_collideWithObjects)
					continue;
				for (var j:int = i+1; j < m_length; j++) {
					m_currentOther = m_physicalObjects[j];
					if (m_currentObject.m_typeName == "Player" && m_currentOther.m_typeName == "Player")
						continue;
					collide();
				}
			}
		}
		
		public function collide():void {
			//if collision is activated for both objects
			if (!m_currentOther.m_collideWithObjects)
				return;
			//if real collision between the two of 'em
			if (m_currentObject.collide(m_currentOther)) {
				//in the case the player1 is rushing
				if (m_currentObject.m_name == "Player1" && m_currentOther.m_typeName != "Breakable")
					Global.player1.unspecial();
				//if the same weight, replace both
				if (m_currentObject.m_weight == m_currentOther.m_weight) {
					repulseBoth();
				//if the currentObject is heavier than the other
				}else if (m_currentObject.m_weight > m_currentOther.m_weight) {
					//processCollisions(m_currentObject, m_currentOther)
					repulseObject(m_currentOther);
				//otherwise
				}else if (m_currentObject.m_weight < m_currentOther.m_weight) {
					repulseObject(m_currentObject);
					//processCollisions(m_currentOther, m_currentObject);
				}
			}
		}
		
		private function processCollisions(superior:PhysicalObject, inferior:PhysicalObject) : void {
			//if no force from the pusher, do nothing
			if (superior.m_direction.x == 0 && superior.m_direction.y == 0) {
				repulseObject(inferior);
				return;
			}
			
			/*if ( superior.m_direction.x > 0 && inferior.collideFromLeft(superior)){
				pushRight(superior, inferior);
			}else if (superior.m_direction.x < 0 && inferior.collideFromRight(superior)) {
				pushLeft(superior, inferior);
			}else if ( superior.m_direction.y < 0 && inferior.collideFromDown(superior) ) {
				pushUp(superior, inferior);
			}else if ( superior.m_direction.y> 0  && inferior.collideFromUp(superior)){
				pushDown(superior, inferior);
			}else {
				repulseObject(inferior);
			}*/
		}
		
		private function repulseBoth():void {
			if (m_currentObject.m_typeName == "Breakable" && m_currentOther.m_typeName == "Breakable")
				return;
			//on rush repulse only one player to avoid any bug
			//when player 1 is rushing, check if it's a collision between player 2 and breakable
			if (Global.player1.isRushing()) {
				if ( (m_currentObject.m_typeName == "Breakable" || m_currentOther.m_typeName == "Breakable") &&
						(m_currentObject.m_name == "Player2" || m_currentOther.m_name == "Player2") ) {
							return;
				}
				
			}
			//if the X directions are not the same
			if (m_currentObject.m_direction.x * m_currentOther.m_direction.x <= 0) {
				if(m_currentObject.m_direction.x != 0)
					m_currentObject.x = m_currentObject.m_oldPos.x;
				if (m_currentOther.m_direction.x != 0)
					m_currentOther.x = m_currentOther.m_oldPos.x;
			}
			if(m_currentObject.m_direction.y * m_currentOther.m_direction.y <= 0){
				m_currentObject.y = m_currentObject.m_oldPos.y;
				m_currentOther.y = m_currentOther.m_oldPos.y;
			}
		}
		
		private function repulseObject(obj:PhysicalObject) : void {
			obj.x = obj.m_oldPos.x;
			obj.y = obj.m_oldPos.y;
		}
		
		private function pushRight(pusher:PhysicalObject, bePushed:PhysicalObject):void {
			if (pusher.m_direction.y != 0) {
				repulseBoth();
				return;
			}

			bePushed.m_direction = pusher.m_direction ;
			bePushed.move();
		}
		
		private function pushLeft(pusher:PhysicalObject, bePushed:PhysicalObject):void {
			if (pusher.m_direction.y != 0) {
				repulseBoth();
				return;
			}
			bePushed.m_direction = pusher.m_direction ;
			bePushed.move();
		}
		
		private function pushUp(pusher:PhysicalObject,bePushed:PhysicalObject):void {
			if (pusher.m_direction.x != 0) {
				repulseBoth();
				return;
			}
			bePushed.m_direction = pusher.m_direction ;
			bePushed.move();
		}
		
		private function pushDown(pusher:PhysicalObject,bePushed:PhysicalObject):void {
			if (pusher.m_direction.x != 0) {
				repulseBoth();
				return;
			}
			bePushed.m_direction = pusher.m_direction;
			bePushed.move();
		}		
	}

}