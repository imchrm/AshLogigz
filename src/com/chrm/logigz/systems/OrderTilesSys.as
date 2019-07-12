/**
 * Created by Dmitry Cheremisov on 11-May-17.
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.EntityCreator;
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.FlightCmp;
	import com.chrm.logigz.componets.DPos;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.Tile;
	import com.chrm.logigz.def.AppDefaults;
	import com.chrm.logigz.nodes.FlightToOrderPosNode;
	import com.chrm.logigz.screens.util.GUIFactory;
	import com.chrm.logigz.vo.CellVO;
	import com.chrm.util.math.ease.easeInOutCubic;
	import com.chrm.util.math.ease.easeOutCubic;
	import com.chrm.util.math.getIntSign;
	
	import net.richardlord.ash.core.Entity;
	
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	
	import net.richardlord.ash.core.System;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.display.Button;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class OrderTilesSys extends System
	{
		private static const log:ILogger = getLogger(OrderTilesSys);
		
		private var game:LGame;
		private var config:GameConfig;
		private var creator:EntityCreator;
		
		private var container:DisplayObjectContainer;
		private var rootContainer:DisplayObjectContainer;
		
		private var ctrlBut:Button;
		private var isInit:Boolean = false;
		
		private static var st : uint = 0;
		private static const ST_INIT:uint = st++;
		private var state : uint;
		private var flightNodes:NodeList;
		
		public function OrderTilesSys()
		{
			super();
		}
		
		override public function addToGame(game:Game):void
		{
			flightNodes = game.getNodeList(FlightToOrderPosNode);
			
			this.game = game as LGame;
			this.config = this.game.config;
			this.creator = this.game.creator;
			this.container = this.game.borderContainer;
			this.rootContainer = this.game.rootContainer;
			
			ctrlBut = GUIFactory.createSimpleBut();
			ctrlBut.x = AppDefaults.VIRTUAL_WIDTH - ctrlBut.width;
			ctrlBut.y = AppDefaults.VIRTUAL_HEIGHT - GUIFactory.CTRL_INDENT - ctrlBut.height;
			this.rootContainer.addChild(ctrlBut);
			ctrlBut.addEventListener(TouchEvent.TOUCH, ctrlBut_TOUCH);
		}
		
		private function ctrlBut_TOUCH(event:TouchEvent):void
		{
			var tch:Touch = event.touches[0];
			var flNode:FlightToOrderPosNode;
			if(tch.phase == TouchPhase.BEGAN )
			{
				if(flightNodes.head == null)
					addOrderedTilesToGame();
				else
				{
					for (flNode = flightNodes.head; flNode; flNode = flNode.next)
					{
						flNode.flight.state = FlightCmp.ST_INIT_IN;
					}
				}
			}
			else if(tch.phase == TouchPhase.ENDED)
			{
				
				for (flNode = flightNodes.head; flNode; flNode = flNode.next)
				{
					flNode.flight.state = FlightCmp.ST_INIT_OUT;
				}
			}
		}
		
		private function ctrlBut_TRIGGERED(event:Event):void
		{
			isInit = true;
			addOrderedTilesToGame();
		}
		
		override public function removeFromGame(game:Game):void
		{
//			orderBut.removeEventListener(Event.TRIGGERED, testBut_TRIGGERED);
//			this.rootContainer.removeChild(orderBut);
		}
		override public function update(time:Number):void
		{
			var flNode:FlightToOrderPosNode;
			for (flNode = flightNodes.head; flNode; flNode = flNode.next)
			{
				var f:FlightCmp = flNode.flight;
				if(f.state == FlightCmp.ST_INIT_IN || 
					f.state == FlightCmp.ST_INIT_OUT)
				{
					var dx : Number;
					var dy : Number;
					if(f.state == FlightCmp.ST_INIT_IN)
					{
						dx = flNode.dpos.x0 - flNode.pos.x;
						dy =  flNode.dpos.y0 - flNode.pos.y;
					}
					else if(f.state == FlightCmp.ST_INIT_OUT)
					{
						dx = flNode.dpos.x1 - flNode.pos.x;
						dy = flNode.dpos.y1 - flNode.pos.y;
					}
					
					f.SX = Math.abs(dx);
					f.SY = Math.abs(dy);
					f.signX = getIntSign(dx);
					f.signY = getIntSign(dy);
					
					f.tc = 0;
					f.oscX  = 0;
					f.oscY  = 0;
					
					f.A = 30;// ?
					f.V = 0;
//					f.T = f.V * f.T - f.A * f.T * f.T / 2;
					f.T = 1;
					
					f.state = (f.state == FlightCmp.ST_INIT_IN) ? FlightCmp.ST_FLIGHT_IN : FlightCmp.ST_FLIGHT_OUT;
				}
				else if(f.state == FlightCmp.ST_FLIGHT_IN 
					|| f.state == FlightCmp.ST_FLIGHT_OUT)
				{
					var dsX : Number = 0;
					var dsY : Number = 0;
					var scX : Number = 0;
					var scY : Number = 0;
					f.tc += time;
					if(f.tc < f.T)
					{
						var ns:Number = easeInOutCubic(f.tc / f.T);
						if(ns > 1) ns = 1;
						
						scX = f.SX * ns;
						dsX = scX - f.oscX;
						
						scY = f.SY * ns;
						dsY = scY - f.oscY;
						
						if(ns == 1)
						{
							f.state = (f.state == FlightCmp.ST_FLIGHT_IN) ? FlightCmp.ST_IN_ORDER : FlightCmp.ST_END;
						}
						else
						{
							f.oscX = scX;
							f.oscY = scY;
						}
					}
					else
					{
						dsX = f.SX - f.oscX;
						dsY = f.SY - f.oscY;
						f.state = (f.state == FlightCmp.ST_FLIGHT_IN) ? FlightCmp.ST_IN_ORDER : FlightCmp.ST_END;
					}
					if(dsX != 0)
					{
						flNode.pos.x += (f.signX * dsX);
					}
					if(dsY != 0)
					{
						flNode.pos.y += (f.signY * dsY);
					}
				}
				else if(f.state == FlightCmp.ST_IN_ORDER)
				{
//					nothing
				}
				else if(f.state == FlightCmp.ST_END)
				{
					flNode.entity.remove(DPos);
					flNode.entity.remove(FlightCmp);
					game.removeEntity(flNode.entity);
				}
			}
		}
		
		private function addOrderedTilesToGame():void
		{
			var c:uint = config.rowsNum;
			for(var i:uint = 0; i < c; i++)
			{
				var k:uint = config.columnsNum;
				for(var j:uint = 0; j < k; j++)
				{
					var cvo:CellVO = config.columns[j][i];
					var e:Entity = cvo.e;
					var t:Tile = e.get(Tile) as Tile;
					var nm:uint = i * config.columnsNum + j;
					if(t.num != nm)
					{
						var x:int = t.num % config.rowsNum;
						var y:int = Math.floor(t.num / config.columnsNum);
						
						var pos:Pos = e.get(Pos);
						var dPos:DPos = new DPos(x * config.tileSize, y * config.tileSize, pos.x, pos.y);
						var fl:FlightCmp = new FlightCmp();
						e.add(dPos, DPos);
						e.add(fl, FlightCmp);
						game.addEntity( e );
					}
				}
			}
		}
	}
}
