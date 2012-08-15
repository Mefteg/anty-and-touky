package  
{
	import GameObject.TileObject;
	import mx.core.FlexSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxExtBitmap;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import Scene.Library;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class TilesManager extends FlxBasic 
	{
		public static var NORMAL_TILE:int = 0;
		public static var PHYSICAL_TILE:int = 1;
		public static var HOLE_TILE:int = 2;
		public static var PIPE_TILE:int = 3;
		
		// They save the frame index of each tile of the map
		public var m_tilesFrameBackground:Array;
		public var m_tilesFrameForeground:Array;
		
		// They save the type index of each tile of the map
		public var m_tilesTypeBackground:Array;
		public var m_tilesTypeForeground:Array;
		
		protected var m_mapName:String;
		protected var m_tileset:FlxExtBitmap;
		protected var m_tilesetSizeX:int;
		protected var m_tilesetSizeY:int;
		protected var m_tileStamps:Array;
		
		protected var m_bufferSize:FlxPoint;
		// They save each TileObject for the streaming
		protected var m_backgroundBuffer:Array;
		protected var m_foregroundBuffer:Array;
		
		protected var m_state:String;
		
		public function TilesManager() 
		{
			super();
			
			m_tilesFrameBackground = new Array();
			m_tilesFrameForeground = new Array();
			
			m_tileStamps = new Array();
			
			m_bufferSize = new FlxPoint(23, 18);
			m_backgroundBuffer = new Array();
			m_foregroundBuffer = new Array();
			
			m_state = "IDLE";
			
			Global.currentPlaystate.add(this);
		}
		
		override public function update() : void
		{
			switch ( m_state )
			{
				case "IDLE":
					break;
				case "LOADING":
					this.loading();
					break;
				case "LOADED":
					this.loaded();
					break;
				case "STREAM":
					this.stream();
					break;
				default:
					break;
			}
		}
		
		protected function loading() : void 
		{
			if ( Global.library.isBitmapLoaded(m_mapName) == true )
			{
				m_state = "LOADED";
			}
		}
		
		protected function loaded() : void
		{
			for ( var i:int = 0; i < m_bufferSize.y; i++ )
			{
				var str:String = "";
				for ( var j:int = 0; j < m_bufferSize.x; j++ )
				{
					var index:int = i * m_bufferSize.x + j;
					var posX:int = j * Global.tile_width;
					var posY:int = i * Global.tile_height;
					if ( m_backgroundBuffer[index] == null )
					{
						m_backgroundBuffer[index] = new TileObject(0, posX, posY, m_mapName);
						m_foregroundBuffer[index] = new TileObject(1, posX, posY, m_mapName);
					}
					else
					{
						m_backgroundBuffer[index].m_url = m_mapName;
						m_foregroundBuffer[index].m_url = m_mapName;
					}
					m_backgroundBuffer[index].addToStage();
					m_backgroundBuffer[index].load();
					m_foregroundBuffer[index].load();
					m_foregroundBuffer[index].addToStage();
				}
			}
			
			m_state = "STREAM";
		}
		
		protected function stream() : void
		{
			// get back the camera's position
			var camera:Camera = Global.camera;
			var posX:int = camera.scroll.x / Global.tile_width - 1;
			var posY:int = camera.scroll.y / Global.tile_height - 1;

			for ( var i:int = 0; i < m_bufferSize.y; i++ )
			{
				for ( var j:int = 0; j < m_bufferSize.x; j++ )
				{
					var worldPosX:Number = (posX + j) * Global.tile_width;
					var worldPosY:Number = (posY + i) * Global.tile_width;
					
					var frameIdBackground:int = m_tilesFrameBackground[(posY + i) * Global.nb_tiles_width + (posX + j)];
					m_backgroundBuffer[i * m_bufferSize.x + j].frame = frameIdBackground;
					m_backgroundBuffer[i * m_bufferSize.x + j].x = worldPosX;
					m_backgroundBuffer[i * m_bufferSize.x + j].y = worldPosY;
					
					var frameIdForeground:int = m_tilesFrameForeground[(posY + i) * Global.nb_tiles_width + (posX + j)];
					if ( frameIdForeground == -1 )
					{
						frameIdForeground = 0;
					}
					m_foregroundBuffer[i * m_bufferSize.x + j].frame = frameIdForeground;
					m_foregroundBuffer[i * m_bufferSize.x + j].x = worldPosX;
					m_foregroundBuffer[i * m_bufferSize.x + j].y = worldPosY;
				}
			}
		}
		
		public function loadTiles(_data:Object) : void
		{
			// clear old tiles' informations
			m_tilesFrameBackground = new Array();
			m_tilesFrameForeground = new Array();
			m_tilesTypeBackground = new Array();
			m_tilesTypeForeground = new Array();
			
			//load background
			this.loadLayerTiles(_data, 0, m_tilesFrameBackground, m_tilesTypeBackground);
			//load foreground
			this.loadLayerTiles(_data, 1, m_tilesFrameForeground, m_tilesTypeForeground);
			
			m_state = "LOADING";
		}
		
		protected function loadLayerTiles(_data:Object, _layer:int, _tilesFrameGroup:Array, _tilesTypeGroup:Array) : void
		{
			///LOAD THE IMAGE TILESET///
			m_mapName = _data.tilesets[0].image;
			m_mapName = m_mapName.replace(/\.\.\//g, "");
			var library:Library = Global.library;
			//check if the image has been loaded
			if (!library.getBitmap(m_mapName)) {
				//if not, add it
				library.addBitmap(m_mapName);
			}
			
			// get the map datas
			var jsonMap:Object = _data.layers[_layer];
			// get the tileset datas
			var tileset:Object = _data.tilesets[0];
			//get the tilemap order
			var data:Array = jsonMap.data;
			
			// get the number of tiles
			Global.nb_tiles_width = jsonMap.width;
			Global.nb_tiles_height = jsonMap.height;
			var width:int = jsonMap.width;
			var height:int = jsonMap.height;
			
			// get the size of tiles
			Global.tile_width = _data.tilewidth;
			Global.tile_width = _data.tileheight;

			var _tilesFrameGroup:Array;
			// for each tile
			for ( var i:int = 0; i < height; i++ ) {
				for ( var j:int = 0; j < width; j++ ) {
					// get its id
					var tileId:int = data[i * width + j]-1;
					
					// then get its type
					var type:Object = tileset.tileproperties[String(tileId)];
					
					// compute its world's position
					var pos:FlxPoint = new FlxPoint(j * Global.tile_width, i * Global.tile_height);
					
					var cpt:int = 0;
					for(var id:String in type) {
						if ( id == "type" ) {
							//create the tile
							_tilesFrameGroup.push(tileId);
							_tilesTypeGroup.push(this.convertTypeToId(type[id]));
						}
						cpt++;
					}
					// if there is no type and a tile exists
					if ( cpt == 0 ) {
						//create the tile with no type
						_tilesFrameGroup.push(tileId);
						_tilesTypeGroup.push(NORMAL_TILE);
					}
				}
			}
		}
		
		protected function convertTypeToId(_type:String) : int
		{
			var id:int = NORMAL_TILE;
			switch ( _type )
			{
				case "PhysicalTile":
					id = PHYSICAL_TILE;
					break;
				case "Hole":
					id = HOLE_TILE;
					break;
				case "Pipe":
					id = PIPE_TILE;
					break;
			}
			
			return id;
		}
		
		// _layer : Background == 0 ; Foreground == 1
		public function getTileType(_layer:int, _index:int) : int
		{
			var type:int;
			
			if ( _layer == 0 )
			{
				type = m_tilesTypeBackground[_index];
			}
			else
			{
				type = m_tilesTypeForeground[_index];
			}
			
			return type;
		}
	}

}