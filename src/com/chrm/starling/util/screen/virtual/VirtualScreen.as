/**
 * Created by Dmitry Cheremisov on 02-Nov-16.
 */
package com.chrm.starling.util.screen.virtual
{
	public class VirtualScreen
	{
		public var virtualScreenSetup:VirtualScreenSetup;

		public function VirtualScreen()
		{
		}

		public function setup(param:VirtualScreenSetup):void
		{
			virtualScreenSetup = param;
		}

		public function getScreenSize(objWidth:int, objHeight:int):Vector.<int>
		{
			if(virtualScreenSetup == null)
			{
				throw new UninitializedError("Virtual Screen doesn't initialized!");
			}
			return virtualScreenSetup.getScreenSizeFrom(objWidth, objHeight);
		}
	}
}
