/**
 * Created by Dmitry Cheremisov on 31-May-17.
 */
package com.chrm.logigz.mvc.controllers
{
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.mvc.MessagePipe;
	import com.chrm.logigz.mvc.messages.Message;
	import com.chrm.logigz.screens.util.GUIFactory;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class Menu
	{
		private static const log:ILogger = getLogger(Menu);
		
		private var pipe:MessagePipe;
		private var container:DisplayObjectContainer;
		private var config:GameConfig;
		
		public function Menu(pipe:MessagePipe, container:DisplayObjectContainer, config:GameConfig)
		{
			this.pipe = pipe;
			this.container = container;
			this.config = config;
			this.pipe.addEventListener(Message.BROADCAST, pipe_BROADCAST);
			
			if(container.stage)
				init();
			else
				container.addEventListener(Event.ADDED_TO_STAGE, container_ADDED_TO_STAGE);
				
		}
		
		private function container_ADDED_TO_STAGE(event:Event):void
		{
			event.target.removeEventListener(Event.ADDED_TO_STAGE, container_ADDED_TO_STAGE);
			init();
		}
		
		private function init():void
		{
			var l:Array = ["Play", "Score", "Help"];
			for(var i:uint = 0; i < l.length; i++)
			{
				GUIFactory.createSimpleBut();
			}
		}
		
		private function sendMessage(payload:Object ):void
		{
			pipe.dispatchEventWith(MessagePipe.BROADCAST, false, payload);
		}
		
		private function pipe_BROADCAST(evt:Message):void
		{
			;
		}
	}
}
