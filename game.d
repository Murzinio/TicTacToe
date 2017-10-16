module game;

import board;
import io;
import stdext;

import std.conv;
import std.stdio;

/// Player type.
enum Player
{
    x, 
    o
}

/// Manages gameplay.
class Game
{
public:
    /// Game loop, runs until exit is requested.
    void mainLoop()
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
                    m_board.setField(charNum(input[0]) - 1, charNum(input[1]) - 1, FieldValue.O);
                    break;
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

    auto m_board = new Board();
    auto m_io = new Io;

    auto m_counter = 0;
    auto m_exitRequested = false;
}