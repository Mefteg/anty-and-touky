package  
{
	import GameObject.GameObject;
	import GameObject.Menu.ButtonMenuItem;
	import GameObject.Menu.ButtonMenuMagic;
	import GameObject.PlayableObject;
	import GameObject.Player.Player1;
	import GameObject.Player.Player2;
	import org.flixel.FlxState;
	import Scene.Library;
	/**
	 * ...
	 * @author ...
	 */
	public class Global 
	{
		static public var currentState:State;
		static public var currentPlaystate:Playstate;
		static public var library;
		static public var soloPlayer:GameObject.PlayableObject = null;
		static public var player1:GameObject.PlayableObject = null;
		static public var player2:GameObject.PlayableObject = null;		
		static public const RIGHT:int = 1;
		static public const LEFT:int = 2;
		static public const TOP:int = 3;
		static public const BOTTOM:int = 4 ;
		static public var nb_tiles_width:int;
		static public var nb_tiles_height:int;
		static public var tile_width:int = 32;
		static public var tile_height:int = 32;
		static public var menuPlayer1:GameObject.Menu.Menu;
		static public var menuPlayer2:GameObject.Menu.Menu;
		static public var cursorPlayer1:GameObject.Menu.Cursor;
		static public var cursorPlayer2:GameObject.Menu.Cursor;
		static public var GLOBAL_ID = 0;
		static public var camera:Camera;
		static public var serverAddress:String = "http://ramboserver.dyndns.org/minority-resort/bin";
		//static public var serverAddress:String = "http://localhost/minority-resort/bin";
		static public var frozen:Boolean = false;
		static public var hasSeenControls:Boolean = false;
		static public var nbPlayers:int=1;
		
		//OPTIONS
		static public var nbLifesMax = 3;
		static public var nbContinuesMax = 3;
		
		//ELEMENTS
		public static var elementsID:Object = { "fire":0, "ice":1, "thunder":2, "water":3, "earth":4, "wind":5 };
		public static var elementsName:Array = [ "fire", "ice", "thunder","water", "earth", "wind" ];
		public static var elementsTable:Object = { "fire" : { "fire":0.5, "ice":1.5, "thunder":1, "water":0.5, "earth":1, "wind":1.5 },
													"ice" : { "fire":0.5, "ice":1, "thunder":1, "water":0.5, "earth":1.5, "wind":1 },
													"thunder" : { "fire":1, "ice":1.5, "thunder":0.5, "water":2, "earth":0, "wind":1.5 },
													"water" : { "fire":1.5, "ice":0.5, "thunder":0.5, "water":1, "earth":1.5, "wind":1 },
													"earth" : { "fire":1.5, "ice":1, "thunder":1.5, "water":0.5, "earth":0.5, "wind":1.5 },
													"wind" : { "fire":0.5, "ice":1, "thunder":1.5, "water":1, "earth":1, "wind":1 }
												};
	}

}