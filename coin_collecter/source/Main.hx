package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
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
			var coin = new FlxSprite(FlxRandom.float(0, FlxG.width - 16), FlxRandom.float(0, FlxG.height - 16));
			coin.makeGraphic(16, 16, 0xffffff00);
			coins.add(coin);
		}

		player = new FlxSprite(0, 0);
		player.makeGraphic(16, 16, 0xff0000ff);

		score = new FlxText(4, 4, FlxG.width - 8, "");
		score.color = 0xffffffff;
		score.setFormat(null, 16, 0xffffffff, "center");
		score.shadow = 0xff000000;

		timer = new FlxText(4, FlxG.height - 16, FlxG.width - 8, "");
		timer.color = 0xffffffff;
		timer.setFormat(null, 16, 0xffffffff, "center");
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

		timeLeft -= 1;
		timer.text = "Time Left: ${timeLeft}";

		if (timeLeft <= 0)
		{
			FlxG.switchState(new LoseState());
		}
	}

	private function collectCoin(player:FlxSprite, coin:FlxSprite):Void
	{
		coins.remove(coin, true);
		scoreCount += 1;
		score.text = "Score: ${scoreCount} / ${targetScore}";
	}
}

class WinState extends FlxState
{
	private var winText:FlxText;

	override public function create():Void
	{
		winText = new FlxText(0, FlxG.height / 2 - 16, FlxG.width, "You win!");
		winText.color = 0xffffffff;
		winText.setFormat(null, 32, 0xffffffff, "center");
		winText.shadow = 0xff000000;

		add(winText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed())
		{
			FlxG.switchState(new PlayState());
		}
	}
}
