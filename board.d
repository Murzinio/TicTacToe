module board;
import io;
import std.conv;

/// Board field values, empty by default.
enum FieldValue
{
    EMPTY = '-',
    X = 'X',
    O = 'O'
}
/// Manages game board;
class Board
{
public:
    this ()
    {
        foreach(row; m_fields)
        {
            foreach(elem; row)
            {
                elem = FieldValue.X;
            }
        }
    }

    /// Calls io to draw the board
    void draw()
    {
        foreach(row; m_fields)
        {
            char[] rowStr = new char[3];
            foreach(i; 0 .. rowStr.length)
            {
                rowStr[i] = row[i];
            }

            m_io.addToQueue(to!string(rowStr));
        }
    }

    /// Sets field on (x, y) to specified value.
    void setField(immutable int x, immutable int y, FieldValue value)
    {
        switch(value)
        {
            case FieldValue.X:
                m_fields[x][y] = FieldValue.X; 
                break;

            case FieldValue.O:
                m_fields[x][y] = FieldValue.O;
                break;
                
            default:
                break;
        }
    }

private:
    FieldValue[3][3] m_fields =
    [
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY],
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY],
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY]
    ];

    auto m_io = new Io();
}