package buzzler.system
{
	import buzzler.data.display.BzDisplayObject;
	import buzzler.data.BzSprite;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	public class BzRenderer
	{
		private var _hash	:Dictionary;
		private	var _sprites:Vector.<BzSprite>;
		
		public function BzRenderer()
		{
			_hash		= new Dictionary();
			_sprites	= new Vector.<BzSprite>();
		}
		
		public	function exec():void
		{
			for each (var sprite:BzSprite in _sprites)
			{
				sprite.drawNextFrame();
			}
		}
		
		public	function reg(target:Bitmap, sprite:BzSprite):void
		{
			unreg(target);

			_hash[target] = sprite;
			sprite.addReferer(target);
			
			if (sprite.getReferers()==1 && !sprite.isSingle())
				_sprites.push(sprite);
		}
		
		public	function unreg(target:Bitmap):void
		{
			var sprite:BzSprite = _hash[target] as BzSprite;
			if (sprite)
			{
				sprite.removeReferer(target);
				delete _hash[target];
				
				if (sprite.getReferers() == 0 && !sprite.isSingle())
					_sprites.splice(_sprites.indexOf(sprite),1);
			}
		}
	}
}