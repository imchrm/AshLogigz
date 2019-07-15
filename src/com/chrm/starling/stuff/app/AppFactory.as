/**
 * Created by Dmitry Cheremisov on 05-Dec-16.
 */
package com.chrm.starling.stuff.app
{
	import com.chrm.logigz.Root;
	import com.chrm.logigz.def.AppDefaults;
	import com.chrm.starling.util.screen.virtual.VIRTUAL_SCREEN;
	import com.chrm.starling.util.screen.virtual.VirtualScreenSetup;

	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.assets.AssetManager;

	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.StringUtil;

	public class AppFactory
	{
		private static const log:ILogger = getLogger(AppFactory);
		
		public static var starling:Starling;

		public static var scaleFactor:int;
		public static var assetManager:AssetManager;
		public var rootCreatedCallback:Function;

		public var assetEnqueue:Array;

		private var _progressRatioCallback:Function;

		private var nativeStage:Stage;
		private var virtualSize:Rectangle;

		public function AppFactory(nativeStage:Stage, virtualSize:Rectangle)
		{
			this.nativeStage = nativeStage;
			this.virtualSize = virtualSize;

			var screenSize:Rectangle = new Rectangle(0, 0, nativeStage.fullScreenWidth, nativeStage.fullScreenHeight);

			var viewPort:Rectangle = RectangleUtil.fit(virtualSize, screenSize, ScaleMode.SHOW_ALL);
			Starling.multitouchEnabled = true;

//			TODO: сделать механизм определения масштаба для приложения
			scaleFactor = viewPort.width < virtualSize.height ? 1 : 2; // midway between 320 and 640
			scaleFactor = 2;
			starling = new Starling(Root, nativeStage, viewPort, null, 'auto', 'auto');
			starling.stage.stageWidth    = virtualSize.width;  // <- same size on all devices!
			starling.stage.stageHeight   = virtualSize.height; // <- same size on all devices!

//			starling.enableErrorChecking = Capabilities.isDebugger;
			starling.enableErrorChecking = true;
			starling.skipUnchangedFrames = true;

			starling.showStatsAt('right', 'top', 1);

			starling.nativeOverlay.mouseChildren = starling.nativeOverlay.mouseEnabled = false;

			VIRTUAL_SCREEN.setup(new VirtualScreenSetup(nativeStage.fullScreenWidth, nativeStage.fullScreenHeight,
					virtualSize.width, virtualSize.height));
			var pbSize:Vector.<int> = VIRTUAL_SCREEN.getScreenSize(AppDefaults.PRGS_BR_FIX_WIDTH, AppDefaults.PRGS_BR_FIX_HEIGHT);
			/*
			progressBar = new ProgressBar(pbSize[0], pbSize[1]);
			progressBar.x = (nativeStage.fullScreenWidth - pbSize[0]) >> 1;
			progressBar.y = (nativeStage.fullScreenHeight - pbSize[1]) >> 1;
			this.addChild(progressBar);
			*/
			starling.addEventListener(Event.ROOT_CREATED, starling_ROOT_CREATED);
			starling.addEventListener(Event.CONTEXT3D_CREATE, starling_CONTEXT3D_CREATED);
			starling.start();
		}

		public function starling_CONTEXT3D_CREATED( evt : Event):void
		{
			if(rootCreatedCallback)
				rootCreatedCallback( evt );
		}
		public function updateProgressRatio(val:Function):void
		{
			_progressRatioCallback = val;
		}
		protected function starling_ROOT_CREATED(evt:Event):void
		{
			evt.currentTarget.removeEventListeners(evt.type);
//			if (rootCreatedCallback)
//				rootCreatedCallback();

			const appDir:File = File.applicationDirectory;

			const stuff:Array = [];
			if(assetEnqueue && assetEnqueue.length > 0)
			{
				for (var i:int = 0; i < assetEnqueue.length; i++)
				{
					stuff.push(appDir.resolvePath(StringUtil.format(assetEnqueue[i], scaleFactor)));
				}
				assetManager = new AssetManager(1);
				assetManager.verbose = true;
				assetManager.enqueue.apply(assetManager, stuff);
//				assetManager.loadQueue(assetManager_progress);
				assetManager.loadQueue(onComplete, onError, _progressRatioCallback);
			}

		}
		protected function onComplete(man:AssetManager):void
		{
			log.debug('AssetManager: Load successfully complete!');
		}
		protected function onError(err:String, man:AssetManager):void
		{
			log.error("AssetManager: {0}",[err]);
		}
		protected function assetManager_progress(val:Number):void
		{
			if(_progressRatioCallback)
				_progressRatioCallback(val);
		}


	}
}
