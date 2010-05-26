package cas.spdr.actor 
{
	import cas.spdr.actor.MessageDialog;
	import cas.spdr.gfx.GraphicsLibrary;
	import org.flixel.*;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class LevelInfoDialog extends MessageDialog
	{		
		private var bClearing:Boolean;
		private var cntDwn:Number;
		
		private var optionsTextField:FlxText;
		
		public function LevelInfoDialog() 
		{
			super(0, 600 );			
			moveSpeed = -1500;				
			loadGraphic( GraphicsLibrary.Instance.GetSprite(GraphicsLibrary.SPRITE_MESSAGE_DIALOG_LEVELINFO), false, false, 800, 600, false);
			
			this.textField.x = 70;
			this.textField.y = 420;			
			
			this.additonalTextField.x = 100;
			this.additonalTextField.y = 500;
			
			optionsTextField = new FlxText(100, 570, 500, "Press 'UP' to start this level");				
			optionsTextField.size = 10;	
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
				
			if ( bClearing )
			{
				cntDwn -= FlxG.elapsed;
				
				if ( cntDwn <= 0 )
				{
					this.velocity.y = -moveSpeed;					
					bFinished = true;
					textField.visible = false;
					additonalTextField.visible = false;
					optionsTextField.visible = false;
				}
				else
				{
					this.velocity.y = 0;
				}
				
				if ( this.y >= 600)
				{
					bClearing = false;
					
					this.y = 600;
					this.velocity.y = 0;
				}
			}
			
			if ( bPlaying )
			{
				this.velocity.y = moveSpeed;
				
				if( this.y <= 0 )			
				{		
					bPlaying = false;
					textField.visible = true;
					additonalTextField.visible = true;
					optionsTextField.visible = true;
					
					this.y = 0;
					this.velocity.y = 0;
					
					bClearing = true;	
					cntDwn = 2;					
				}
			}	
			
			super.update();
				
		}
		
	}

}