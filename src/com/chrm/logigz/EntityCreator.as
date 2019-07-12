/**
 * Created by Dmitry Cheremisov on 06-Dec-16.
 */
package com.chrm.logigz
{
	import com.chrm.logigz.componets.AxisCmp;
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.GDspl;
	import com.chrm.logigz.componets.GPos;
	import com.chrm.logigz.componets.Dspl;
	import com.chrm.logigz.componets.GameStateCmp;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.DragCmp;
	import com.chrm.logigz.componets.SpaceCmp;
	import com.chrm.logigz.componets.Tile;
	import com.chrm.logigz.componets.TrainStateCmp;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.vo.StateVO;
	
	import net.richardlord.ash.core.Entity;

	import starling.display.Image;
	import starling.textures.Texture;

	import starling.assets.AssetManager;

	public class EntityCreator
	{
		private var config : GameConfig;
		private var game : LGame;
		private var assetManager:AssetManager;
		
		public var tilesEntities : Vector.<Entity>;
		
		public function EntityCreator(config : GameConfig, game : LGame, assetManager : AssetManager)
		{
			this.config = config;
			this.game = game;
			this.assetManager = assetManager;
		}

		public function createGame() : Entity
		{
			var entity : Entity = new Entity()
				.add( new GameStateCmp() );
			entity.name = "game";

			game.addEntity( entity );

			return entity;
		}
		
		private static const TXTR_NAME : String = 'txtr_';
		private static const TILE_NAME : String = 'tile_';
		
		public function createTile( num : int, x : Number = 0, y : Number = 0 ) : Entity
		{
			var img : Image = getImgByNum( num );
			img.touchable = false;
			var gimg : Image = getImgByNum( num );
			gimg.touchable = false;
			var entity : Entity = new Entity()
				.add( new Tile( num ) )
				.add( new Pos( x, y ) )
				.add( new DragCmp( 0, 0 ) )
				.add( new SpaceCmp( ) )
				.add( new TrainStateCmp( new StateVO(TrainCmp.ST_CLEAN) ) )
				.add( new Dspl( img ) )
				.add( new GPos(0, 0, -100, -100))
				.add( new GDspl( gimg ));
			entity.name = TILE_NAME + num.toString();
			
			if(!tilesEntities)
				tilesEntities = new <Entity>[];
			tilesEntities.push(entity);
			
//			game.addEntity( entity );
			
			return entity;
		}
		
		public function createTrain(flyCmp : FlyCmp, axis : AxisCmp, train : TrainCmp ) : Entity
		{
			var e : Entity = new Entity()
				.add( axis )
				.add( flyCmp )
				.add( train );
			
			return e;
		}
		public function getTileEntity(i : int) : Entity
		{
			return tilesEntities[i];
		}
		
		private function getImgByNum(num:int):Image
		{
			var txtr : Texture = assetManager.getTexture( TXTR_NAME + num.toString() );
			var img : Image = new Image(txtr);
//			img.pivotX = img.width >> 1;
//			img.pivotY = img.height >> 1;
			return img;
		}
	}
}
