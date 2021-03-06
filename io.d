module io;
@safe:

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
    void addToQueue(T)(T elem)
    {
        m_drawQueue.insertBack(to!(string)(elem));
    }

    @system unittest
    {
        auto io = new Io;

        immutable char[] charLine = "charline";
        io.addToQueue(charLine);

        string stringLine = "stringLine";
        io.addToQueue(stringLine);

        assert(io.m_drawQueue.back() == stringLine,
        "Queue line different than expected!
        Expected: '" ~ stringLine ~ "', Got: '" ~ io.m_drawQueue.back() ~ "'");
        io.m_drawQueue.removeBack();

        assert(io.m_drawQueue.back() == charLine,
        "Queue line different than expected!
        Expected: '" ~ charLine ~ "', Got: '" ~ io.m_drawQueue.back() ~ "'");
        io.m_drawQueue.removeBack();

        assert(io.m_drawQueue.empty(),
        "Io m_drawQueue not empty!");
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
    @system string getInput()
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

    /// Clear queue;
    void clearQueue()
    {
        m_drawQueue.clear();
    }

private:
    @system bool isInputValid(string input)
    {
        char[] convertedInput = to!(char[])(input);
        foreach(elem; validInput)
        {
            if (convertedInput[0] == elem)
            {
                if (isNumeric(convertedInput[0]) && isInRange(convertedInput[0]))
                {
                    if (!isNumeric(convertedInput[1]) || !isInRange(convertedInput[1]))
                    {
                        return false;
                    }
                }
                return true;
            }
        }

        return false;
    }

    @system unittest
    {
        auto io = new Io;
        
        string[] invalidInputs =
        [
            "abc", "a", "f",
            "456", "342342341", 
            "66", "9",
            "61", "16",
            "!", "*" 
        ];

        foreach(input; invalidInputs)
        {
            assert(!io.isInputValid(input),
            "Invalid input accepted!
            Input: '" ~ input ~ "'");
        }
    }

    bool isInRange(char numericInput)
    {
        foreach(elem; validInput)
        {
            if (elem == numericInput)
            {
                return true;
            }
        }

        return false;
    }

    unittest
    {
        auto io = new Io;

        assert(!io.isInRange(4),
        "Invalid numeric input range accepted!");
    }

    auto m_drawQueue = new DList!string;
    immutable char[] validInput = 
    [ 'q', '1', '2', '3', 'X', 'x', 'O', 'o' ];
}