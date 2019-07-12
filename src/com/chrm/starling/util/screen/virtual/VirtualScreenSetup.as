package com.chrm.starling.util.screen.virtual
{
	public class VirtualScreenSetup
	{
		private var screenWidth:int;
		private var screenHeight:int;
		private var virtualWidth:int;
		private var virtualHeight:int;

		private var screenAspect:Number;
		private var virtualAspect:Number;
		
		public function VirtualScreenSetup(screenWidth:int, screenHeight:int, virtualWidth:int, virtualHeight:int)
		{
			initialize(screenWidth, screenHeight, virtualWidth, virtualHeight);
		}
		/**
		 * Initialize virtual screen util
		 * 
		 * @param screenWidth Stage screen width
		 * @param screenHeight Stage screen height
		 * @param virtualWidth Virtual screen width
		 * @param virtualHeight Virtual screen height
		 * 
		 */
		public function initialize(screenWidth:int, screenHeight:int, virtualWidth:int, virtualHeight:int):void
		{
			this.screenWidth = screenWidth;
			this.screenHeight = screenHeight;
			
			this.virtualWidth = virtualWidth;
			this.virtualHeight = virtualHeight;

//			screen aspect
			screenAspect = screenWidth / screenHeight;
//			virtual aspect
			virtualAspect = virtualWidth / virtualHeight;
		}
		public function getScreenSizeFrom(objWidth:int, objHeight:int):Vector.<int>
		{
			var k:Number = 0;//	fitted coefficient
			var fsW:int;// fitted width
			var fsH:int;// fitted height
			var mrg:int;// fitted screen margin top or left
			
			var calcWidth:int;
			var calcHeight:int;
			if(screenAspect < virtualAspect)
			{
//				fit by width
				k = this.screenWidth / this.virtualWidth;
				fsH = this.virtualHeight * k;
				fsW = this.screenWidth;
				mrg = (this.screenHeight - fsH) >> 1;
				
				calcWidth = objWidth;
				calcHeight = this.screenWidth / (this.virtualWidth * this.virtualHeight * objHeight);
				
			}
			else
			{
//				fit by height
				k = this.screenHeight / this.virtualHeight;
				fsW = this.virtualWidth * k;
				fsH = this.screenHeight;
				mrg = (this.screenWidth - fsW) >> 1;
				
				calcWidth = this.screenHeight / (this.virtualHeight * this.virtualWidth * objWidth);
				calcHeight = objHeight;
			}
			calcWidth = fsW / this.virtualWidth * objWidth;
			calcHeight = fsH / this.virtualHeight * objHeight;

			return new <int>[calcWidth, calcHeight];
		}
	}
}