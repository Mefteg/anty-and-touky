package GameObject 
{
	import adobe.utils.CustomActions;
	import org.flixel.*;
	/**
	 * ...
	 * @author Tom
	 */
	public class DrawableObject extends GameObject 
	{				
		public function DrawableObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_typeName = "Drawable";
			this.visible = true;
			facing = RIGHT;
		}
		
		override public function addBitmap():void {
			Global.library.addBitmap(m_url);
		}
		
		override public function deleteBitmap():void {
			Global.library.deleteBitmap(m_url);
		}
		
		override public function load() : void{
			loadGraphic2(Global.library.getBitmap(m_url), true, false, m_width, m_height);
			if (!m_hitbox)
				setHitbox(0, 0, m_width, m_height);
		}
	}

}