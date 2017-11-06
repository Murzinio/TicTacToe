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
    this()
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

    bool columnEqual(size_t columnNumber)
    {
        for (size_t i; i < m_fields[0].length; ++i)
        {
            if (m_fields[columnNumber][i] == FieldValue.EMPTY)
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

        if (firstDiagonalFilled)
        {
            secondEqual =
            (m_fields[0][2] == m_fields[1][1]
            && m_fields[1][1] == m_fields[2][0]);
        }
        
        return firstEqual || secondEqual;
    }

    FieldValue[3][3] m_fields =
    [
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY],
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY],
        [FieldValue.EMPTY, FieldValue.EMPTY, FieldValue.EMPTY]
    ];

    auto m_io = new Io();

    @safe unittest
    {
        auto board = new Board;

        board.setField(tuple(2, 2), FieldValue.O);
        assert(board.m_fields[2][2] ==  FieldValue.O, "invalid field set in setField");

        assert(!board.areAllFieldsFilled(),
        "Not all fields should be filled!");

        foreach(ref row; board.m_fields)
        {
            foreach(ref field; row)
            {
                field = FieldValue.X;
            }
        }

        assert(board.areAllFieldsFilled(),
        "All fields should be filled!");

        board.setField([1, 0], FieldValue.O);
        board.setField([1, 1], FieldValue.O);
        board.setField([1, 2], FieldValue.O);

        assert(board.rowEqual(1),
        "Row not equal to values set!");
    }
}