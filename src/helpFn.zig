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
// │         │╭─────╮│         │
// │         ││ SOL ││         │
// │         ││ ITA ││         │
// │         ││ IRE ││         │
// │         │╰─────╯│         │
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

// function return a string based on the card value/shape ID input
// helps with printing cards
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

// prints the labels above cards
pub fn topLabels() void {
    std.debug.print("                                    ╭───────────────────── 0 ─────────────────────╮\n╭─── 8 ───╮ ", .{});

    var gap: usize = 0;
    for (0..3) |row| {
        if (main.top_field[row][1].value != @intFromEnum(main.Value.joker)) gap += 1;
    }

    switch (gap) {
        0, 1 => {},
        2 => std.debug.print("   ", .{}),
        else => std.debug.print("      ", .{}),
    }
    std.debug.print("╭─── 9 ───╮ ", .{});
    switch (gap) {
        0, 1 => std.debug.print("            ", .{}),
        2 => std.debug.print("         ", .{}),
        else => std.debug.print("      ", .{}),
    }

    std.debug.print("╭─── 1 ───╮ ╭─── 2 ───╮ ╭─── 3 ───╮ ╭─── 4 ───╮\n", .{});
}

pub fn bottomLabels() void {
    std.debug.print("╭─── 1 ───╮ ╭─── 2 ───╮ ╭─── 3 ───╮ ╭─── 4 ───╮ ╭─── 5 ───╮ ╭─── 6 ───╮ ╭─── 7 ───╮ \n", .{});
}

// function that get user input and stores it
pub fn getNum() !u8 {
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
                        error.InvalidCharacter => "INVALID INPUT, TRY AGAIN: ",
                        error.Overflow => "INVALID INPUT, TRY AGAIN: ",
                    };
                    std.debug.print("{s}", .{error_message});
                }
            } else {
                const parse_result = std.fmt.parseInt(u8, user_input, 10);

                // if inser input is valid return it
                if (parse_result) |num| {
                    return num;

                    // else print an error message and prompt user to try again
                } else |err| {
                    const error_message: []const u8 = switch (err) {
                        error.InvalidCharacter => "INVALID INPUT, TRY AGAIN: ",
                        error.Overflow => "INVALID INPUT, TRY AGAIN: ",
                    };
                    std.debug.print("{s}", .{error_message});
                }
            }
            // if inser input is valid return it
            // if (parse_result) |num| {
            //     return num;
            //     // else print an error message and prompt user to try again
            // } else |err| {
            //     const error_message: []const u8 = switch (err) {
            //         error.InvalidCharacter => "INVALID INPUT, TRY AGAIN: ",
            //         error.Overflow => "INVALID INPUT, TRY AGAIN: ",
            //     };
            //     std.debug.print("{s}", .{error_message});
            // }
        } else {
            return @as(u8, 0);
        }
    }
}
