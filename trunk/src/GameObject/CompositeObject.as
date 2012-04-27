package GameObject 
{
	import org.flixel.FlxBasic;
	/**
	 * ...
	 * @author Tom
	 */
	public class CompositeObject extends GameObject 
	{
		protected var m_objects:Array;
		
		public function CompositeObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_objects = new Array();
		}
		
		/**
		 * Load every objects
		 */
		override public function load() : void {
			for ( var i:int = 0; i < m_objects.length; i++ ) {
				m_objects[i].load();
			}
		}
		
		/**
		 * Add every objects to the stage
		 */
		override public function addToStage():void {
			 // it needs to be added so that update() can be called
			this.addElementToStage(this);
			for ( var i:int = 0; i < m_objects.length; i++ ) {
				m_objects[i].addToStage();
			}
		}
		
		/**
		 * Add an element to the targeted stage
		 * @param	element
		 */
		public function addElementToStage(element:FlxBasic):void {
			Global.currentState.add(element);
		}
		
		/**
		 * Add an object to the composite
		 * @param	o
		 */
		public function add(o:GameObject) : void {
			o.m_parent = this;
			m_objects.push(o);
		}
		
		/**
		 * Remove an object to the composite
		 * @param	o
		 */
		public function remove(o:GameObject) : void {
			var objects:Array = new Array();
			for ( var i:int = 0; i < m_objects.length; i++ ) {
				if ( o != m_objects[i] ) {
					objects.push(m_objects[i]);
				}
				else {
					var obj:GameObject = m_objects[i] as GameObject;
					obj.removeFromStage();
				}
			}
			m_objects = objects;
		}
		
		public function clean() : void {
			for ( var i:int = 0; i < m_objects.length; i++ ) {
				var obj:GameObject = m_objects[i] as GameObject;
				obj.removeFromStage();
			}
			m_objects = new Array();
		}
		
		override public function display() : void {
			for ( var i:int = 0; i < m_objects.length; i++ ) {
				var obj:GameObject = m_objects[i] as GameObject;
				obj.display();
			}
		}
		
		override public function hide() : void {
			for ( var i:int = 0; i < m_objects.length; i++ ) {
				var obj:GameObject = m_objects[i] as GameObject;
				obj.hide();
			}			
		}
				
		public function getFirst() : GameObject {
			return m_objects[0];
		}
		
		public function isEmpty() : Boolean {
			return (m_objects.length == 0);
		}
	}

}