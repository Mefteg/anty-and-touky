package GameObject 
{
	import flash.sampler.NewObjectSample;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Tom
	 */
	public class PhysicalObject extends MovableObject 
	{
		public var m_stats:GameObject.Stats;
		public var m_canGoThrough:Boolean = false;
		public var m_weight:int = 10;
		public var m_pushed:Boolean = false;
		
		public function PhysicalObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_collide = true;
		}
		
		override public function update() : void {
			super.update();
			
			m_canGoThrough = true;
		}
				
		override public function move() : void {
			m_canGoThrough = true;
			super.move();
			
			this.collideWithEnv();
			
			//it's useless to detect a collision if an object is not moving at all
			/*if (m_canGoThrough || (m_direction.x == 0 && m_direction.y == 0))
				return;*/
			
			// if the new position involves an environment collision
			if ( !m_canGoThrough ) {
				// keep the current position
				this.x = m_oldPos.x;
				this.y = m_oldPos.y;
			}
		}
		
		/**
		 * Compute the collision with the environment
		 * @return true if the object is colliding with the environment
		 */
		public function collideWithEnv() : Boolean {
			var collide:Boolean = false;
			
			// if the scene has been loaded
			if ( Global.currentPlaystate.sceneManager.isLoadComplete() ) {
				var tiles:Array = new Array();
				
				// get the top left corner of the object
				var topleft:FlxPoint = new FlxPoint(this.x, this.y);
				// get the bottom right corner of the object
				var bottomright:FlxPoint = new FlxPoint(this.x + m_width, this.y + m_height);
				
				// convert them for the grid
				var topleftToGrid:FlxPoint = new FlxPoint(int(topleft.x/Global.tile_width), int(topleft.y/Global.tile_height));
				var bottomrightToGrid:FlxPoint = new FlxPoint(int(bottomright.x / Global.tile_width), int(bottomright.y / Global.tile_height));
				
				// for each tile under the object
				for ( var i:int = topleftToGrid.x; i <= bottomrightToGrid.x; i++ ) {
					for ( var j:int = topleftToGrid.y; j <= bottomrightToGrid.y; j++ ) {
						var index:uint = j * Global.nb_tiles_width + i;
						var env:Array = Global.currentPlaystate.getCurrentScene().tiles;
						var tile:GameObject.TileObject = env[index];
						tiles.push(tile);
						
						tile.action(this);
						// if the tile is physical
						/*if ( tile.m_collide == true ) {
							// METTRE LE TEST DU TYPE ICI OU DANS l'HERITAGE DE PLAYABLEOBJECT
							collide = true;
						}*/
					}
				}
			}
			
			return collide;
		}
	}

}