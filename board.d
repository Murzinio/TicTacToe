module board;
@safe:

import io;
import std.conv;
import std.typecons;

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

    /// Check if field can be set
    bool isFieldAvailable(T)(T field)
    {
        return m_fields[field[0]][field[1]] == FieldValue.EMPTY;
    }

    /// Sets field on (x, y) to specified value.
    void setField(T)(T field, FieldValue value)
    {
        switch(value)
        {
            case FieldValue.X:
                m_fields[field[0]][field[1]] = FieldValue.X; 
                break;

            case FieldValue.O:
                m_fields[field[0]][field[1]] = FieldValue.O;
                break;
                
            default:
                break;
        }
    }

    unittest
    {
        auto board = new Board; 
        board.setField(tuple(2, 2), FieldValue.O);
        assert(board.m_fields[2][2] ==  FieldValue.O,
         "Field set to value different than expected!");
    }
        
    /// Returns true if all fields are non-empty.
    bool areAllFieldsFilled()
    {
        foreach(row; m_fields)
        {
            foreach(field; row)
            {
                if (field == FieldValue.EMPTY)
                {
                    return false;
                }
            }
        }

        return true;
    }

    unittest
    {
        auto board = new Board;
        
        assert(!board.areAllFieldsFilled,
        "Expected empty fields!");

        foreach(ref row; board.m_fields)
        {
            foreach(ref field; row)
            {
                field = FieldValue.X;
            }
        }

        assert(board.areAllFieldsFilled(),
        "Expected all fields filled!");
    }

    /// Returns true if any three adjacent fields (vertical, horizontal or diagonal)
    /// Are equal to value
    bool anyThreeAdjacentFieldsEqual()
    {
        for (size_t i; i < m_fields.length; ++i)
        {
            if (rowEqual(i))
            {
                return true;
            }
        }

        for (size_t i; i < m_fields[0].length; ++i)
        {
            if (columnEqual(i))
            {
                return true;
            }
        }

        return anyDiagonalEqual();
    }

private:
    bool rowEqual(size_t rowNumber)
    {
        const FieldValue[] row = m_fields[rowNumber];
        
        foreach(const ref field; row)
        {
            if (field == FieldValue.EMPTY)
            {
                return false;
            }
        }
        
        if (row[0] != row[1]
        || row[2] != row[2])
        {
            return false;
        }

        return true;
    }

    unittest
    {
        auto board = new Board;

        board.setField([1, 0], FieldValue.O);
        board.setField([1, 1], FieldValue.O);
        board.setField([1, 2], FieldValue.O);

        assert(board.rowEqual(1),
        "Expected equal row!");
    }

    bool columnEqual(size_t columnNumber)
    {
        for (size_t i; i < m_fields[0].length; ++i)
        {
            if (m_fields[i][columnNumber] == FieldValue.EMPTY)
            {
                return false;
            }
        }

        if (m_fields[0][columnNumber] != m_fields[1][columnNumber]
        || m_fields[1][columnNumber] != m_fields[2][columnNumber])
        {
            return false;
        }

        return true;
    }

    unittest
    {
        auto board = new Board;

        board.m_fields[0][0] = FieldValue.X;
        board.m_fields[1][0] = FieldValue.X;
        board.m_fields[2][0] = FieldValue.X;

        assert(board.columnEqual(0),
        "Expected equal column!");
    }

    bool firstDiagonalFilled()
    {
        if (!isFieldAvailable([0, 0])
        && !isFieldAvailable([1, 1])
        && !isFieldAvailable([2, 2]))
        {
            return true;
        }

        return false;
    }

    bool secondDiagonalFilled()
    {
        if (!isFieldAvailable([0, 2])
        && !isFieldAvailable([1, 1])
        && !isFieldAvailable([2, 0]))
        {
            return true;
        }

        return false;
    }

    bool anyDiagonalEqual()
    {
        bool firstEqual;

        if (firstDiagonalFilled)
        {
            firstEqual =
            (m_fields[0][0] == m_fields[1][1]
            && m_fields[1][1] == m_fields[2][2]);
        }
        
        bool secondEqual;

        if (secondDiagonalFilled)
        {
            secondEqual =
            (m_fields[0][2] == m_fields[1][1]
            && m_fields[1][1] == m_fields[2][0]);
        }
        
        return firstEqual || secondEqual;
    }

    unittest
    {
        auto board = new Board;

        board.m_fields[0][2] = FieldValue.X;
        board.m_fields[1][1] = FieldValue.X;
        board.m_fields[2][0] = FieldValue.X;

        assert(board.anyDiagonalEqual(),
        "Expect equal diagonal!");
    }

    FieldValue[3][3] m_fields =
    [
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY],
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY],
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY]
    ];

    auto m_io = new Io();
}