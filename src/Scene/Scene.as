package Scene 
{
	import com.adobe.air.logging.FileTarget;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import GameObject.*;
	import GameObject.Player.Player1;
	import GameObject.Tile.Foreground;
	import org.flixel.FlxG;
	import com.adobe.serialization.json.JSON;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author ...
	 */
	public class Scene 
	{
		private var m_filename:String;
		//GameObjects of the scene
		protected var m_elements:Vector.<GameObject>;
		protected var m_tilesBackground:Array;
		protected var m_tilesForeground:Array;
		//library containing filename loaded for this scene
		public var m_library:Object;
		private var m_mapName:String;
		private var m_respawnName:String;
		
		protected var m_loaded:Boolean;
		private var myRequest:URLRequest;
		private var myLoader:URLLoader;
		public var myData:Object;
		private var m_tmpAlreadyTry:Boolean = false;
		
		public var m_music:String;
		
		public function Scene(filename:String) 
		{
			m_filename = filename.substr(0, filename.indexOf("."));
			m_elements = new Vector.<GameObject>();
			m_tilesBackground = new Array();
			m_tilesForeground = new Array();
			m_library = new Object();
			
			// we start by the tmp json
			myRequest = new URLRequest(m_filename+".json");
			myLoader = new URLLoader();
			m_loaded = false;
		}
		
		public function setRespawn(respawn:String) : void {
			m_respawnName = respawn;
		}
		
		public function load():void {
			myLoader.addEventListener(Event.COMPLETE, onload);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			myLoader.load(myRequest);
		}
		
		//the json is totally loaded
		private function onload(evt:Event):void
		{	
			myData = JSON.decode(myLoader.data);

			// load tiles in background
			loadTiles(0, m_tilesBackground);
			// load tiles in foreground
			loadTiles(1, m_tilesForeground);
			
			loadObjects();
			//all the objects are loaded
			m_loaded = true;
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }
		
		public function isLoadCOmplete():Boolean {
			return m_loaded;
		}
		
		public function getElements():Vector.<GameObject> {
			return m_elements;
		}
		
		//load and cache all the images for the objects the scene
		public function loadObjects() : void {
			//get the objects from the data
			var objects:Object = myData.layers[2].objects;
			//get number of objects
			var size:int = objects.length;
			//to store an object
			var object:Object;
			for (var i:int = 0; i < size ; i++) {
				//object is an json object
				object = objects[i];
				if ((object.type) == "Music") {
					m_music = object.properties.url;
					continue;
				}
					
				///A DRAWABLE object creation///
				//if for 2 players game but solo, continue
				if (object.properties.coop=="")
					if(Global.nbPlayers == 1)
						continue;
				//instantiate the object
				var newElement:GameObject = Converter.convertJsonObject(object);
				newElement.m_name = object.name;
				//set the parser
				newElement.setParser(object);
				var url:String = newElement.m_url;
				if(url){
					//check if the image has been loaded
					if (!Global.library.getBitmap(url)) {
						//if not, add it
						newElement.addBitmap();
					}
					//store the url in the scene library
					m_library[url] = true;
				}
				//finally, add it to the elements
				m_elements.push(newElement);
			}
		}
		
		/**
		 * Load tiles in the appropiated array
		 * @param	layer O : Background ; 1 : Foreground
		 * @param	tilesGround
		 */
		public function loadTiles(layer:int, tilesGround:Array) : void {
			///LOAD THE IMAGE TILESET///
			m_mapName = myData.tilesets[0].image;
			m_mapName = m_mapName.replace(/\.\.\//g, "");
			//check if the image has been loaded
			if (!Global.library.getBitmap(m_mapName)) {
				//if not, add it
				Global.library.addBitmap(m_mapName);
			}
			m_library[m_mapName] = true;
			
			// get the map datas
			var jsonMap:Object = myData.layers[layer];
			// get the tileset datas
			var tileset:Object = myData.tilesets[0];
			//get the tilemap order
			var data:Array = jsonMap.data;
			
			// get the number of tiles
			Global.nb_tiles_width = jsonMap.width;
			Global.nb_tiles_height = jsonMap.height;
			var width:int = jsonMap.width;
			var height:int = jsonMap.height;
			
			// get the size of tiles
			Global.tile_width = myData.tilewidth;
			Global.tile_width = myData.tileheight;

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
							var tile:GameObject.DrawableObject = Converter.convertJsonTile(layer, type[id], pos, m_mapName, tileId);
							tilesGround.push(tile);
						}
						cpt++;
					}
					// if there is no type and a tile exists
					//if ( cpt == 0 && data[i * width + j] > 0 ) {
					if ( cpt == 0 ) {
						//create the tile with no type
						var tile2:GameObject.DrawableObject = Converter.convertJsonTile(layer, "", pos, m_mapName, tileId);
						tilesGround.push(tile2); // ECRIT PAR DESSUS DU COUP !! :-/
					}
				}
			}
		}
		
		//load all the graphics of the objects
		public function loadGraphics() : void {
			//load Background
			for ( var i:int= 0; i < m_tilesBackground.length; i++ ) {
				m_tilesBackground[i].load();
				m_tilesBackground[i].addToStage();
			}
			//load Foreground
			for ( var i:int= 0; i < m_tilesForeground.length; i++ ) {
				m_tilesForeground[i].load();
				m_tilesForeground[i].addToStage();
			}
			//load objects
			for ( var j:int = 0; j < m_elements.length; j++ ) {
				//if the objects is drawable
				m_elements[j].load();
				m_elements[j].addToStage();
			}
		}
		
		//spawn players according to the last map visited
		public function spawnPlayers():void {
			//if the scene has no respawn point 
			if (!m_respawnName) {
				m_respawnName = "init";
			}
			//search for the layer RespawnPoints in the jsonmap data
			for (var i:int; i < myData.layers.length; i++ ) {
				var layer:Object = myData.layers[i];
				//when found
				if (layer.name == "RespawnPoints") {
					//search for the respawn point stored from the trigger (the actual respawn point)
					for (var j:int; j < layer.objects.length; j++ ) {
						var respawn:Object = layer.objects[j];
						//when found
						if (respawn.properties.location == m_respawnName) {
							//place players a this position
							Global.player1.x = respawn.x;
							Global.player1.y = respawn.y;
							Global.player2.x = respawn.x;
							Global.player2.y = respawn.y+Global.player1.m_hitbox.height+1;
						}
					}
				}
			}
		}
		
		//remove the elements of the scene from the current
		public function removeElementsFromStage() :void {
			for (var i:int = 0; i < m_elements.length; i++ ) {
				m_elements[i].parseObject();
				m_elements[i].removeFromStage();
			}
			
			for (var j:int = 0; j < m_tilesBackground.length; j++ ) {
				FlxG.state.remove(m_tilesBackground[j]);
			}
		}
		//return true if an image is used in the scene
		public function isInLibrary(url:String) : Boolean {
			if (m_library[url])
				return true;
			else 
				return false;
		}
		
		public function get tilesBackground():Array 
		{
			return m_tilesBackground;
		}
		
		public function get tilesForeground():Array 
		{
			return m_tilesForeground;
		}
		
		public function findObjectByType(name:String):GameObject {
			for (var i:int = 0 ; m_elements.length; i++) {
				if (m_elements[i].m_typeName == name)
					return m_elements[i];
			}
			return null;
		}
		
		public function findObjectByName(name:String):GameObject {
			for (var i:int = 0 ; m_elements.length; i++) {
				if (m_elements[i].m_name == name)
					return m_elements[i];
			}
			return null;
		}
	}

}