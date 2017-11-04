import game;
@system:

import std.stdio;

void main(string[] args)
{
    auto game = new Game();
    game.mainLoop();
    readln();
}