package cas.spdr.actor 
{
	import cas.spdr.state.LevelState;
	import org.flixel.*;
	import cas.spdr.gfx.GraphicsLibrary;
	import org.flixel.FlxText;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class MessageDialog extends FlxSprite
	{
		private var bPlaying:Boolean;
		private var bFinished:Boolean;
		//public var message:String;
		public var textField:FlxText;
		public var additonalTextField:FlxText;
		public var optionsTextField:FlxText;
		
		public function MessageDialog(X:int = 0, Y:int = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			
			loadGraphic( GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_MESSAGE_DIALOG), false, false, 800, 600, false);
			//this.alpha = 0.5;
			
			textField = new FlxText(140, 300, 500, "Congratulations!");			
			textField.size = 25;							
			textField.scrollFactor = new Point(0, 0);
			textField.visible = false;
			
			additonalTextField = new FlxText(200, 350, 600, "Additional text..");			
			additonalTextField.size = 15;										
			additonalTextField.scrollFactor = new Point(0, 0);
			additonalTextField.visible = false;
			
			optionsTextField = new FlxText(550, 500, 500, "ESC: return to menu \nSPACE: restart");				
			optionsTextField.size = 10;	
			optionsTextField.scrollFactor = new Point(0, 0);
			optionsTextField.visible = false;			
		}
		
		public function addMeToState(state:FlxState):void
		{
			state.add(this);
			state.add(textField);
			state.add(additonalTextField);
			state.add(optionsTextField);
			
		}
		
		public function playMessage(message:String, additionalMessage:String = ""):void
		{
			bPlaying = true;
			textField.text = message;
			additonalTextField.text = additionalMessage;
			
		}
		
		override public function update():void
		{		
			// performed the update AFTER it is really finished:
			if ( bFinished )
			{
				(FlxG.state as LevelState).EndLevel();
				bFinished = false;
			}
				
			if ( bPlaying && this.x <= 0 )
			{				
				bPlaying = false;
				textField.visible = true;
				additonalTextField.visible = true;
				optionsTextField.visible = true;
				super.update();
				this.x = 0;
				bFinished = true;
			}
			
			if ( !bPlaying )
				return;
			
			this.acceleration.x = -5000;							
			super.update();
		}		
	}

}