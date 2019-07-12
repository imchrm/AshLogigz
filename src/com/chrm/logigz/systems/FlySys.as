/**
 * Created by Dmitry Cheremisov on 18-Dec-16.
 *
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.Damper;
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.SpaceCmp;
	import com.chrm.logigz.componets.Tile;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.nodes.TrainNode;
	import com.chrm.logigz.nodes.SlideMovementNode;
	import com.chrm.logigz.vo.FlyVO;
	import com.chrm.logigz.vo.PlaySt;
	import com.chrm.util.math.ease.easeOutCubic;
	import com.chrm.util.math.getIntSign;
	
	import net.richardlord.ash.core.Entity;
	
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;

	import net.richardlord.ash.core.System;


	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.animation.Transitions;
	
	public class FlySys extends System
	{
		private static const log:ILogger = getLogger( FlySys );
		
		private var config : GameConfig;
		
		private var game:LGame;
		private var vagonNodes:NodeList;
		private var trainNodes:NodeList;

		public function FlySys()
		{
		}
		override public function addToGame( game : Game ) : void
		{
			this.game = game as LGame;
			this.config = this.game.config;
			
			vagonNodes = game.getNodeList( SlideMovementNode );
			trainNodes = game.getNodeList( TrainNode );
		}
		
		override public function update(time : Number):void
		{
//			config.playState == PlaySt.ST_UNTOUCH;
			var tnode : TrainNode;
			for(tnode = trainNodes.head; tnode; tnode = tnode.next)
			{
				
				var d : FlyVO = tnode.fly.flyVO;
				if(tnode.train.stateVA.value == TrainCmp.ST_INIT_FLY)
				{
					log.debug("FLY on:{0} num:{1}",[tnode.axis.axis, tnode.axis.num]);
					
					d.sign = getIntSign(d.V);
					d.V = Math.abs(d.V);
					
					d.T = d.V / (d.A * 3);
					
					d.S = d.V * d.T - d.A * d.T * d.T / 2;
					log.debug("V:{0}, S:{1}", [d.V * d.sign, d.S]);
//					d.dt = 0;
					d.tc = 0;
//					d.ds = 0;
//					d.sc = 0;
				d.osc = 0;
					
					var ts : Number = config.tileSize;
//					var ts_2 : int = ts >> 1;
					var ts_2 : int = ts;
					var o:Number;
					var y:Number = d.offset - ts_2;
					var ii : int = Math.floor( y / ts );
					var l : int = ii * ts;
					var r : int = ++ii * ts;
					var rs : Number = r - y;
					var ls : Number = y - l;
					o = ( rs < ls) ? rs : l - y;
					var n : Number = Math.floor( d.S / ts );
					d.S = n * ts;
					if(n == 0 && o < 0)
						d.sign = -1;
					d.S += d.sign * o;
					
//					log.debug("V:{0}, T:{1}, S:{2}",[d.V, d.T, d.S]);
					
					tnode.train.stateVA.value = TrainCmp.ST_FLY;
				}
				else if(tnode.train.stateVA.value == TrainCmp.ST_FLY)
				{
					// значение изменения позиции за время цикла update(time)
					var ds : Number = 0;
					var sc : Number = 0;
					d.tc += time;
					if (d.tc < d.T)
					{
//						var ns:Number = Transitions.getTransition(Transitions.EASE_OUT_BACK)(d.tc / d.T);
						var ns:Number = easeOutCubic(d.tc / d.T);
						if(ns > 1) ns = 1;
						sc = d.S * ns;
						ds = sc - d.osc;
						/*if( ds < 0.01)
						{
							ds = d.S - d.osc;
							tnode.train.stateVA.value = TrainCmp.ST_CLEAN;
						}
						else*/ if(ns == 1)
							tnode.train.stateVA.value = TrainCmp.ST_CLEAN;
						else
							d.osc = sc;
					}
					else
					{
						ds = d.S - d.osc;
						tnode.train.stateVA.value = TrainCmp.ST_CLEAN;
					}
					if(ds != 0)
					{
						var axisNumber:int = tnode.axis.axis;
						
						if (axisNumber == 1)
							if(ds >  config.width)
								ds %= config.width;
						else 
							if(ds > config.height)
								ds %= config.height;
						
						tnode.fly.spaceVO.value = ds * d.sign;
						
						var vs:Vector.<Entity> = tnode.train.vagons;
						var c:int = vs.length;
						for (var i:int = 0; i < c; i++)
						{
							var ve:Entity = vs[i];
							var pos:Pos = ve.get(Pos);
							var spc:SpaceCmp = ve.get(SpaceCmp);
							if (axisNumber == 1)
								pos.x += spc.spaceVA.value;
							else
								pos.y += spc.spaceVA.value;
						}
					}
				}
			}
		}
		
//		easeOutCubic
		[Inline]
		private function ease( t : Number ) : Number
		{
			return (--t)*t*t+1;
		}
		
	}
}
