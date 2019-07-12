package com.chrm.starling.stuff.app.preloader
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	public class Preloader extends Sprite
	{
//		private var frameCounter:int;
		
		public function Preloader()
		{
			super();
		}
		
//		must be oevrrided by sub class
		protected function updateProgress(val:Number):void
		{
			;
		}
		
		protected function complete():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, this_ENTER_FRAME);
		}
		
		public function start():void
		{
			trace("Start loading (bytes):", root.loaderInfo.bytesTotal);
			this.addEventListener(Event.ENTER_FRAME, this_ENTER_FRAME);
		}
		
		protected function this_ENTER_FRAME(e:Event):void
		{
			if (root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
			{
				trace("Finished loading all (bytes):", root.loaderInfo.bytesTotal);
				complete();
			}
			else
			{
				var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
				updateProgress(percent);
				trace("Progress: " + (percent * 100) + " %");
			}
		}
	}
}