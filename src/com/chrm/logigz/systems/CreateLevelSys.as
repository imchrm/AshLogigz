/**
 * Created by Dmitry Cheremisov on 19-Apr-17.
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.EntityCreator;
	import com.chrm.logigz.GameConfig;
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.AxisCmp;
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.GPos;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.nodes.DisplayNode;
	import com.chrm.logigz.vo.CellVO;
	import com.chrm.logigz.vo.FlyVO;
	import com.chrm.logigz.vo.GameSt;
	import com.chrm.logigz.vo.SpaceVO;
	import com.chrm.logigz.vo.StateVO;
	
	import net.richardlord.ash.core.Entity;
	
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import starling.display.DisplayObject;
	
	import starling.display.DisplayObject;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	
	public class CreateLevelSys extends System
	{
		private static const log:ILogger = getLogger(CreateLevelSys);
		
		private var game:LGame;
		
		private var config:GameConfig;
		private var container:DisplayObjectContainer;
		
		private var nodes:NodeList;
		private var creator:EntityCreator;
		
		public function CreateLevelSys()
		{
			super();
		}
		
		override public function addToGame( game : Game ):void
		{
			this.game = game as LGame;
			this.config = this.game.config;
			this.creator = this.game.creator;
			this.container = this.game.borderContainer;
			this.container.y = GameConfig.BORDER_TOP;
			nodes = game.getNodeList(DisplayNode);
			
			createLevel();
		}
		override public function update( time : Number ) : void
		{
			
			var node:DisplayNode;
			for(node = nodes.head; node; node = node.next)
			{
				var d : DisplayObject = node.dspl.displayObject;
				var p : Pos = node.pos;
				var gd : DisplayObject = node.gdspl.displayObject;
				var gp : GPos = node.gpos;
				
				var ch:DisplayObject = this.container.addChild( d );
				d.x = p.x;
				d.y = p.y;
				
				gd.visible = false;
				this.container.addChild( gd );
				gd.x = gp.px;
				gd.y = gp.py;
				gp.x = gp.px;
				gp.y = gp.py;
			}
			
			config.gameState = GameSt.ST_PLAY;
		}
		private function createLevel():void
		{
//			TODO: Load level data and calculate level's parameters
			config.rowsNum = 4;
			config.columnsNum = 4;
			config.tileSize = 80;
			config.width = config.tileSize * config.rowsNum;
			config.height = config.tileSize * config.columnsNum;
			
			var q:Quad = new Quad(config.width, config.height);
			container.mask = q;
			
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
