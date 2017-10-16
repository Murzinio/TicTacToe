/// Convenient additions to std library function.
module stdext;

import std.conv;
import std.string;

/// Char overload for std.string.isNumeric.
bool isNumeric(char c)
{
    return std.string.isNumeric(to!string(c), false);
}

/// Converts char to integer matching the char, i.e. '42' to 42. 
int charNum(char c)
{
    return c - '0';
}