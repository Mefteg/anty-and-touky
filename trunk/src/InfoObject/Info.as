package InfoObject 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author ...
	 */
	public class Info extends FlxText
	{
		
		public function Info(X:Number = 0, Y:Number = 0,text:String= null,Width:uint = 20)
		{
			super(X,Y ,Width,text);
		}
		
		public function addToStage():void {
			Global.currentState.depthBuffer.addMenu(this);
		}
		
		public function removeFromStage():void {
			Global.currentState.depthBuffer.removeMenu(this);
		}
		
	}

}