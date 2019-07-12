/**
 * Created by Dmitry Cheremisov on 23-Nov-16.
 */
package com.chrm.starling.input
{
	import flash.geom.Point;
	import flash.geom.Point;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TapCatcher
	{
		private static const log:ILogger = getLogger(TapCatcher);

		private var stage:Stage;
		private var isMoved:Boolean;

		public var controlPoint:Point;
		public var isControlPointChanged:Boolean = false;

		public function TapCatcher(stage:Stage)
		{
			this.stage = stage;
			if(stage)
				stage.addEventListener(TouchEvent.TOUCH, stage_TOUCH);
		}

		private function stage_TOUCH(evt:TouchEvent):void
		{
//			var touch:Touch = evt.touches[0];
			var touch:Touch = evt.getTouch(stage);
			var out:Point;

			if (touch && touch.phase != TouchPhase.HOVER)
			{
				out = touch.getMovement(stage);
				if (touch.phase == TouchPhase.BEGAN)
				{
					log.debug("began {0}/{1}", [touch.globalX, touch.globalY]);
				}
				else if (touch.phase == TouchPhase.MOVED)
				{
					isMoved = true;
					log.debug("moved {0}/{1}, movement:{2}", [touch.globalX, touch.globalY, out]);
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
//					return;
					log.debug("ended {0}/{1}", [touch.globalX, touch.globalY]);
					if (isMoved)
						isMoved = false;
					else
					{
						if (controlPoint == null)
						{
							controlPoint = new Point();
						}
						controlPoint.x = Math.round(touch.globalX);
						controlPoint.y = Math.round(touch.globalY);
						isControlPointChanged = true;
						log.debug("touch {0}/{1}", [controlPoint.x, controlPoint.y]);
					}
				}
				else if(touch.phase == TouchPhase.STATIONARY)
				{
					log.debug("statio {0}/{1}", [touch.globalX, touch.globalY]);
				}
			}
		}
	}
}
