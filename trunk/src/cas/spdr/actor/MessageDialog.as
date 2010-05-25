package cas.spdr.actor 
{	
	import org.flixel.*;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class MessageDialog extends FlxSprite
	{
		protected var bPlaying:Boolean;
		protected var bFinished:Boolean;
		
		protected var textField:FlxText;
		protected var additonalTextField:FlxText;
		
		protected var onFinishCallback:Function = null;
		
		protected var moveSpeed:Number;
		
		
		public function MessageDialog(X:int = 0, Y:int = 0)
		{
			super(X, Y, null);
			
			scrollFactor = new Point(0, 0);	
			
			textField = new FlxText(140, 300, 500, "Main Text");			
			textField.size = 25;							
			textField.scrollFactor = new Point(0, 0);
			textField.visible = false;
			
			additonalTextField = new FlxText(200, 350, 600, "Additional Text.");			
			additonalTextField.size = 15;										
			additonalTextField.scrollFactor = new Point(0, 0);
			additonalTextField.visible = false;	
		}
		
		virtual public function addMeToState(state:FlxState):void
		{
			state.add(this);
			state.add(textField);
			state.add(additonalTextField);
		}
		
		public function playMessage(message:String, additionalMessage:String = ""):void
		{
			bPlaying = true;
			textField.text = message;
			additonalTextField.text = additionalMessage;
		}
		
		public function setOnFinishCallback( callback:Function ):void
		{
			onFinishCallback = callback;
			
		}
	}

}