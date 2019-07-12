/**
 * Created by Dmitry Cheremisov on 18-Dec-16.  
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.EntityCreator;
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.AxisCmp;
	import com.chrm.logigz.componets.Damper;
	import com.chrm.logigz.componets.DragCmp;
	import com.chrm.logigz.componets.DragCmp;
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.SpaceCmp;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.componets.TrainStateCmp;
	import com.chrm.logigz.def.Phis;
	import com.chrm.logigz.nodes.VagonNode;
	import com.chrm.logigz.nodes.TrainNode;
	import com.chrm.logigz.vo.CellVO;
	import com.chrm.logigz.vo.FlyVO;
	import com.chrm.logigz.vo.PlaySt;
	import com.chrm.logigz.vo.SpaceVO;
	import com.chrm.logigz.vo.StateVO;
	import com.chrm.starling.input.SlideCatcher;

	import flash.geom.Point;
	
	import net.richardlord.ash.core.Entity;

	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;

	import net.richardlord.ash.core.System;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class ControlSystem extends System
	{
		private static const log:ILogger = getLogger( ControlSystem );
		
		private var creator:EntityCreator;
		private var config : GameConfig;
		private var slideCatcher : SlideCatcher;
		private var game : LGame;
		private var trainNds : NodeList;
		
		private var touchedCell : Vector.<int>;
//		nothing:0 inittouch:1 touched:2 initmove:3 moved:4 end:5
		
		private var controlWidth : int;
		private var controlHeight : int;
		
		private var touchedTrainNode:TrainNode;
		
		public function ControlSystem()
		{
			super();
		}

		override public function addToGame( game : Game ) : void
		{
			this.game = game as LGame;
			this.slideCatcher = this.game.slideCatcher;
			this.creator = this.game.creator;
			this.config = this.game.config;
			
			trainNds = game.getNodeList( TrainNode );
			
			controlWidth = config.tileSize * config.columnsNum;
			controlHeight = config.tileSize * config.rowsNum;
			
//			offsetPoint = new Point();
		}

		
		private static function getControlState( touch : Boolean, move : Boolean, untouch : Boolean):uint
		{
			var st:int;
			if(touch)
				if(move)
					if(untouch)
						st = PlaySt.ST_UNTOUCH;
					else
						st = PlaySt.ST_TWITCH;
				else
					if(untouch)
						st = PlaySt.ST_UNTOUCH;
					else
						st = PlaySt.ST_TOUCH;
			else
				if(move)
					if(untouch)
						st = PlaySt.ST_RELEASE;
					else
						st = PlaySt.ST_DRAG;
				else
					if(untouch)
						st = PlaySt.ST_UNTOUCH;
					else
						st = PlaySt.ST_IDLE;
			return st;
		}
		
		override public function update(time : Number ):void
		{
			if(slideCatcher.isTouch || slideCatcher.isMove || slideCatcher.isUntouch)
			{
				var trainNode:TrainNode;
				var an:int;
				
				var scState:int = getControlState(slideCatcher.isTouch, slideCatcher.isMove, slideCatcher.isUntouch);
				
				switch (scState)
				{
					case PlaySt.ST_IDLE:
						log.debug("IDLE");
						if(trainNds.head)
						{
							trainNode = getHookedTrain();
							if (trainNode)
							{
								initTrainFly(trainNode, slideCatcher.movementVector);
							}
						}
						break;
					
					case PlaySt.ST_TOUCH:
						if(config.playState != PlaySt.ST_TOUCH)
						{
							if (trainNds.head)
							{
								touchedCell = getTouchedCell(config.tileSize, slideCatcher.controlPoint);
								if(touchedCell)
								{
									log.debug("TOUCH touched cell:{0}/{1}", [touchedCell[0], touchedCell[1]]);
									trainNode = getTrainNodeUnderCell(touchedCell);
									if (trainNode)
									{
										if (trainNode.train.stateVA.value != TrainCmp.ST_HOOK)
										{
											touchedTrainNode = trainNode;
											log.debug("touch on axis:{0} num:{1}", [getAxisName(trainNode.axis.axis), trainNode.axis.num]);
											initTrainDrag(trainNode, slideCatcher.controlPoint);
											trainNode.train.stateVA.value = TrainCmp.ST_HOOK;
										}
									}
								}
							}
						}
						break;
					
					case PlaySt.ST_TWITCH:
						touchedCell = getTouchedCell(config.tileSize, slideCatcher.controlPoint);
						if(touchedCell)
						{
							log.debug("TWITCH touched cell:{0}/{1}", [touchedCell[0], touchedCell[1]]);
							if (trainNds.head)
							{
								if (touchedTrainNode)
									trainNode = touchedTrainNode;
								else
									trainNode = getTrainNodeUnderCell(touchedCell);
								if (trainNode)
								{
									log.debug("twitch on axis:{0} num:{1}", [getAxisName(trainNode.axis.axis), trainNode.axis.num]);
									if (touchedTrainNode && touchedTrainNode != trainNode)
									{
										log.debug("What!?");
										log.debug("");
									}
									trainNode.train.stateVA.value = TrainCmp.ST_HOOK;
//								log.debug("train twitched");
									initTrainDrag(trainNode, slideCatcher.controlPoint);
									
									dragTrainAlongAxis(trainNode, slideCatcher.controlPoint);
								}
								else
								{
									an = getAxisNumber(slideCatcher.movementVector);
//								если твитч в параллельном направлении по первому трейн ноду
									if ((trainNds.head as TrainNode).axis.axis == an)
									{
										addTrain(game, touchedCell, an, slideCatcher.controlPoint);
										trainNode = getAddedTrainNode();
										if (trainNode)
										{
											log.debug("twitch parallel on axis:{0} num:{1}", [getAxisName(trainNode.axis.axis), trainNode.axis.num]);
											trainNode.train.stateVA.value = TrainCmp.ST_HOOK;
											initTrainDrag(trainNode, slideCatcher.controlPoint);
											dragTrainAlongAxis(trainNode, slideCatcher.controlPoint);
										}
									}
									else
									{
										log.debug("twitch perp axis");
//									ЗАПОМИНАЕМ ЭТО СОСТОЯНИЕ!
//									state = ST_PERP_TWITCH;
									}
									
								}
							}
							else
							{
								an = getAxisNumber(slideCatcher.movementVector);
								addTrain(game, touchedCell, an, slideCatcher.controlPoint);
								trainNode = getAddedTrainNode();
								if (trainNode)
								{
									log.debug("twitch added on axis:{0} num:{1}", [getAxisName(trainNode.axis.axis), trainNode.axis.num]);
									trainNode.train.stateVA.value = TrainCmp.ST_HOOK;
									initTrainDrag(trainNode, slideCatcher.controlPoint);
									dragTrainAlongAxis(trainNode, slideCatcher.controlPoint);
								}
							}
						}
						break;
					
					case PlaySt.ST_DRAG:
						if(touchedTrainNode)
							trainNode = touchedTrainNode;
						else
							trainNode = getHookedTrain();
//						log.debug("DRAG st:{0}",[trainNode.train.stateVA.value]);
						if (trainNode)
						{
							if(touchedTrainNode && scState == PlaySt.ST_TOUCH && touchedTrainNode != trainNode)
							{
								log.debug("What!?");
								logInitTrDrag(trainNode, slideCatcher.controlPoint);
								log.debug("");
							}
							if(false && scState != PlaySt.ST_DRAG)
								initTrainDrag(trainNode, slideCatcher.controlPoint);
							dragTrainAlongAxis(trainNode, slideCatcher.controlPoint);
						}
						break;
					
					case PlaySt.ST_RELEASE:
						trainNode = getHookedTrain();
						if (trainNode)
						{
							log.debug("RELEASE on:{0}, num:{1}",[getAxisName(trainNode.axis.axis), trainNode.axis.num]);
							if(touchedTrainNode && scState == PlaySt.ST_TOUCH && touchedTrainNode != trainNode)
							{
								log.debug("What!?");
								log.debug("");
							}
//							initTrainDrag(trainNode, slideCatcher.controlPoint);
//							dragTrainAlongAxis(trainNode, slideCatcher.controlPoint);
//							trainNode.train.stateVA.value = TrainCmp.ST_FLY;
							initTrainFly(trainNode, slideCatcher.movementVector);
							touchedTrainNode = null;
						}
						break;
					
					case PlaySt.ST_UNTOUCH:
						trainNode = getHookedTrain();
						if (trainNode)
						{
							log.debug("UNTOCH on:{0}, num:{1}",[getAxisName(trainNode.axis.axis), trainNode.axis.num]);
							initTrainFly(trainNode, slideCatcher.movementVector);
							touchedTrainNode = null;
						}
						break;
				}
				config.playState = scState;
			}
			touchedCell = null;
			
//			slideCatcher.resetSlideFlags();
		}
		
		private function getAxisName(axis:int):String
		{
			return (axis == 1) ? 'horz' : 'vert';
		}
		private function getTrainBy(state:int):TrainNode
		{
			var trainNode:TrainNode;
			for (trainNode = trainNds.head; trainNode; trainNode = trainNode.next)
			{
				if (trainNode.train.stateVA.value == state)
					break;
			}
			return trainNode;
		}
		private function getHookedTrain():TrainNode
		{
			var trainNode:TrainNode = getTrainBy(TrainCmp.ST_HOOK);
			return trainNode;
		}
		private function getAddedTrainNode():TrainNode
		{
			var trainNode:TrainNode;
			for (trainNode = trainNds.head; trainNode; trainNode = trainNode.next)
			{
				if (trainNode.train.stateVA.value == TrainCmp.ST_CREATED)
					break;
			}
			return trainNode;
		}
		private function getTrainNodeUnderCell(touchedCell : Vector.<int>):TrainNode
		{
			var trainNode : TrainNode;
			for (trainNode = trainNds.head; trainNode; trainNode = trainNode.next)
			{
				if (touchedCell[trainNode.axis.axis] == trainNode.axis.num)
					break;
			}
			return trainNode;
		}
		private function addTrain(game:LGame, touchedCell : Vector.<int>, axis : int, controlPoint:Point):void
		{
//			номер горизонтали или вертикали
			var num:int = touchedCell[axis];
			var saxis:String = (axis == 0 ) ? "vertical" : "horizontal";
//			log.debug("axis {0} num:{1}", [saxis, num]);
			
//			TODO:  _ Д И М А_, Б Л Я Т Ь,  Н Е  П Р О С Р И  С В О Ю  Ж И З Н Ь !
			
			var trainCmp : TrainCmp = new TrainCmp();
			
			var spaceVO:SpaceVO = new SpaceVO( 0 );
			var flyVO : FlyVO = new FlyVO( Phis.MOMENTUM_ACCEL );
			var stateVO:StateVO = new StateVO( TrainCmp.ST_CREATED );
			trainCmp.stateVA = stateVO;
			
			var cells : Vector.<CellVO>;
			if(axis == 1)
				cells = game.config.rows[num];
			else
				cells = game.config.columns[num];
			
			trainCmp.vagons = new <Entity>[];
			
			var trainEntity : Entity = creator.createTrain(
				new FlyCmp(spaceVO, flyVO),
				new AxisCmp(axis, num),
				trainCmp);
			game.addEntity(trainEntity);
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
				
				var pos : Pos = vgnEntity.get(Pos) as Pos;
				var drg : DragCmp = vgnEntity.get(DragCmp) as DragCmp;
				
				drg.offset.x = controlPoint.x - pos.x;
				drg.offset.y = controlPoint.y - pos.y;
				
				drg.controlX = controlPoint.x;
				drg.controlY = controlPoint.y;
				
				game.addEntity(vgnEntity);
				
//				vgns.push(vgnEntity.name);
			}
//			log.debug("add vgns:{0}", [vgns]);
		}
		
		private function logInitTrDrag(trainNode:TrainNode, controlPoint:Point):void
		{
			var vs : Vector.<Entity> = trainNode.train.vagons;
			
			var c:uint = vs.length;
			for(var i : int = 0; i < c; i++)
			{
				var e:Entity = vs[i];
				var drg:DragCmp = e.get(DragCmp) as DragCmp;
				
				if(trainNode.axis.axis == 1)
				{
					log.debug("offset.x:{0}", [drg.offset.x]);
					log.debug("controlX:{0}", [drg.controlX]);
				}
				else
				{
					log.debug("offset.y:{0}", [drg.offset.y]);
					log.debug("controlY:{0}", [drg.controlY]);
				}
			}
		}
		private function initTrainDrag(trainNode:TrainNode, controlPoint:Point):void
		{
			var cpx:Number = controlPoint.x;
			var cpy:Number = controlPoint.y;
			
			var vs : Vector.<Entity> = trainNode.train.vagons;
			
			var c:uint = vs.length;
			for(var i : int = 0; i < c; i++)
			{
				var e:Entity = vs[i];
				var pos : Pos = e.get(Pos) as Pos;
				var drg:DragCmp = e.get(DragCmp) as DragCmp;
				
				if(trainNode.axis.axis == 1) 
				{
					drg.offset.x = cpx - pos.x;
					drg.controlX = cpx;
				}
				else
				{
					drg.offset.y = cpy - pos.y;
					drg.controlY = cpy;
				}
			}
		}
		[Inline]
		private function dragTrainAlongAxis(trainNode:TrainNode, controlPoint:Point):void
		{
			var axisNumber:int = trainNode.axis.axis;
			var vgs : Vector.<Entity> = trainNode.train.vagons;
			var c : uint = vgs.length;
			for( var i : uint = 0; i < c; i++)
			{
				var ve : Entity = vgs[i];
				var drg : DragCmp = ve.get(DragCmp);
				var pos : Pos = ve.get(Pos);
				if(axisNumber == 1)
				{
					pos.x = controlPoint.x - drg.offset.x;
					drg.controlX = controlPoint.x;
					/*if (pos.x > config.width)
					{
						pos.x -= config.width;
						drg.offset.x = controlPoint.x - pos.x;
					}
					else if (pos.x < 0)
					{
						pos.x += config.width;
						drg.offset.x = controlPoint.x - pos.x;
					}*/
				}
				else
				{
					pos.y = controlPoint.y - drg.offset.y;
					drg.controlY = controlPoint.y;
					/*if (pos.y > config.height)
					{
						pos.y -= config.height;
						drg.offset.y = controlPoint.y - pos.y;
					}
					else if (pos.y < 0)
					{
						pos.y += config.height;
						drg.offset.y = controlPoint.y - pos.y;
					}*/
				}
			}
		}
		
		private function initTrainFly(trainNode : TrainNode, movementPoint:Point):void
		{
			if(trainNode.train.stateVA.value == TrainCmp.ST_CREATED ||
				trainNode.train.stateVA.value == TrainCmp.ST_HOOK)
			{
				var mv:Number;
				var fly:FlyVO = trainNode.fly.flyVO;
				var vg:Entity = trainNode.train.vagons[0];
				var pos:Pos = vg.get(Pos);
				if (trainNode.axis.axis == 1)
				{
					mv = movementPoint.x;
					fly.offset = pos.x;
				}
				else
				{
					mv = movementPoint.y;
					fly.offset = pos.y;
				}
				mv *= 6;
				fly.V = (Math.abs(mv) < 10) ? 20 : mv;
				
				if (movementPoint.x != 0)
					movementPoint.x = 0;
				if (movementPoint.y != 0)
					movementPoint.y = 0;
				
				trainNode.train.stateVA.value = TrainCmp.ST_INIT_FLY;
			}
		}
		
		
//		horizontal sliding number of row is 1; vertical sliding number of cow is 0; default: NO sliding is 0; 

		private static function getAxisNumber(movementPoint:Point):int
		{
			var ax : Number = Math.abs(movementPoint.x);
			var ay : Number = Math.abs(movementPoint.y);
			return ( ax > ay ) ? 1 : ( ay > ax ) ? 0 : 0;
		}

		private function getTouchedCell(tileSize : Number, controlPoint:Point):Vector.<int>
		{
			var r:Vector.<int>;
			
//			num of horizontal
			var hn:Number = getRCNum(tileSize, controlPoint.x);
//			num of vertical
			var vn:Number = getRCNum(tileSize, controlPoint.y);
			if(hn < config.columnsNum && vn < config.rowsNum)
			{
				r = new <int>[];
				r.push(hn);
				r.push(vn);
			}
			
			return r;
		}
		private static function getRCNum(tileSize : Number, value : Number) : int
		{
			return Math.floor( value / tileSize );
		}
	}
}
