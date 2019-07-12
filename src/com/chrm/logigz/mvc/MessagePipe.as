/**
 * Created by Dmitry Cheremisov on 31-May-17.
 */
package com.chrm.logigz.mvc
{
	import starling.animation.Juggler;
	import starling.animation.Tween;
	import starling.events.EventDispatcher;
	
	public class MessagePipe extends EventDispatcher
	{
		public static const BROADCAST : String = "BROADCAST";
		
		public function MessagePipe()
		{
			new Juggler().add(new Tween(this, 10));
		}
	}
}
