/**
 * Created by Dmitry Cheremisov on 18-Dec-16.
 */
package com.chrm.starling.input
{
import com.chrm.logigz.GameConfig;

import flash.geom.Point;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class SlideCatcher
	{
		private static const log:ILogger = getLogger( SlideCatcher )
		private var stage : Stage;

		public var controlPoint:Point;
		public var movementVector:Point;
		public var isTouch:Boolean = false;
		public var isUntouch:Boolean = false;
		public var isMove:Boolean = false;
		
		public function SlideCatcher(stage : Stage )
		{
			if( stage )
			{
				stage.addEventListener( TouchEvent.TOUCH, stage_TOUCH );
				this.stage = stage;
			}
			else
				throw new ArgumentError( "Stage unavailable!" );

			movementVector = new Point();
		}

		private function stage_TOUCH(evt:TouchEvent):void
		{
			var touch:Touch = evt.touches[0];
//			var out:Point;
			
			if (touch && touch.phase != TouchPhase.HOVER)
			{
				controlPoint = new Point( touch.globalX, touch.globalY - GameConfig.BORDER_TOP );
//				log.debug("--{0}", [touch.phase]);
				if (touch.phase == TouchPhase.BEGAN)
				{
//					log.debug("BEGAN");
//					if(isMove) isMove = false;
//					if(isUntouch) isUntouch = false;
					if(!isTouch)
						isTouch = true;
				}
				else if (touch.phase == TouchPhase.MOVED)
				{
//					log.debug("MOVED");
					if(!isMove)
						isMove = true;
					
					movementVector = touch.getMovement(stage);
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					isUntouch = true;
				}
			}
		}
		public function updateComplete():void
		{
			resetSlideFlags();
		}
		public function resetSlideFlags():void
		{
			if(isTouch && isMove)
				isTouch = false;
			if(isMove)
				isMove = false;
			if(isUntouch)
			{
				if(isTouch)
					isTouch = false;
				isUntouch = false;
			}
		}
	}
}
