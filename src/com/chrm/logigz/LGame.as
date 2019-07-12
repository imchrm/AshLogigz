/**
 * Created by Dmitry Cheremisov on 03-Apr-17.
 */
package com.chrm.logigz
{
	import com.chrm.logigz.componets.GameStateCmp;
	import com.chrm.logigz.systems.CleanTrainSystem;
	import com.chrm.logigz.systems.ControlSystem;
	import com.chrm.logigz.systems.CreateLevelSys;
	import com.chrm.logigz.systems.FlySys;
	import com.chrm.logigz.systems.GameManagementSystem;
	import com.chrm.logigz.systems.OrderTilesSys;
	import com.chrm.logigz.systems.ReorderCellsSys;
	import com.chrm.logigz.systems.ShuffleTilesSys;
	import com.chrm.logigz.systems.StarlingRenderSystem;
	import com.chrm.logigz.systems.SystemPriorities;
	import com.chrm.logigz.systems.TileThrowSystem;
	import com.chrm.logigz.vo.GameSt;
	import com.chrm.starling.input.SlideCatcher;
	
	import net.richardlord.ash.core.Game;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import org.as3commons.logging.simple.debug;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.assets.AssetManager;
	
	public class LGame extends Game
	{
		private static const log:ILogger = getLogger(LGame);
		
		public var rootContainer  : DisplayObjectContainer;
		public var borderContainer  : DisplayObjectContainer;
		public var creator : EntityCreator;
		public var config : GameConfig;
		public var slideCatcher : SlideCatcher;
		
		private var currentGameState:int = -1;
		
		public function LGame(container:DisplayObjectContainer, assetManager : AssetManager)
		{
			super();
			
			this.rootContainer = container;
			borderContainer = new Sprite() as DisplayObjectContainer;
			
			rootContainer.addChild(borderContainer);
			
			this.slideCatcher = new SlideCatcher(container.stage);
			this.config = new GameConfig();
			this.creator = new EntityCreator(config, this, assetManager);
			
			this.updateComplete.add( this.slideCatcher.updateComplete );
			this.updateComplete.add( gameUpdateComplete );
			
			initLevel();
		}
		protected function initLevel():void
		{
			config.gameState = GameSt.ST_INIT_LEVEL;
			gameUpdateComplete();
		}
		protected function gameUpdateComplete() : void
		{
			if(config.gameState != currentGameState)
			{
				
				log.debug("GAME STATE:{0}",[config.gameState]);
				switch (config.gameState)
				{
					case GameSt.ST_INIT_LEVEL:
						
						this.removeAllSystems();
						
						addSystem(new GameManagementSystem(), SystemPriorities.preUpdate);
						addSystem(new CreateLevelSys(), SystemPriorities.render);
						
						break;
					
					case GameSt.ST_PLAY:
						
						this.removeAllSystems();
						
						addSystem(new ShuffleTilesSys(), SystemPriorities.update);
						addSystem(new OrderTilesSys(), SystemPriorities.update);
						addSystem(new ControlSystem(), SystemPriorities.update);
						addSystem(new FlySys(), SystemPriorities.update);
						addSystem(new TileThrowSystem(), SystemPriorities.update);
						addSystem(new StarlingRenderSystem(), SystemPriorities.render);
						addSystem(new ReorderCellsSys(), SystemPriorities.end);
						addSystem(new CleanTrainSystem(), SystemPriorities.end);
						
						break;
				}
				currentGameState = config.gameState;
			}
		}
	}
}
