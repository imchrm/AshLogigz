/**
 * Created by Dmitry Cheremisov on 05-Mar-17.
 */
package com.chrm.logigz.systems
{
	public class ControlStateMachine
	{
		
		private static const PH_WAIT : int 			= 0;
		private static const PH_TOUCH : int 			= 2;
		private static const PH_DRAG : int 			= 4;
		private static const PH_SLIDE : int 			= 5;
		
		public function ControlStateMachine()
		{
			
		}
		
		public function next(state : int):void
		{
			switch(state)
			{
				case PH_WAIT :
					break;
				
				case PH_TOUCH :
					break;
				
				case PH_DRAG :
					break;
				
				case PH_SLIDE :
					break;
				
				
			}		
		}
	}
}
