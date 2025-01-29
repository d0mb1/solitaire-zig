const std = @import("std");
const builtin = @import("builtin");
const main = @import("main.zig");
const printCard = @import("printCard.zig");
const stdin = std.io.getStdIn().reader();

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
// ╭─────────╮       ╭─────────╮
// │         │╭─────╮│         │ M
// │         ││ SOL ││         │ O
// │         ││ ITA ││         │ V
// │         ││ IRE ││         │ E
// │         │╰─────╯│         │ S
// ╰─────────╯       ╰─────────╯
// ╭──╭──╭──╭──╭─────────╮
// │ 8│10│ 3│ Q│ A     󰣎 │
// │  │  │  │  │         │
// │  │  │  │  │    󰣎    │
// │  │  │  │  │         │
// │ 󰣏│ 󰣐│ 󰣎│ 󰣏│ 󰣎     A │
// ╰──╰──╰──╰──╰─────────╯
// SOL
// ITA
// IRE
// ╭─────────╮╭─────────╮╭─────────╮      ╭─────────╮╭─────────╮╭─────────╮╭─────────╮
// │ Y     󰣏 ││ O     󰣎 ││ U     󰣐 │      │ W     󰣑 ││ O     󰣏 ││ N     󰣎 ││ !     󰣐 │
// │         ││         ││         │      │         ││         ││         ││         │
// │    󰣏    ││    󰣎    ││    󰣐    │      │    󰣑    ││    󰣏    ││    󰣎    ││    󰣐    │
// │         ││         ││         │      │         ││         ││         ││         │
// │ 󰣏     Y ││ 󰣎     O ││ 󰣐     U │      │ 󰣑     W ││ 󰣏     O ││ 󰣎     N ││ 󰣐     ! │
// ╰─────────╯╰─────────╯╰─────────╯      ╰─────────╯╰─────────╯╰─────────╯╰─────────╯

pub fn winningMessage() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("╭─────────╮╭─────────╮╭─────────╮      ╭─────────╮╭─────────╮╭─────────╮╭─────────╮\n", .{});
    try stdout.print("│ \x1b[31mY     󰣏\x1b[0m ││ O     󰣎 ││ \x1b[31mU     󰣐\x1b[0m │      │ W     󰣑 ││ \x1b[31mI     󰣏\x1b[0m ││ N     󰣎 ││ \x1b[31m!     󰣐\x1b[0m │\n", .{});
    try stdout.print("│         ││         ││         │      │         ││         ││         ││         │\n", .{});
    try stdout.print("│    \x1b[31m󰣏\x1b[0m    ││    󰣎    ││    \x1b[31m󰣐\x1b[0m    │      │    󰣑    ││    \x1b[31m󰣏\x1b[0m    ││    󰣎    ││    \x1b[31m󰣐\x1b[0m    │\n", .{});
    try stdout.print("│         ││         ││         │      │         ││         ││         ││         │\n", .{});
    try stdout.print("│ \x1b[31m󰣏     Y\x1b[0m ││ 󰣎     O ││ \x1b[31m󰣐     U\x1b[0m │      │ 󰣑     W ││ \x1b[31m󰣏     I\x1b[0m ││ 󰣎     N ││ \x1b[31m󰣐     !\x1b[0m │\n", .{});
    try stdout.print("╰─────────╯╰─────────╯╰─────────╯      ╰─────────╯╰─────────╯╰─────────╯╰─────────╯\n", .{});
}

// function return a string based on the card value/shape ID input helps with
// printing cards
pub fn usizeToValue(card: main.Card, possition: bool) []const u8 {
    if (isRed(card.shape)) {

        // for some reason I have to check which part of the card is being
        // printed because the ANSI escape codes change the position of the
        // value
        if (possition) {
            return switch (card.value) {
                0 => "X", // empty card that'll represent and empty space
                1 => "\x1b[31m A\x1b[0m",
                2 => "\x1b[31m 2\x1b[0m",
                3 => "\x1b[31m 3\x1b[0m",
                4 => "\x1b[31m 4\x1b[0m",
                5 => "\x1b[31m 5\x1b[0m",
                6 => "\x1b[31m 6\x1b[0m",
                7 => "\x1b[31m 7\x1b[0m",
                8 => "\x1b[31m 8\x1b[0m",
                9 => "\x1b[31m 9\x1b[0m",
                10 => "\x1b[31m10\x1b[0m",
                11 => "\x1b[31m J\x1b[0m",
                12 => "\x1b[31m Q\x1b[0m",
                13 => "\x1b[31m K\x1b[0m",
                else => unreachable,
            };
        } else {
            return switch (card.value) {
                0 => "X", // empty card that'll represent and empty space
                1 => "\x1b[31mA \x1b[0m",
                2 => "\x1b[31m2 \x1b[0m",
                3 => "\x1b[31m3 \x1b[0m",
                4 => "\x1b[31m4 \x1b[0m",
                5 => "\x1b[31m5 \x1b[0m",
                6 => "\x1b[31m6 \x1b[0m",
                7 => "\x1b[31m7 \x1b[0m",
                8 => "\x1b[31m8 \x1b[0m",
                9 => "\x1b[31m9 \x1b[0m",
                10 => "\x1b[31m10\x1b[0m",
                11 => "\x1b[31mJ \x1b[0m",
                12 => "\x1b[31mQ \x1b[0m",
                13 => "\x1b[31mK \x1b[0m",
                else => unreachable,
            };
        }
    } else {
        return switch (card.value) {
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
}

// transers usize to string
pub fn usizeToShape(card: main.Card) []const u8 {
    if (isRed(card.shape)) {
        return switch (card.shape) {
            0 => "\x1b[31m󰣐\x1b[0m", // hearts
            1 => "\x1b[31m󰣑\x1b[0m", // spades
            2 => "\x1b[31m󰣏\x1b[0m", // diamonds
            3 => "\x1b[31m󰣎\x1b[0m", // clubs
        };
    } else {
        return switch (card.shape) {
            0 => "󰣐", // hearts
            1 => "󰣑", // spades
            2 => "󰣏", // diamonds
            3 => "󰣎", // clubs
        };
    }
}

// checks if the card is red
pub fn isRed(shape: usize) bool {
    if (0 == shape % 2) return true else return false;
}

// checks if the card is visible
pub fn isVisible(visibility: usize) bool {
    if (0 == visibility % 2) return false else return true;
}

// prints the labels above top field
pub fn topLabels() !void {
    const stdout = std.io.getStdOut().writer();
    var message: []const u8 = undefined;
    switch (isWinnable()) {
        true => {
            switch (isWon()) {
                true => message = "",
                false => message = "WINNABLE!!!",
            }
        },
        false => message = "",
    }
    try stdout.print("\x1b[31mMOVES: {: >4}             {s: >11} ╭─────────────────────\x1b[0m 0 \x1b[31m─────────────────────╮\n╭───\x1b[0m 8 \x1b[31m───╮ ", .{ main.moves, message });

    var gap: usize = 0;
    for (0..3) |row| {
        if (main.top_field[row][1].value != @intFromEnum(main.Value.joker)) gap += 1;
    }

    switch (gap) {
        0, 1 => {},
        2 => try stdout.print("   ", .{}),
        else => try stdout.print("      ", .{}),
    }
    try stdout.print("╭───\x1b[0m 9 \x1b[31m───╮ ", .{});
    switch (gap) {
        0, 1 => try stdout.print("            ", .{}),
        2 => try stdout.print("         ", .{}),
        else => try stdout.print("      ", .{}),
    }

    try stdout.print("├───\x1b[0m 1 \x1b[31m───╮ ╭───\x1b[0m 2 \x1b[31m───╮ ╭───\x1b[0m 3 \x1b[31m───╮ ╭───\x1b[0m 4 \x1b[31m───┤\x1b[0m\n", .{});
}

// prints the labels above bottom field
pub fn bottomLabels() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("\x1b[31m╭───\x1b[0m 1 \x1b[31m───╮ ╭───\x1b[0m 2 \x1b[31m───╮ ╭───\x1b[0m 3 \x1b[31m───╮ ╭───\x1b[0m 4 \x1b[31m───╮ ╭───\x1b[0m 5 \x1b[31m───╮ ╭───\x1b[0m 6 \x1b[31m───╮ ╭───\x1b[0m 7 \x1b[31m───╮\x1b[0m\n", .{});
}

// function that get user intiger input and returns it
pub fn getNum() !u8 {
    const stdout = std.io.getStdOut().writer();
    var buffer: [100]u8 = undefined;

    // loop that will keep asking for input if the previous one was invalid
    while (true) {
        if (try std.io.getStdIn().reader().readUntilDelimiterOrEof(buffer[0..], '\n')) |user_input| {
            if (builtin.target.os.tag == .windows) {
                const line = std.mem.trimRight(u8, user_input[0 .. user_input.len - 1], "\r");
                const parse_result = std.fmt.parseInt(u8, line, 10);

                // if inser input is valid return it
                if (parse_result) |num| {
                    return num;

                    // else print an error message and prompt user to try again
                } else |err| {
                    const error_message: []const u8 = switch (err) {
                        error.InvalidCharacter => "▶ INVALID INPUT, TRY AGAIN\t\t\t\t▶ ",
                        error.Overflow => "▶ INVALID INPUT, TRY AGAIN\t\t\t\t▶ ",
                    };
                    try stdout.print("{s}", .{error_message});
                }
            } else {
                const parse_result = std.fmt.parseInt(u8, user_input, 10);

                // if inser input is valid return it
                if (parse_result) |num| {
                    return num;

                    // else print an error message and prompt user to try again
                } else |err| {
                    const error_message: []const u8 = switch (err) {
                        error.InvalidCharacter => "▶ INVALID INPUT, TRY AGAIN\t\t\t\t▶ ",
                        error.Overflow => "▶ INVALID INPUT, TRY AGAIN\t\t\t\t▶ ",
                    };
                    try stdout.print("{s}", .{error_message});
                }
            }
        } else {
            return @as(u8, 0);
        }
    }
}

// // determines if the game is winnable / there are no covered cards left
fn isWinnable() bool {
    var uncovered_cards: usize = 0;

    // checks the top field
    for (main.top_field) |row| {
        for (row, 0..) |card, i| {
            if (card.visivility == @intFromEnum(main.Visibility.uncovered) and card.value != @intFromEnum(main.Value.joker)) uncovered_cards += 1;
            if (card.visivility == @intFromEnum(main.Visibility.covered) and card.value != @intFromEnum(main.Value.joker) and i == 0) uncovered_cards += 1;
        }
    }

    // checks the bottom field
    for (main.bottom_field) |row| {
        for (row) |card| {
            if (card.visivility == @intFromEnum(main.Visibility.uncovered) and card.value != @intFromEnum(main.Value.joker)) uncovered_cards += 1;
        }
    }

    if (uncovered_cards == 52) return true else return false;
}

pub fn isWon() bool {
    var cards_in_final_decks: usize = 0;

    for (0..13) |row| {
        for (2..6) |column| {
            if (main.top_field[row][column].value != @intFromEnum(main.Value.joker)) cards_in_final_decks += 1;
        }
    }
    if (cards_in_final_decks == 52) return true else return false;
}
