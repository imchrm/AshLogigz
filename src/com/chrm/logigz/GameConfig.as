/**
 * Created by Dmitry Cheremisov on 06-Dec-16.
 */
package com.chrm.logigz
{
	import com.chrm.logigz.componets.GameStateCmp;
	import com.chrm.logigz.vo.CellVO;
	import com.chrm.logigz.vo.GameSt;
	import com.chrm.logigz.vo.PlaySt;
	
	public class GameConfig
	{
		public static const BORDER_TOP:int = 40;
		
		public var rowsNum : int = 4;
		public var columnsNum : int = 4;
		public var tileSize : int = 80;
		
//		array of horizontal vectors of Cells
		public var rows : Vector.<Vector.<CellVO>>;
//		array of vertical vectors of Cells
		public var columns : Vector.<Vector.<CellVO>>;
		
		public var width : int;
		public var height : int;
		
		public var gameState : int = -1;
		public var playState : int = PlaySt.ST_IDLE;
		
		public function GameConfig()
		{
		}
	}
}
