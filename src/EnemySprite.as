package
{
	import flash.display.Sprite;
	
	public class EnemySprite extends Sprite
	{
		public var velocityX:Number = 3.0;
		public var velocityY:Number;
		
		public var turns:int;
		
		public function get offset():int
		{
			return Math.floor(turns/4);
		}
		
		public var size:Number;
		public function EnemySprite(size:Number)
		{
			super();
			this.size = size;
			
			graphics.clear();
			graphics.lineStyle(1, 0);
			graphics.beginFill(0xaa3333);
			graphics.drawCircle(0,0,size/2);
		}
		
		public function Step(left:Number, right:Number, top:Number, bottom:Number):Boolean
		{
			var did_turn:Boolean = false;
			x += velocityX;
			y += velocityY;
			
			if(velocityX > 0)
			{
				//moving along top edge
				y = top + size/2 + offset*size;
				if(x > right - size/2 - offset*size)
				{
					x = right - size/2 - offset*size;
					velocityY = velocityX;
					velocityX = 0;
					did_turn = true;
					turns++;
				}
			}else if(velocityX < 0){
				//moving along the bottom edge
				y = bottom - size/2 - offset*size;
				if(x < left + size/2 + offset*size)
				{
					x = left+size/2 + offset*size;
					velocityY = velocityX;
					velocityX = 0;
					did_turn = true;
					turns++;
				}
			}else if(velocityY > 0){
				//moving along right edge
				x = right - size/2 - offset*size;
				if(y > bottom - size/2 - offset*size)
				{
					y = bottom-size/2 - offset*size;
					velocityX = -1*velocityY;
					velocityY = 0;
					did_turn = true;
					turns++;
				}
			}else{
				//moving up the left edge
				x = left + size/2 + offset*size;
				if(y < top+size/2 + (offset+1)*size)
				{
					y = top+size/2 + (offset+1)*size;
					velocityX = -1*velocityY;
					velocityY = 0;
					did_turn = true;
					turns++;
				}
			}
			
			return did_turn;
		}
	}
}