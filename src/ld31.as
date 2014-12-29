package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="#555555")]
	public class ld31 extends Sprite
	{
		public static const GRID_WIDTH:int = 15;
		public static const GRID_HEIGHT:int = 15;
		
		public static const BOARD_WIDTH:Number = 600;
		public static const BOARD_HEIGHT:Number = 600;
		
		public static var TILE_WIDTH:Number = BOARD_WIDTH / GRID_WIDTH;
		public static var TILE_HEIGHT:Number = BOARD_HEIGHT / GRID_HEIGHT;
		
		public var grid:Array;
		public var board:Sprite;
		
		public var score:int;
		
		public var trapLeft:Number = 0;
		public var trapRight:Number = 0;
		public var trapTop:Number = 0;
		public var trapBottom:Number = 0;
		
		public var lastShrink:int;
		public var shrinkRate:int = 250;
		
		public var lastEnemy:int;
		public var enemyRate:int = 1000;
		public var enemies:Array = [];
		
		public var hero:HeroSprite;
		public var isShooting:Boolean = false;
		
		public var canShrinkHorizontal:Boolean = true;
		public var canShrinkVertical:Boolean = true;
		
		public var bg:Game;
		public function ld31()
		{
			bg = new Game();
			addChild(bg);
			
			bg.gameover.visible = false;
			bg.tryagain.visible = false;
			bg.tryagain.addEventListener(MouseEvent.CLICK, NewGame);
			
			board = new Sprite();
			board.x = 800 - BOARD_WIDTH;
			board.y = 600 - BOARD_HEIGHT;
			
			bg.addChildAt(board, 2);
			grid = new Array(GRID_WIDTH);
			for(var i:int = 0; i < GRID_WIDTH; i++)
			{
				grid[i] = new Array(GRID_HEIGHT);
				for(var j:int = 0; j < GRID_HEIGHT; j++)
				{
					var tile:TrapSprite = new TrapSprite(TILE_WIDTH, TILE_HEIGHT);
					board.addChild(tile);
					
					tile.x = TILE_WIDTH/2 + TILE_WIDTH*i;
					tile.y = TILE_HEIGHT/2 + TILE_HEIGHT*j;
					grid[i][j] = tile;
				}
			}
			
			hero = new HeroSprite(TILE_WIDTH);
			board.addChild(hero);
			
			hero.x = BOARD_WIDTH/2;
			hero.y = BOARD_HEIGHT/2;
			
			addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, HandleKey);
		}
		
		public function HandleKey(ke:KeyboardEvent):void
		{
			//W or Left or D or Right
			if(ke.keyCode == 65 || ke.keyCode == 37 || ke.keyCode == 39 || ke.keyCode == 68)
			{
				hero.rotation += 90;
				hero.isHorizontal = !hero.isHorizontal;
				
				canShrinkHorizontal = true;
				canShrinkVertical = true;
				
				hero.Clear();
			}
			
			//Spacebar
			if(ke.keyCode == 32)
			{
				hero.Clear();
				canShrinkHorizontal = true;
				canShrinkVertical = true;
				isShooting = true;
			}
		}
		
		public function Update(e:Event=null):void
		{
			if(getTimer() - lastShrink > shrinkRate)
			{
				lastShrink = getTimer();
				if(canShrinkHorizontal) ShrinkHorizontal();
				if(canShrinkVertical) ShrinkVertical();
			}
			
			if(getTimer() - lastEnemy > enemyRate)
			{
				lastEnemy = getTimer();
				var enemy:EnemySprite = new EnemySprite(TILE_WIDTH);
				enemy.x = trapLeft;
				enemy.y = trapTop;
				board.addChild(enemy);
				enemies.push(enemy);
			}
			
			UpdateEnemies();
			
			if(isShooting)
			{
				if(hero.isHorizontal)
				{
					var max_width:Number = (GRID_WIDTH - 1)/2 * TILE_WIDTH - trapLeft;
					if(hero.Grow() > max_width)
					{
						hero.armLength = max_width;
						hero.Refresh();
						isShooting = false;
						canShrinkHorizontal = false;
						CheckHitHorizontal();
					}
				}else{
					var max_height:Number = (GRID_HEIGHT - 1)/2 * TILE_HEIGHT - trapTop;
					if(hero.Grow() > max_height)
					{
						hero.armLength = max_height;
						hero.Refresh();
						isShooting = false;
						canShrinkVertical = false;
						CheckHitVertical();
					}
				}
			}
		}
		
		public function UpdateEnemies():void
		{
			for(var i:int = 0; i < enemies.length; i++)
			{
				enemies[i].Step(trapLeft, BOARD_WIDTH-trapRight, trapTop, BOARD_HEIGHT-trapBottom);
				var dx:Number = enemies[i].x - hero.x;
				var dy:Number = enemies[i].y - hero.y;
				if(Math.sqrt(dx*dx + dy*dy) < enemies[i].size)
				{
					GameOver();	
				}
			}
		}
		
		public function GameOver():void
		{
			bg.gameover.visible = true;
			bg.tryagain.visible = true;
			
			removeEventListener(Event.ENTER_FRAME, Update);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, HandleKey);	
		}
		
		public function NewGame(e:Event):void
		{
			for(var i:int = 0; i < enemies.length; i++)
			{
				board.removeChild(enemies[i]);
			}
			enemies = [];
			score = 0;
			bg.kills.text = score + "";
			
			trapLeft = 0;
			trapRight = 0;
			trapTop = 0;
			trapBottom = 0;
			
			bg.gameover.visible = false;
			bg.tryagain.visible = false;
			
			addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, HandleKey);
		}
		
		public function CheckHitHorizontal():void
		{
			
			for(var i:int = 0; i < enemies.length; i++)
			{
				if(enemies[i].velocityY != 0)
				{
					if(Math.abs(enemies[i].y - hero.y) < TILE_WIDTH/2)
					{
						board.removeChild(enemies[i]);
						enemies.splice(i, 1);
						score++;
						bg.kills.text = score + "";
						i--;
					}
				}
			}
		}
		
		public function CheckHitVertical():void
		{
			for(var i:int = 0; i < enemies.length; i++)
			{
				if(enemies[i].velocityX != 0)
				{
					if(Math.abs(enemies[i].x - hero.x) < TILE_WIDTH/2)
					{
						board.removeChild(enemies[i]);
						enemies.splice(i, 1);
						score++;
						bg.kills.text = score + "";
						i--;
					}
				}
			}
		}
		
		public function ShrinkVertical():void
		{
			trapTop += 1;
			trapBottom += 1;
			
			for(var i:int = 0; i < GRID_WIDTH; i++)
			{
				for(var j:int = 0; j < GRID_HEIGHT; j++)
				{
					grid[i][j].trapTop = Math.max(0, trapTop - j*TILE_HEIGHT);
					grid[i][GRID_HEIGHT-1-j].trapBottom = Math.max(0, trapBottom - j*TILE_HEIGHT);
				}
			}
		}
		
		public function ShrinkHorizontal():void
		{
			trapLeft += 1;
			trapRight += 1;
			
			for(var i:int = 0; i < GRID_WIDTH; i++)
			{
				for(var j:int = 0; j < GRID_HEIGHT; j++)
				{
					grid[i][j].trapLeft = Math.max(0, trapLeft - i*TILE_WIDTH);
					grid[GRID_WIDTH - 1 - i][j].trapRight = Math.max(0, trapRight - i*TILE_WIDTH);
				}
			}
		}
	}
	
}