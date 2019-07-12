/**
 * Created by Dmitry Cheremisov on 12-Dec-16.
 */
package com.chrm.logigz.events
{
	import starling.events.Event;

	public class GameEvent extends Event
	{
		public static const READY_TO_PLAY:String = 'READY_TO_PLAY';

		public function GameEvent(type:String, bubbles:Boolean = false, data:Object = null)
		{
			super(type, bubbles, data);
		}
	}
}
