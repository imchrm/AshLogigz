/**
 * Created by Dmitry Cheremisov on 08-Dec-16.
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.EntityCreator;
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.AxisCmp;
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.GameStateCmp;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.nodes.GameNode;
	import com.chrm.logigz.nodes.TileCollisionNode;
	import com.chrm.logigz.vo.CellVO;
	import com.chrm.logigz.vo.FlyVO;
	import com.chrm.logigz.vo.SpaceVO;
	import com.chrm.logigz.vo.StateVO;
	
	import net.richardlord.ash.core.Entity;
	
	import net.richardlord.ash.core.Entity;

	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;

	import net.richardlord.ash.core.System;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class GameManagementSystem extends System
	{
		private static const log:ILogger = getLogger( GameManagementSystem );
		
		private var creator:EntityCreator;
		private var config:GameConfig;
		
		private var game : LGame;
		
		private var gameNodes:NodeList;
		private var tiles:NodeList;
//		private var movement:NodeList;

		public function GameManagementSystem( )
		{
		}

		override public function addToGame( game : Game ) : void
		{
			this.game = game as LGame;
			this.creator = this.game.creator;
			this.config = this.game.config;
			gameNodes = game.getNodeList( GameNode );
//			spaceships = game.getNodeList( SpaceshipCollisionNode );
			
			tiles = game.getNodeList( TileCollisionNode );
			log.debug("addToGame");
//			movement = game.getNodeList( MotionControlNode );
		}

		override public function update( time : Number ) : void
		{
			var node : GameNode;
			for( node = gameNodes.head; node; node = node.next )
			{
			}
		}
		
		private function createLevel():void
		{
//			TODO: Load level data and calculate level's parameters
			config.rowsNum = 4;
			config.columnsNum = 4;
			config.tileSize = 80;
			config.width = config.tileSize * config.rowsNum;
			config.height = config.tileSize * config.columnsNum;
			
			var rows:Vector.<Vector.<CellVO>> = new <Vector.<CellVO>>[];
			var hCells:Vector.<CellVO>;
			
			var clms:Vector.<Vector.<CellVO>> = new <Vector.<CellVO>>[];
			var vCells:Vector.<CellVO>;
			
//			var ind : int = config.tileSize >> 1;
			var e : Entity;
			var cl:CellVO;
			var i : uint;
			var c : uint;
//			var c : uint = config.rowsNum * config.columnsNum;
			/*for( i = 0; i < c; i++)
			{
				var hi : int = Math.floor( i / config.rowsNum );
				if( rows.length - 1 < hi )
				{
					rows.push(new <CellVO>[]);
					hCells = rows[hi];
				}
				var vi : int = i % config.columnsNum;
				if( columns.length - 1 < vi && vi == i)
					columns.push(new <CellVO>[]);
				vCells = columns[vi];
				
				e = creator.createTile( i, vi * config.tileSize + ind, hi * config.tileSize + ind);
//				var me: Entity = creator.createMiracleTile( i );
				
				cl = new CellVO( e );
				hCells.push(cl);
				vCells.push(cl);
				
				game.addEntity( e );
			}*/
			var vgns : Vector.<Entity>;
			var pi : uint = 0;
			var k:uint = config.columnsNum;
			var j:uint;
			c = config.rowsNum;
			for(i = 0; i < c; i++)
			{
				hCells = new <CellVO>[];
				rows.push(hCells);
				
				vgns = new <Entity>[];
				
				for(j = 0; j < k; j++)
				{
					if(i == 0)
					{
						vCells = new <CellVO>[];
						clms.push(vCells);
					}
					vCells = clms[j];
					hCells = rows[i];
				
					e = creator.createTile( pi, j * config.tileSize, i * config.tileSize);
					cl = new CellVO( e );
					
					vCells.push( cl );
					hCells.push( cl );
					
					game.addEntity( e );
					vgns.push( e );
					
					pi++;
				}
				var flyCmp:FlyCmp = new FlyCmp(new SpaceVO(), new FlyVO());
				var axis : AxisCmp = new AxisCmp(1, i);
				var train : TrainCmp = new TrainCmp();
				train.stateVA = new StateVO(TrainCmp.ST_CLEAN);
				train.vagons = vgns;
				var te:Entity = creator.createTrain(flyCmp, axis, train );
				game.addEntity( te );
			}
			config.rows = rows;
			config.columns = clms;
		}
	}
}
