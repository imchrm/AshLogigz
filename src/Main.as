package
{
	import com.chrm.logigz.Logigz;
	import com.chrm.logigz.Root;
	import com.chrm.logigz.def.AppDefaults;
	import com.chrm.starling.stuff.app.AppFactory;
	import com.chrm.starling.stuff.app.preloader.ProgressBar;
	import com.chrm.starling.util.screen.virtual.VIRTUAL_SCREEN;
	import com.chrm.starling.util.screen.virtual.VirtualScreenSetup;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.setTimeout;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;

	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	[SWF(width="320", height="480", frameRate="60", backgroundColor="#471700")]
	public class Main extends Sprite
	{
		private static const log:ILogger = getLogger(Main);

		private var progressBar:ProgressBar;

		public function Main()
		{
			if(stage)
				init();
			else
				this.addEventListener(flash.events.Event.ADDED_TO_STAGE, this_ADDED_TO_STAGE);

		}
		private function this_ADDED_TO_STAGE(event:flash.events.Event):void
		{
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, this_ADDED_TO_STAGE);

			init();
		}
		private function init():void
		{
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget( "{time} {logLevel} - {name} - {message}") );

			VIRTUAL_SCREEN.setup(new VirtualScreenSetup(stage.fullScreenWidth, stage.fullScreenHeight,
					AppDefaults.VIRTUAL_WIDTH, AppDefaults.VIRTUAL_HEIGHT));
			var pbSize:Vector.<int> = VIRTUAL_SCREEN.getScreenSize(AppDefaults.PRGS_BR_FIX_WIDTH, AppDefaults.PRGS_BR_FIX_HEIGHT);

			progressBar = new ProgressBar(pbSize[0], pbSize[1]);
			progressBar.x = (stage.fullScreenWidth - pbSize[0]) >> 1;
			progressBar.y = (stage.fullScreenHeight - pbSize[1]) >> 1;
			this.addChild(progressBar);

			var virtualSize:Rectangle = new Rectangle(0, 0, AppDefaults.VIRTUAL_WIDTH, AppDefaults.VIRTUAL_HEIGHT);

			var appFactory:AppFactory = new AppFactory(stage, virtualSize);
			appFactory.assetEnqueue = ["fonts/{0}x", "textures/{0}x"];
			appFactory.updateProgressRatio(updateRatio);
		}
		private function loadAssets():void
		{

		}
		private function updateRatio(val:Number):void
		{
			progressBar.ratio = val;

			if(val == 1)
			{
				log.debug("progress complete");
				preparationComplete();
			}
		}

		private function preparationComplete():void
		{
			System.pauseForGCIfCollectionImminent(0);
			System.gc();

			setTimeout(removeElements, 150);
//			removeElements();
		}

		private var logigz:Logigz;

		private function removeElements():void
		{
			this.removeChild(progressBar);
			progressBar = null;
			var root:Root = AppFactory.starling.root as Root;
			root.addEventListener("readyToPlay", readyToPlay);

			logigz = new Logigz( AppFactory.starling.root as DisplayObjectContainer,
				AppFactory.assetManager, AppFactory.starling );
			logigz.init(AppDefaults.VIRTUAL_WIDTH, AppDefaults.VIRTUAL_HEIGHT);

//			readyToPlay();
		}

		private function readyToPlay(evt:starling.events.Event = null):void
		{
//			AppFactory.starling.start();
//			setTimeout(logigz.start, 50);
			logigz.start();
		}
	}
}
