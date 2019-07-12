/**
 * Created by Dmitry Cheremisov on 06-Dec-16.
 *
 */
package com.chrm.logigz
{
	import com.chrm.logigz.systems.CreateLevelSys;
	import com.chrm.logigz.systems.CleanTrainSystem;
	import com.chrm.logigz.systems.ControlSystem;
	import com.chrm.logigz.systems.ReorderCellsSys;
	import com.chrm.logigz.systems.TileThrowSystem;
	import com.chrm.integration.ash.StarlingFrameTickProvider;
	import com.chrm.logigz.componets.GameStateCmp;
	import com.chrm.logigz.systems.GameManagementSystem;
	import com.chrm.logigz.systems.FlySys;
	import com.chrm.logigz.systems.StarlingRenderSystem;
	import com.chrm.logigz.systems.SystemPriorities;

	import net.richardlord.ash.core.Entity;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.core.Starling;
	
	import starling.display.DisplayObjectContainer;
	import starling.assets.AssetManager;

	public class Logigz
	{
		private static const log:ILogger = getLogger(Logigz);
		
		private var container : DisplayObjectContainer;
		
		private var assetManager : AssetManager;
		
		private var game : LGame;
		private var starling : Starling;
		
		public var tickProvider : StarlingFrameTickProvider;
		
		public function Logigz(val0 : DisplayObjectContainer, val1 : AssetManager, starling : Starling)
		{
			this.container = val0;
			this.assetManager = val1;
			this.starling = starling;
		}
		
		/**
		 * @param width
		 * @param height
		 */
		public function init(width : int, height : int):void
		{
			log.debug("w/h:{0}/{1}", [width, height]);
			prepare();
		}
		
		private function prepare():void
		{
			game = new LGame(container, assetManager);
			
			notifyReadToPlay();
		}
		
		protected function notifyReadToPlay():void
		{
			container.dispatchEventWith("readyToPlay");
		}
		
		public function start():void
		{
			tickProvider = new StarlingFrameTickProvider( starling.juggler );
			tickProvider.add( game.update );
//			tickProvider.add( playScreenTick );
			tickProvider.start();
		}
		protected function gameUpdate( time : Number ) : void
		{
			game.update( time );
		}
		private function playScreenTick( time : Number ):void
		{
			trace("update");
//			starling.nextFrame();
//			starling.render()
		}
	}
}
