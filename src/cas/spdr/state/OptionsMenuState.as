package cas.spdr.state 
{
	import cas.spdr.state.PlayState;
	import cas.spdr.map.MapOptionsMenu;
	
	/**
	 * ...
	 * @author Casper van Est
	 */
	public class OptionsMenuState extends PlayState
	{
		
		public function OptionsMenuState() 
		{
			flanmap = new MapOptionsMenu();
			super();
			
		}
		
	}

}