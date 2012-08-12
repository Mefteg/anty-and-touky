package GameObject.Trigger 
{
	import com.adobe.protocols.dict.events.ConnectedEvent;
	import GameObject.Enemy.Enemy;
	import GameObject.Enemy.FlyingCannon;
	import GameObject.Enemy.GoldenMosquito;
	import GameObject.Enemy.MechMouse;
	import GameObject.Enemy.Mosquito;
	import GameObject.Enemy.Penguin;
	import GameObject.Enemy.Snake;
	import GameObject.TriggerObject;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class TriggerEnemies extends TriggerObject
	{
		var m_enemiesToPop:Array;
		var m_type:String;
		var m_number:int = 1;
		var m_offset:FlxPoint;
		var m_direction:FlxPoint;
		var m_speed:Number;
		
		public function TriggerEnemies(object:Object) 
		{
			super(object.x, object.y, null, object.width, object.height);
			this.visible = false;
			m_type = object.properties.type;
			if(object.properties.number!=0)
				m_number = object.properties.number;
			m_direction = Utils.getDirectionPoint(object.properties.direction);
			m_speed = object.properties.speed;
			createEnemies(m_type, object.properties.location);
		}
		
		override public function update() : void {
			if (!m_active && ( collide(Global.player1) || collide(Global.player2))) {
				m_active = true;
				spawnEnemies();
			}
		}
		
		protected function spawnEnemies():void {
			for (var i:int = 0; i < m_number ; i++) {
				m_enemiesToPop[i].load();
				m_enemiesToPop[i].addToStage();
			}
		}
		
		override public function addBitmap():void {
			m_enemiesToPop[0].addBitmap();
		}
		
		override public function load():void {
			for (var i:int = 0; i < m_number ; i++)
				m_enemiesToPop[i].load();
		}
		
		protected function createEnemies(type:String, location:int ):void {
			m_enemiesToPop = new Array();
			var lastObj:Enemy;
			popFirst(type,location);
			for (var i:int = 1; i < m_number ; i++) {
				lastObj = m_enemiesToPop[i - 1];
				m_enemiesToPop.push(new s_ennemiesArrayInstantiate[type]( lastObj.x + m_offset.x, lastObj.y + m_offset.y));
				m_enemiesToPop[i].m_directionFacing = m_direction;
				if (m_speed > 0)
					m_enemiesToPop[i].m_speed = m_speed;
			}
		}
		
		protected function popFirst(type:String, location:int) : void {
			m_enemiesToPop.push(new s_ennemiesArrayInstantiate[type](0, 0));
			if (m_speed > 0)
					m_enemiesToPop[0].m_speed = m_speed;
			var obj:Enemy = m_enemiesToPop[0];
			obj.addBitmap();
			switch(location) {
				case 8: obj.place( x + m_width / 2 - obj.m_width, y + m_height / 2 - obj.m_height / 2 );
						m_offset = new FlxPoint(0, obj.m_height); break; //CENTER
				case 0: obj.place( x + m_width / 2 - obj.m_width , y ); 
						m_offset = new FlxPoint(0, -obj.m_height); break; //UP
				case 1: obj.place( x + m_width - obj.m_width , y ); 
						m_offset = new FlxPoint(obj.m_width, -obj.m_height); break;//UP RIGHT
				case 2: obj.place( x + m_width - obj.m_width , y + m_height / 2 - obj.m_height / 2 ); 
						m_offset = new FlxPoint(obj.m_width, 0); break;//RIGHT
				case 3: obj.place( x + m_width - obj.m_width , y + m_height - obj.m_height ); 
						m_offset = new FlxPoint(obj.m_width, obj.m_height); break;//DOWN RIGHT
				case 4: obj.place( x + m_width / 2 - obj.m_width , y + m_height - obj.m_height ); 
						m_offset = new FlxPoint(0, obj.m_height); break;//DOWN
				case 5: obj.place( x , y + m_height - obj.m_height ); 
						m_offset = new FlxPoint(-obj.m_width, obj.m_height);break;//DOWN LEFT
				case 6: obj.place( x , y + m_height / 2 - obj.m_height / 2 ); 
						m_offset = new FlxPoint(-obj.m_width, 0);break;//LEFT
				case 7: obj.place( x , y ); 
						m_offset = new FlxPoint(-obj.m_width, -obj.m_height);break;//UP LEFT
				default : break;
			}
			obj.m_directionFacing = m_direction;
		}
		
		///STATIC ARRAY TO CREATE ENNEMIES WITHOUT MUCH degueulasse CODE///
		public static var s_ennemiesArrayInstantiate:Object =
		{
			"mosquito" : Mosquito,
			"goldenMosquito": GoldenMosquito,
			"snake" : Snake,
			"mouse" : MechMouse,
			"flyingCannon" : FlyingCannon
		};
		
	}

}