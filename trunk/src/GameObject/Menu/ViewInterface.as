package GameObject.Menu 
{
	import org.flixel.FlxBasic;
	
	/**
	 * ...
	 * @author Tom
	 */
	public interface ViewInterface
	{		
		function update() : void ;
		
		function createButtons() : void ;
		
		function checkButton(button:MyButton) : void ;
		
		function isOver(button:MyButton) : Boolean ;
		
		function isOut(button:MyButton) : Boolean ;
		
		function isClicked(button:MyButton) : Boolean ;
	
		function print() : void ;
		
		function clear() : void ;
		
		function changeToColorOver(button:MyButton) : void ;
		
		function changeToColorOut(button:MyButton) : void ;
		
		function setInfos(_infos:Array) : void ;
		
		function setModel(model:Model) : void ;
		
		function setControler(controler:Controler) : void ;
	}

}