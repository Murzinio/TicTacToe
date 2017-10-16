module io;
import stdext;

import std.container : DList;
import std.conv;
import std.stdio;
import std.string;
import std.system;

/// Handles input and output.
class Io
{
public:
    /// Adds line to draw queue which is later drawed in order of insertion.
    void addToQueue(string elem)
    {
        m_drawQueue.insertBack(elem);
    }

    /// Adds line to draw queue which is later drawed in order of insertion.
    void addToQueue(char[] elem)
    {
        m_drawQueue.insertBack(to!(string)(elem));
    }

    /// Draws lines in order of insertion to queue.
    void drawAll()
    {
        writeln("\033c"); // clears terminal
        while(!m_drawQueue.empty)
        {
            writeln(m_drawQueue.front());
            m_drawQueue.removeFront();
        }
    }

    /// Reads line.
    string getInput()
    {
        auto input = readln();
        if (isInputValid(input))
        {
            return input;
        }

        return ['\0'];
    }

    /// Shows fancy message.
    void addMessageToQueue(string message)
    {
        char[] splitter = new char[message.length];
        foreach(i; 0 .. message.length)
        {
            splitter[i] = '*';
        }

        addToQueue(splitter);
        addToQueue(message);
        addToQueue(splitter);
    }

    void clearQueue()
    {
        m_drawQueue.clear();
    }

private:
    bool isInputValid(string input)
    {
        char[] convertedInput = to!(char[])(input);
        foreach(elem; validInput)
        {
            if (convertedInput[0] == elem)
            {
                if (isNumeric(convertedInput[0]))
                {
                    if (!isNumeric(convertedInput[1]))
                    {
                        return false;
                    }
                }
                return true;
            }
        }

        return false;
    }

    auto m_drawQueue = new DList!string;
    immutable char[] validInput = 
    [ 'q', '1', '2', '3', 'X', 'x', 'O', 'o' ];
}