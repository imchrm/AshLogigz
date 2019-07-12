/**
 * Created by Dmitry Cheremisov on 03-Dec-16.
 */
package com.chrm.logigz
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class Root extends Sprite
	{
		private static const log:ILogger = getLogger(Root);
		
		public function Root()
		{
			super();

//			addEventListener(Event.ADDED_TO_STAGE, this_ADD_TO_STAGE);
			
//			addEventListener(Event.ADDED, this_ADDED);
		}
		
		private function this_ADDED(event:Event):void
		{
			log.debug("added:{0}",[event.target]);
		}

		private function this_ADD_TO_STAGE(evt:Event):void
		{
			log.debug("add to stage:{0}",[evt.target]);
//			init();
		}

		private function init():void
		{
//			logigz = new Logigz( this,  );
//			logigz.init(stage.stageWidth, stage.stageHeight);
		}
	}
}
