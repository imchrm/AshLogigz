/**
 * Created by Dmitry Cheremisov on 06-Mar-17.
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.DragCmp;
	import com.chrm.logigz.componets.GPos;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.SpaceCmp;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.nodes.TrainNode;
	import com.chrm.logigz.nodes.VagonNode;
	
	import net.richardlord.ash.core.Entity;
	
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	
	import net.richardlord.ash.core.System;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class TileThrowSystem extends System
	{
		private static const log:ILogger = getLogger(TileThrowSystem);
		
		private var config:GameConfig;
		private var trainNodes:NodeList;
		
		public function TileThrowSystem()
		{
		}
		
		override public function addToGame( game : Game ) : void
		{
			this.config = (game as LGame).config;
			trainNodes = game.getNodeList( TrainNode );
		}
		
		override public function update(time : Number ):void
		{
			var tnode : TrainNode;
			
			for(tnode = trainNodes.head; tnode; tnode = tnode.next)
			{
				var st : int = tnode.train.stateVA.value;
				if(st == TrainCmp.ST_HOOK ||
					st == TrainCmp.ST_FLY ||
					st == TrainCmp.ST_CLEAN)
				{
					var axisNumber:int = tnode.axis.axis;
					var vs:Vector.<Entity> = tnode.train.vagons;
					var c:uint = vs.length;
					for (var i:uint = 0; i < c; i++)
					{
						var ve:Entity = vs[i];
						var drg : DragCmp = ve.get(DragCmp);
						var pos:Pos = ve.get(Pos);
						
						var gpos:GPos = ve.get(GPos);
						
						var ts : int = config.tileSize;
						var ts_2 : int = config.tileSize >> 1;
						
						if (axisNumber == 1)
						{
							var w:int = config.width;
							if (pos.x + ts_2 > w )
							{
								pos.x -= w;
								drg.offset.x = drg.controlX - pos.x;// for drag
							}
							else if (pos.x + ts_2 < 0)
							{
								pos.x += w;
								drg.offset.x = drg.controlX - pos.x;// for drag
							}
							if(pos.x + ts > w)
							{
								gpos.x = pos.x - w;
								if(gpos.y != pos.y)
									gpos.y = pos.y;
							}
							else if(pos.x < 0)
							{
								gpos.x = pos.x + w;
								if(gpos.y != pos.y)
									gpos.y = pos.y;
							}
							else
							{
								if(gpos.x != gpos.px)
									gpos.x = gpos.px;
								if(gpos.y != gpos.py)
									gpos.y = gpos.py;
							}
						}
						else
						{
							var h:int = config.height;
							if (pos.y + ts_2 >= h)
							{
								pos.y -= h;
								drg.offset.y = drg.controlY - pos.y;// for drag
							}
							else if (pos.y + ts_2 < 0)
							{
								pos.y += h;
								drg.offset.y = drg.controlY - pos.y;// for drag
							}
							if(pos.y + ts > h)
							{
								gpos.y = pos.y - h;
								if(gpos.x != pos.x)
									gpos.x = pos.x;
							}
							else if(pos.y < 0)
							{
								gpos.y = pos.y + h;
								if(gpos.x != pos.x)
									gpos.x = pos.x;
							}
							else
							{
								if(gpos.x != gpos.px)
									gpos.x = gpos.px;
								if(gpos.y != gpos.py)
									gpos.y = gpos.py;
							}
						}
					}
					var cc : uint = vs.length - 1;
					
					for(i = 0; i < cc; i++)
					{
						var vi:Entity = vs[i];
						var psi:Pos = vi.get(Pos);
						
						var vii:Entity = vs[++i];
						var psii:Pos = vii.get(Pos);
						
						var r:Number;
						if (axisNumber == 1)
						{
							r = (psii.x < psi.x) ? Math.abs(config.width + psii.x - psi.x) : Math.abs(psii.x - psi.x);
							if( !(r - 0.1 < config.tileSize && config.tileSize < r + 0.1) )
							{
								traceTrains();
								log.debug("What!?");
							}
						}
						else
						{
							r = (psii.y < psi.y) ? Math.abs(config.width + psii.y - psi.y) : Math.abs(psii.y - psi.y);
							if( !(r - 0.1 < config.tileSize && config.tileSize < r + 0.1))
							{
								traceTrains();
								log.debug("What!?");
							}
						}
					}
				}
			}
		}
		
		private function traceTrains():void
		{
			var tnode:TrainNode;
			for(tnode = trainNodes.head; tnode; tnode = tnode.next)
			{
				log.debug("state: {0} axis:{1} num:{2}", [tnode.train.stateVA.value, tnode.axis.axis, tnode.axis.num]);
			}
		}
	}
}
