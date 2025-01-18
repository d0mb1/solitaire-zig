const std = @import("std");

// ╭─────────╮
// │ 󰣑 󰣏 󰣐 󰣎 │
// ╰─────────╯
// ╭─  ───  ─╮
//   ∷∷∷∷∷∷∷
// │ ∷∷∷∷∷∷∷ │
//   ∷∷∷∷∷∷∷
// │ ∷∷∷∷∷∷∷ │
//   ∷∷∷∷∷∷∷
// ╰─  ───  ─╯
// ╭─────────╮ ╭─────────╮
// │         │ │         │
// │         │ │         │
// │         │ │         │
// │         │ │         │
// │         │ │         │
// ╰─────────╯ ╰─────────╯
// ╭──╭──╭──╭──╭─────────╮
// │ 8│10│ 3│ Q│ A     󰣎 │
// │  │  │  │  │         │
// │  │  │  │  │    󰣎    │
// │  │  │  │  │         │
// │ 󰣏│ 󰣐│ 󰣎│ 󰣏│ 󰣎     A │
// ╰──╰──╰──╰──╰─────────╯

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

// prints the game logo
pub fn printLogo(part_of_card: usize) void {
    switch (part_of_card) {
        0 => std.debug.print("\x1b[31m╭─────────╮\x1b[0m ", .{}),
        1 => std.debug.print("\x1b[31m│ 󰣐\x1b[0m     󰣑 \x1b[31m│\x1b[0m ", .{}),
        2 => std.debug.print("\x1b[31m│\x1b[0m  S \x1b[31mO\x1b[0m L  \x1b[31m│\x1b[0m ", .{}),
        3 => std.debug.print("\x1b[31m│  I\x1b[0m T \x1b[31mA  │\x1b[0m ", .{}),
        4 => std.debug.print("\x1b[31m│\x1b[0m  I \x1b[31mR\x1b[0m E  \x1b[31m│\x1b[0m ", .{}),
        5 => std.debug.print("\x1b[31m│\x1b[0m 󰣎     \x1b[31m󰣏 │\x1b[0m ", .{}),
        6 => std.debug.print("\x1b[31m╰─────────╯\x1b[0m ", .{}),
        else => unreachable,
    }
}

pub fn topLabels() void {
    std.debug.print("╭───────────────────── 8 ─────────────────────╮\n╭─── 1 ───╮ ╭─── 2 ───╮ ╭─── 3 ───╮ ╭─── 4 ───╮             ╭─── 9 ───╮ ╭─── 0 ───╮\n", .{});
}

pub fn bottomLabels() void {
    std.debug.print("╭─── 1 ───╮ ╭─── 2 ───╮ ╭─── 3 ───╮ ╭─── 4 ───╮ ╭─── 5 ───╮ ╭─── 6 ───╮ ╭─── 7 ───╮ \n", .{});
}
