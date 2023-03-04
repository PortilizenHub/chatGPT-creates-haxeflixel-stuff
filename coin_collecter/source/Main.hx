package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.text.FlxText;

class Main extends FlxGame
{
	public function new()
	{
		super(320, 240, PlayState);
	}
}

class PlayState extends FlxState
{
	private var coins:FlxGroup;
	private var player:FlxSprite;
	private var score:FlxText;
	private var timer:FlxText;
	private var timeLeft:Int;
	private var targetScore:Int = 10;
	private var scoreCount:Int = 0;

	override public function create():Void
	{
		FlxG.bgColor = 0xffaaaaaa;

		coins = new FlxGroup();
		for (i in 0...20)
		{
			var coin = new FlxSprite(FlxRandom.int(0, FlxG.width - 16), FlxRandom.int(0, FlxG.height - 16));
			coin.makeGraphic(16, 16, 0xffffff00);
			coins.add(coin);
		}

		player = new FlxSprite(0, 0);
		player.makeGraphic(16, 16, 0xff0000ff);

		score = new FlxText(4, 4, FlxG.width - 8, "");
		score.color = 0xffffffff;
		score.shadow = 0xff000000;

		timer = new FlxText(4, FlxG.height - 16, FlxG.width - 8, "");
		timer.color = 0xffffffff;
		timer.shadow = 0xff000000;

		add(coins);
		add(player);
		add(score);
		add(timer);

		timeLeft = 30;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(player, coins, collectCoin);

		if (scoreCount >= targetScore)
		{
			FlxG.switchState(new WinState());
		}

		timeLeft -= Math.ceil(elapsed);
		if (timeLeft <= 0)
		{
			FlxG.switchState(new LoseState());
		}

		score.text = "Score: " + scoreCount + " / " + targetScore;
		timer.text = "Time: " + timeLeft;
	}

	private function collectCoin(player:FlxSprite, coin:FlxSprite):Void
	{
		coin.kill();
		scoreCount++;
	}
}

class WinState extends FlxState
{
	override public function create():Void
	{
		var text = new FlxText(0, FlxG.height / 2 - 16, FlxG.width, "You win!");
		text.alignment = "center";
		add(text);
	}
}

class LoseState extends FlxState
{
	override public function create():Void
	{
		var text = new FlxText(0, FlxG.height / 2 - 16, FlxG.width, "You lose!");
		text.alignment = "center";
		add(text);
	}
}
