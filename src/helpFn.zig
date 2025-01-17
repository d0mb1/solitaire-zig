// function return a string based on the card value/shape ID input
// helps with printing cards
pub fn usizeToValue(value: usize) []const u8 {
    return switch (value) {
        0 => "X", // empty card that'll represent and empty space
        1 => "A",
        2 => "2",
        3 => "3",
        4 => "4",
        5 => "5",
        6 => "6",
        7 => "7",
        8 => "8",
        9 => "9",
        10 => "10",
        11 => "J",
        12 => "Q",
        13 => "K",
        else => unreachable,
    };
}
pub fn usizeToShape(shape: usize) []const u8 {
    return switch (shape) {
        0 => "󰣐", // hearts
        1 => "󰣑", // spades
        2 => "󰣏", // diamonds
        3 => "󰣎", // clubs
        else => unreachable,
    };
}

// checks if the card is red
pub fn isRed(shape: usize) bool {
    if (0 == shape % 2) return true else return false;
}
// checks if the card is visible
pub fn isVisible(visibility: usize) bool {
    if (0 == visibility % 2) return false else return true;
}
