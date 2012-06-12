package GameObject 
{
	import flash.geom.Rectangle;
	import org.flixel.FlxCamera;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class GameObject extends FlxSprite 
	{
		
		protected var m_bufferGroup:int = DepthBuffer.s_backgroundGroup;
		public var m_typeName:String = "GameObject";
		public var m_name:String;
		public var m_width:int= 1;
		public var m_height:int= 1;
		public var m_collide:Boolean;
		//if url is not null -> the object is Drawable
		public var m_url:String;
		public var m_state:String;
		
		public var m_hitbox:Hitbox;
		
		public var m_parent:GameObject;

		public var m_shift:FlxPoint;
		
		public var m_parseObject:Object;

		public function GameObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			this.ID = Global.GLOBAL_ID;
			Global.GLOBAL_ID++;
			this.visible = false;
			m_state = "idle";
			m_collide = false;
			m_parent = this;
			m_shift = new FlxPoint();
		}
		
		public function addBitmap():void { } //useless while not drawable
		public function deleteBitmap():void { } //idem
		public function load():void {}
		
		public function setParser(parseObj:Object):void {
			m_parseObject = parseObj;
		}
		
		public function parseObject():void {
			m_parseObject.x -= 1;
		}
		
		public function getCenter() : FlxPoint {
			return new FlxPoint(this.x+m_width/2, this.y+m_height/2);
		}
		
		public function addToStage():void {
			Global.currentState.depthBuffer.addElement(this, m_bufferGroup);
		}
		
		public function removeFromStage() : void {
			Global.currentState.depthBuffer.removeElement(this, m_bufferGroup);
		}
		
		public function isBusy():Boolean { return false; }
		
		public function collide( object:GameObject ) : Boolean {	
			if (!m_hitbox || !object.m_hitbox)
				return 0;
			var myRect:Rectangle = new Rectangle(x + m_hitbox.x, y + m_hitbox.y, m_hitbox.width, m_hitbox.height);
			var otherRect:Rectangle = new Rectangle(object.x + object.m_hitbox.x, object.y + object.m_hitbox.y, object.m_hitbox.width, object.m_hitbox.height);
			if (myRect.intersects(otherRect))
				return true;
			return false;
		}
		
		public function getFacing( object:GameObject) : uint {
			
			return 0;
		}
		
		public function getNearestPlayer():GameObject.PlayableObject {
			var dist1:Number = 10000000000;
			var dist2:Number = 10000000000;
			
			var center:FlxPoint = this.getCenter();
			
			if ( Global.player1 != null ) {
				var center_p1:FlxPoint = Global.player1.getCenter();
				dist1 = Utils.distance(center_p1, center);
			}
			
			if ( Global.player2 != null ) {
				var center_p2:FlxPoint = Global.player2.getCenter();
				dist2 = Utils.distance(center_p2, center);
			}
			
			if ( dist1 <= dist2 ) {
				return Global.player1;
			}
			else {
				return Global.player2;
			}
		}
		
		public function display() : void {
			this.visible = true;
		}
		
		public function hide() : void {
			this.visible = false;
		}
		
		public function place(newX:Number, newY:Number ):void {
			x = newX; y = newY;
		}
		
		public function setHitbox(X:int, Y:int, width:int, height:int):void {			
			m_hitbox = new Hitbox(X, Y, width, height);
		}
		
		public function drawHitbox():void {
		}
		
		/**
		 * Return the facing uint value to the target
		 * @return
		 */
		public function getFacingToTarget(target:GameObject):uint {
			if (!target)
				return LEFT;
			var dir:FlxPoint = Utils.direction(new FlxPoint(x, y), new FlxPoint(target.x, target.y));
			if (Math.abs(dir.x) > 0.5) {
				if(dir.x < 0)
					facing = LEFT;
				else
					facing = RIGHT;
			}else {
				if (dir.y < 0)
					facing = DOWN;
				else
					facing = UP;
			}
				
			
			return facing;
		}
		
		override public function onScreen(Camera:FlxCamera = null) : Boolean {
			if(Camera == null)
				Camera = FlxG.camera;
				
				var xCam:int = Camera.scroll.x;
				var yCam:int = Camera.scroll.y;
				var xCamBound:int = xCam + Camera.width;
				var yCamBound:int = yCam + Camera.height;
			
				if ( this.x + this.width < xCam || this.x > xCamBound ) {
					return false;
				}
				if ( this.y + this.height < yCam || this.y > yCamBound ) {
					return false;
				}
				
				return true;
		}
		
		//COLLISION RECTANGLES FOR SIDING
		public function getLeftSideRect():Rectangle {
			return new Rectangle(x + m_hitbox.x - 1 , y + m_hitbox.y, m_hitbox.width*0.5 , m_hitbox.height);
		}
		public function getRightSideRect():Rectangle {
			return new Rectangle(x + m_hitbox.getCenter().x , y + m_hitbox.y, m_hitbox.width*0.5+1 , m_hitbox.height);
		}
		public function getTopSideRect():Rectangle {
			return new Rectangle(x + m_hitbox.x , y + m_hitbox.y - 1, m_hitbox.width , m_hitbox.height*0.5);
		}
		public function getBottomSideRect():Rectangle {
			return new Rectangle(x + m_hitbox.x , y + m_hitbox.getCenter().y, m_hitbox.width , m_hitbox.height*0.5);
		}
		//returns true if obj2 comes from the right 
		public function collideFromRight(obj2:GameObject):Boolean {
			return getRightSideRect().intersects(obj2.getLeftSideRect());
		}
		
		//returns true if obj2 comes from the left
		public function collideFromLeft( obj2:GameObject):Boolean{
			return getLeftSideRect().intersects(obj2.getRightSideRect());			
		}
		
		//returns true if obj2 comes from the bottom
		public function collideFromDown(obj2:GameObject):Boolean{
			return getBottomSideRect().intersects(obj2.getTopSideRect());
		}
		
		//returns true if obj2 comes from the top
		public function collideFromUp( obj2:GameObject):Boolean {
			return getTopSideRect().intersects(obj2.getBottomSideRect());
		}
	}

}