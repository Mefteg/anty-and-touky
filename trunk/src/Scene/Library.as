package Scene 
{
	import org.flixel.*;
	import org.flixel.FlxExtBitmap;
	/**
	 * ...
	 * @author ...
	 */
	public class Library 
	{
		//array of Bitmap indexed by name of the image
		protected var m_library:Object;
		//Array of Bitmap that should not be deleted at each scene
		protected var m_libraryUnique:Object;
		
		protected var name:String;
		//current index for loading
		private var m_currentIndex:int;
		private var m_state:String;
		//to store the names of files to load
		private var m_libNames:Array;
		private var m_libUniNames:Array;
		
		//for loading advancement
		private var m_loadStep:Number;
		private var m_loadAdvancement:Number;
		private var m_loadComplete:Boolean;
		
		
		public function Library() 
		{
			m_library = new Object;
			m_libraryUnique = new Object;
			m_libNames = new Array();
			m_libUniNames = new Array();
			m_loadComplete = false;
			m_state = "Waiting";
			m_loadAdvancement = 0;
		}
		
		public function getLibrary():Object {
			return m_library;
		}
		
		public function addBitmap(filename:String) : void {
			if(m_library[filename]!=null)
				return;
			m_state = "Waiting";
			m_library[filename] = new FlxExtBitmap(filename);
			m_libNames.push(filename);
		}
		
		public function addUniqueBitmap(filename:String) : void {
			if(m_libraryUnique[filename]!=null)
				return;
			m_state = "Waiting";
			m_libraryUnique[filename] = new FlxExtBitmap(filename);
			m_libUniNames.push(filename);
		}
		
		public function loadAll():void {
			switch(m_state){
				case "Waiting" : m_currentIndex = 0;
								m_loadAdvancement = 0;
								//check if there's something to load
								if (m_libNames.length + m_libUniNames.length > 0) {
									//compute step
									m_loadStep = 100 / (m_libNames.length + m_libUniNames.length);
									//if there are simple bitmaps to load
									if(m_libNames.length > 0){
										//load first bitmap
										m_library[m_libNames[m_currentIndex]].load();
										m_state = "LoadBitmaps";
									}else {
										//if there are uniques to load
										if (m_libUniNames.length > 0){
											m_libraryUnique[m_libUniNames[m_currentIndex]].load();
											m_state = "LoadUniques";
										}else{
											m_state = "Loaded";
										}
									}
								}else{
									m_state = "Loaded";
								}
								break;
				case "LoadBitmaps": if(m_library[m_libNames[m_currentIndex]].loadComplete()) {
										m_currentIndex++;
										m_loadAdvancement += m_loadStep;
										//if all the bitmaps have been loaded
										if(m_currentIndex >= m_libNames.length){
											m_currentIndex = 0;
											//if there are uniques to load
											if(m_libUniNames.length>0){
												m_state = "LoadUniques";
												m_libraryUnique[m_libUniNames[m_currentIndex]].load();
											}else{
												m_state = "Loaded";
											}
										}else{
											m_library[m_libNames[m_currentIndex]].load();
										}
									}
									break;
				case "LoadUniques" : if(m_libraryUnique[m_libUniNames[m_currentIndex]].loadComplete()){
										m_currentIndex++;
										m_loadAdvancement += m_loadStep;
										//if all the bitmaps have been loaded
										if(m_currentIndex >= m_libUniNames.length){
											m_currentIndex = 0;
											m_state = "Loaded";
										}else{
											m_libraryUnique[m_libUniNames[m_currentIndex]].load();
										}
									}
									break;
				default : break;
			}
		}
		
		public function deleteBitmap(filename:String) : void {
			m_libNames[filename] = null;
			delete m_libNames[filename];
			m_library[filename] = null;
			delete m_library[filename];
		}
		
		public function deleteUniqueBitmap(filename:String) : void {
			m_libUniNames[filename] = null;
			delete m_libUniNames[filename];
			m_libraryUnique[filename] = null;
			delete m_libraryUnique[filename];
			
		}
		
		//returns true if all the images are loaded
		public function loadComplete() : Boolean{
			return m_state == "Loaded";
		}
		//load Bitmaps in the cache
		public function cacheObjects() : void {
			if(m_libNames.length > 0){
				for ( var i:int = 0; i < m_libNames.length; i++ ) {
					FlxG.addBitmapFromObject(m_library[m_libNames[i]]);
				}
				//clear names to avoid reloading them
				m_libNames.length = 0;
			}
			if(m_libUniNames.length > 0){
				for ( var j:int = 0; j < m_libUniNames.length; j++ ) {
					FlxG.addBitmapFromObject(m_libraryUnique[m_libUniNames[j]]);
				}
				m_libUniNames.length = 0;
			}
			m_state = "Waiting";
		}
		//returns the cached bitmap if it exists, null otherwise
		public function getBitmap(filename:String) : FlxExtBitmap {
			if(m_library[filename])
				return m_library[filename];
			if (m_libraryUnique[filename])
				return m_libraryUnique[filename];
			return null;
		}
		
		public function isBitmapLoaded(filename:String):Boolean {
			if(m_library[filename])
				return m_library[filename].loadComplete();
			if (m_libraryUnique[filename])
				return m_libraryUnique[filename].loadComplete();
			return false;
		}
		
		public function getAdvancement():Number {
			return m_loadAdvancement;
		}
		
		public function print():void {
			trace("\n====PRINT LIBRARY=======");
			for ( name in m_library) {
				trace(name, m_library[name]);
			}
		}
		
		public function ToString():String{
			var str:String = "";
			for(name in m_library){				
				str += name;
				str += "    ";
				str += m_library[name].loadComplete();
				str += "    ";
				str += m_library[name].getAdvancementInPercent();
				str += "\n";
			}
			for(name in m_libraryUnique){				
				str += name;
				str += "    ";
				str += m_libraryUnique[name].loadComplete();
				str += "    ";
				str += m_libraryUnique[name].getAdvancementInPercent();
				str += "\n";
			}
			return str;
		}
		
		public function getCurrentLoaded():String {
			if (m_state == "LoadBitmaps") {
				return m_libNames[m_currentIndex] + "  " +m_library[m_libNames[m_currentIndex]].getAdvancementInPercent();
			}else if (m_state == "LoadUniques") {
				return m_libUniNames[m_currentIndex] + "  " +m_libraryUnique[m_libUniNames[m_currentIndex]].getAdvancementInPercent();;
			}
			return " NaN ";
		}
				
	}

}