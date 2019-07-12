/**
 * Created by Dmitry Cheremisov on 03-May-17.
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.EntityCreator;
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.AxisCmp;
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.SpaceCmp;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.componets.TrainStateCmp;
	import com.chrm.logigz.def.AppDefaults;
	import com.chrm.logigz.def.Phis;
	import com.chrm.logigz.nodes.TrainNode;
	import com.chrm.logigz.screens.util.GUIFactory;
	import com.chrm.logigz.vo.CellVO;
	import com.chrm.logigz.vo.FlyVO;
	import com.chrm.logigz.vo.SpaceVO;
	import com.chrm.logigz.vo.StateVO;
	import com.chrm.starling.display.util.StarlingDisplayObjectConverter;
	import com.chrm.util.math.random.getRndIntN;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ShuffleTilesSys extends System
	{
		private static const log:ILogger = getLogger(ShuffleTilesSys);
		
		private var game:LGame;
		private var config:GameConfig;
		private var creator:EntityCreator;
		
		private var container:DisplayObjectContainer;
		private var rootContainer:DisplayObjectContainer;
		
		private var shuffleBut:Button = createSimpleBut();
		private var trainNodes:NodeList;
		
		public function ShuffleTilesSys()
		{
			super();
		}
		override public function addToGame( game : Game ):void
		{
			trainNodes = game.getNodeList(TrainNode);
			
			this.game = game as LGame;
			this.config = this.game.config;
			this.creator = this.game.creator;
			this.container = this.game.borderContainer;
			this.rootContainer = this.game.rootContainer;
			
			shuffleBut = GUIFactory.createSimpleBut();
			shuffleBut.x = 0;
			shuffleBut.y = AppDefaults.VIRTUAL_HEIGHT - GUIFactory.CTRL_INDENT - shuffleBut.height;
			this.rootContainer.addChild(shuffleBut);
			shuffleBut.addEventListener(Event.TRIGGERED, testBut_TRIGGERED);
			
		}
		override public function removeFromGame(game:Game):void
		{
//			shuffleBut.removeEventListener(Event.TRIGGERED, testBut_TRIGGERED);
//			this.rootContainer.removeChild(shuffleBut);
		}
		
		private var isStartShuffle : Boolean = false;
		
		private var axisChangeCounter:int;
		private var axisCurrent : int;
		
		protected function testBut_TRIGGERED(evt:Event):void
		{
			isStartShuffle = true;
			shuffleBut.enabled = false;
			
			startAxisShuffle();
		}
		
		private function startAxisShuffle():void
		{
			axisCurrent = 1;
			axisChangeCounter = 4;
			addTrainAgain();
		}
		override public function update(time : Number ):void
		{
			if(!trainNodes.head && isStartShuffle)
			{
				addTrainAgain();
			}
		}
		
		private function addTrainAgain():void
		{
			if(axisChangeCounter > 0)
			{
				var c:uint = config.columnsNum;
				for(var i:uint=0; i < c; i++)
				{
					addTrain(this.game, axisCurrent, i);
					
				}
				var s:int = getRndSign();
				var trainNode : TrainNode;
				for (trainNode = trainNodes.head; trainNode; trainNode = trainNode.next)
				{
					var sp:int;
					
					sp = getRndIntN((axisCurrent == 1)? config.rowsNum >> 1 : config.columnsNum >> 1);
					
					
					initTrainAutoShift(trainNode, getRndSign(), config.tileSize * sp, 1);
				}
				
				axisCurrent = (axisCurrent == 0) ? 1 : 0;
				axisChangeCounter--;
			}
			else
			{
				isStartShuffle = false;
				shuffleBut.enabled = !isStartShuffle;
				
			}
		}
		private function addTrain(lGame:LGame, axis : int, num:int):void
		{
			var saxis:String = (axis == 0 ) ? "vertical" : "horizontal";
//			log.debug("axis {0} num:{1}", [saxis, num]);

//			TODO:  _ Д И М А_, Б Л Я Т Ь,  Н Е  П Р О С Р И  С В О Ю  Ж И З Н Ь !
			
			var trainCmp : TrainCmp = new TrainCmp();
			
			var spaceVO:SpaceVO = new SpaceVO( 0 );
			var flyVO : FlyVO = new FlyVO( Phis.MOMENTUM_ACCEL * 4 );
			var stateVO:StateVO = new StateVO( TrainCmp.ST_CREATED );
			trainCmp.stateVA = stateVO;
			
			var cells : Vector.<CellVO>;
			if(axis == 1)
				cells = lGame.config.rows[num];
			else
				cells = lGame.config.columns[num];
			
			trainCmp.vagons = new <Entity>[];
			
			var trainEntity : Entity = creator.createTrain(
				new FlyCmp(spaceVO, flyVO),
				new AxisCmp(axis, num),
				trainCmp);
			lGame.addEntity(trainEntity);
//			var vgns:Array = [];
			var l:int = cells.length;
			for (var j:int = 0; j < l; j++)
			{
				var vgnEntity:Entity = cells[j].e;
				var spcCmp:SpaceCmp = vgnEntity.get(SpaceCmp) as SpaceCmp;
				spcCmp.spaceVA = spaceVO;
				var trStCmp : TrainStateCmp = vgnEntity.get(TrainStateCmp) as TrainStateCmp;
				trStCmp.stateVA = stateVO;
				trainCmp.vagons.push(vgnEntity);
				
				lGame.addEntity(vgnEntity);

			}
		}
		private function initTrainAutoShift(trainNode : TrainNode, sign:int, space:int, time:int):void
		{
			if(trainNode.train.stateVA.value == TrainCmp.ST_CREATED)
			{
				var fly:FlyVO = trainNode.fly.flyVO;

//				init Fly System
				fly.sign = sign;
				fly.S = space;
				fly.T = time;
				
				trainNode.train.stateVA.value = TrainCmp.ST_FLY;
			}
		}
		/**
		 *  return random integer from 1:N diapason
		 *  
		 */
		/*private function getRndIntN( N : int ):int
		{
			return Math.round( Math.random() * (N - 1) + 1 );
		}*/
		/**
		 *  return random integer from 1:N diapason
		 *
		 */
		private function getRndSign():int
		{
			return Math.round(Math.random()) * 2 - 1;
		}
		public function createSimpleBut():Button
		{
			var tu:Texture = createButTexture(true);
//			var td:Texture = createButTexture(false);
			var b:Button = new Button(tu);
			
			return b;
		}
		private function createButTexture(isUp:Boolean=true):Texture
		{
			var fsprt:Sprite = drawFlashButSprite(isUp);
			var txtr:Texture = StarlingDisplayObjectConverter.convertFlashDisplayObjectToTexture( fsprt );
			return txtr;
		}
		private function drawFlashButSprite(isUp:Boolean=true, width:uint=160, height:uint=50):Sprite
		{
			var dt:uint = 2;
			var ddt:uint = dt << 1;
			
			var fsprt:Sprite = new Sprite();
			var g:Graphics = fsprt.graphics;
			g.beginFill(0x000000);
			g.drawRect(0,0, width, height);
			g.endFill();
			g.beginFill(isUp ? 0xffab33 : 0x8d4300);
			g.drawRect(dt,dt, width - ddt, height - ddt);
			g.endFill();
			
			return fsprt;
		}
	}
}
