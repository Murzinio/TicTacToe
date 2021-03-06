module game;
@safe:

import board;
import io;
import stdext;

import std.conv;
import std.stdio;
import std.typecons;

/// Player type.
enum Player
{
    X = FieldValue.X,
    O = FieldValue.O
}

/// Manages gameplay.
class Game
{
public:
    /// Game loop, runs until exit is requested.
    @system void mainLoop()
    {
        string input;

        m_board.draw();
        promptForInput();
        m_io.drawAll();            

        while(!m_exitRequested)
        {            
            promptForInput();
            input = m_io.getInput();

            switch(input)
            {
                case "\0":
                    m_io.addMessageToQueue("Invalid input!");
                    break;
                
                case "q\n":
                    m_exitRequested = true;
                    m_io.clearQueue();
                    m_io.addMessageToQueue("Exiting...");                    
                    m_io.drawAll();
                    break;

                default:
                    auto chosenField = tuple(charNum(input[0]) - 1, charNum(input[1]) - 1);

                    if (m_board.isFieldAvailable(chosenField))
                    {
                        m_board.setField(chosenField, m_currentPlayer);
                    }
                    else
                    {
                        m_io.addMessageToQueue("Non empty field chosen!");
                    }
                    break;
            }

            if (m_board.areAllFieldsFilled())
            {
                m_io.addMessageToQueue("Draw!");
                m_io.drawAll();
                m_exitRequested = true;
            }

            if (m_board.anyThreeAdjacentFieldsEqual())
            {
                m_io.addMessageToQueue("Player " ~ m_currentPlayer ~ " won the game!");
                m_io.drawAll();
                m_exitRequested = true;
            }
        
            if (input != "\0")
            {
                switchPlayer();
            }

            if (!m_exitRequested)
            {
                m_board.draw();
                m_io.drawAll();
            }
        
        }
        
    }

private:
    void promptForInput()
    {
        m_io.addMessageToQueue
        (
            "Select field (\"xy\" - i.e. \"21\" selects column 2, row 1) or type \"q\" to exit."
        );
    }

    void switchPlayer()
    {
        if (m_currentPlayer == Player.X)
        {
            m_currentPlayer = Player.O;
        }
        else
        {
            m_currentPlayer = Player.X;
        }
    }

    unittest
    {
        auto game = new Game;

        game.switchPlayer();
        assert(game.m_currentPlayer == Player.X,
        "Current player not switched!");
    }

    auto m_board = new Board();
    auto m_io = new Io;

    auto m_currentPlayer = Player.O;
    bool m_exitRequested;
}