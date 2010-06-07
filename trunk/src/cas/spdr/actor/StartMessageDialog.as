﻿package cas.spdr.actor 
{
	import cas.spdr.actor.MessageDialog;
	import cas.spdr.gfx.GraphicsLibrary;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class StartMessageDialog extends MessageDialog
	{
		
		private var bClearing:Boolean;
		private var cntDwn:Number;
		
		
		public function StartMessageDialog() 
		{			
			super( 0, 0);
			moveSpeed = -2500;				
			loadGraphic( GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_MESSAGE_DIALOG_START), false, false, 800, 600, false);	
			
			textField.x = 450;
			textField.y = 450;
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
				
			if ( bClearing )
			{
				cntDwn -= FlxG.elapsed;
				
				if ( cntDwn <= 0 )
				{
					this.velocity.y = -moveSpeed;
					textField.text = "Go!";
					bFinished = true;
				}
				else
				{
					
					textField.text = Math.ceil(cntDwn).toString();// .toFixed(0);
					this.velocity.y = 0;
				}
				
				if ( this.y >= 600)
				{
					bClearing = false;
					textField.visible = false;
					additonalTextField.visible = false;
				}
			}
			
			if ( bPlaying )
			{
				this.velocity.y = moveSpeed;
				
				if( this.y >= 0 )			
				{		
					bPlaying = false;
					textField.visible = true;
					additonalTextField.visible = true;
					
					this.y = 0;
					this.velocity.y = 0;
					
					bClearing = true;	
					cntDwn = 3;					
				}
			}	
			
			super.update();
				
		}	
		
	}

}