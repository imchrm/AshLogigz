/**
 * Created by Dmitry Cheremisov on 03-May-17.
 */
package com.chrm.logigz.vo
{
	public class GameSt
	{
		private static var sts 						: int = 0;
		
		public static const ST_INIT_LEVEL 					: int = sts++;
		public static const ST_PLAY 					: int = sts++;
		public static const ST_GAME_OVER 				: int = sts++;
	}
}
