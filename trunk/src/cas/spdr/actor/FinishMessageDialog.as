package cas.spdr.actor 
{
	import cas.spdr.actor.MessageDialog;
	import cas.spdr.gfx.GraphicsLibrary;
	
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class FinishMessageDialog extends MessageDialog
	{
		private var optionsTextField:FlxText;
		
		public function FinishMessageDialog() 
		{
			super(800, 0);
			moveSpeed = -2500;			
			loadGraphic( GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_MESSAGE_DIALOG), false, false, 800, 600, false);
			
			optionsTextField = new FlxText(550, 470, 500, "ESC: level select \nSPACE: retry");				
			optionsTextField.size = 15;	
			optionsTextField.scrollFactor = new Point(0, 0);
			optionsTextField.visible = false;		
		}
		
		override public function addMeToState(state:FlxState):void
		{
			super.addMeToState(state);
			state.add(optionsTextField);			
		}
		
		override public function update():void
		{		
			// performed the update AFTER it is really finished:
			if ( bFinished )
			{
				if ( onFinishCallback != null )
					onFinishCallback();
				
				bFinished = false;	
				return; 
			}
			
			if ( bPlaying )
			{
				this.velocity.x = moveSpeed;
				
				if( this.x <= 0 )			
				{		
					bPlaying = false;
					textField.visible = true;
					additonalTextField.visible = true;
					optionsTextField.visible = true;
					
					this.x = 0;
					this.velocity.x = 0;
					
					bFinished = true;
				}
			}	
				
			super.update();
		}	
		
	}

}