/**
 * Created by Dmitry Cheremisov on 15-Nov-16. 
 */
package com.chrm.integration.ash
{
	import net.richardlord.signals.Signal1;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;


	public class StarlingFrameTickProvider extends Signal1 implements IAnimatable
	{
		private static const log:ILogger = getLogger(StarlingFrameTickProvider);
		private var juggler:Juggler;

		public function StarlingFrameTickProvider(juggler:Juggler)
		{
			super( Number );
			this.juggler = juggler;
		}

		public function start():void
		{
			juggler.add(this);

		}

		public function stop():void
		{
			juggler.remove(this);
		}

		public function advanceTime(time:Number):void
		{
//			log.debug("advanceTime:{0}", [time]);
			dispatch( time );
		}
	}
}
