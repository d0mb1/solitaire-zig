const std = @import("std");
const builtin = @import("builtin");
const m = @import("main.zig");
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
    try stdout.print("│ " ++ m.RED ++ "Y     󰣏" ++ m.RESET ++ " ││ O     󰣎 ││ " ++ m.RED ++ "U     󰣐" ++ m.RESET ++ " │      │ W     󰣑 ││ " ++ m.RED ++ "I     󰣏" ++ m.RESET ++ " ││ N     󰣎 ││ " ++ m.RED ++ "!     󰣐" ++ m.RESET ++ " │\n", .{});
    try stdout.print("│         ││         ││         │      │         ││         ││         ││         │\n", .{});
    try stdout.print("│    " ++ m.RED ++ "󰣏" ++ m.RESET ++ "    ││    󰣎    ││    " ++ m.RED ++ "󰣐" ++ m.RESET ++ "    │      │    󰣑    ││    " ++ m.RED ++ "󰣏" ++ m.RESET ++ "    ││    󰣎    ││    " ++ m.RED ++ "󰣐" ++ m.RESET ++ "    │\n", .{});
    try stdout.print("│         ││         ││         │      │         ││         ││         ││         │\n", .{});
    try stdout.print("│ " ++ m.RED ++ "󰣏     Y" ++ m.RESET ++ " ││ 󰣎     O ││ " ++ m.RED ++ "󰣐     U" ++ m.RESET ++ " │      │ 󰣑     W ││ " ++ m.RED ++ "󰣏     I" ++ m.RESET ++ " ││ 󰣎     N ││ " ++ m.RED ++ "󰣐     !" ++ m.RESET ++ " │\n", .{});
    try stdout.print("╰─────────╯╰─────────╯╰─────────╯      ╰─────────╯╰─────────╯╰─────────╯╰─────────╯\n", .{});
}

// function return a string based on the card value/shape ID input helps with
// printing cards
pub fn valueString(card: m.Card, possition: m.SymbolPosition) []const u8 {
    if (card.isRed()) {

        // for some reason I have to check which part of the card is being
        // printed because the ANSI escape codes change the position of the
        // value
        return switch (possition) {
            .top => switch (card.value) {
                .joker => "X", // empty card that'll represent and empty space
                .ace => m.RED ++ " A" ++ m.RESET,
                .two => m.RED ++ " 2" ++ m.RESET,
                .three => m.RED ++ " 3" ++ m.RESET,
                .four => m.RED ++ " 4" ++ m.RESET,
                .five => m.RED ++ " 5" ++ m.RESET,
                .six => m.RED ++ " 6" ++ m.RESET,
                .seven => m.RED ++ " 7" ++ m.RESET,
                .eight => m.RED ++ " 8" ++ m.RESET,
                .nine => m.RED ++ " 9" ++ m.RESET,
                .ten => m.RED ++ "10" ++ m.RESET,
                .jack => m.RED ++ " J" ++ m.RESET,
                .queen => m.RED ++ " Q" ++ m.RESET,
                .king => m.RED ++ " K" ++ m.RESET,
            },
            .bottom => switch (card.value) {
                .joker => "X", // empty card that'll represent and empty space
                .ace => m.RED ++ "A " ++ m.RESET,
                .two => m.RED ++ "2 " ++ m.RESET,
                .three => m.RED ++ "3 " ++ m.RESET,
                .four => m.RED ++ "4 " ++ m.RESET,
                .five => m.RED ++ "5 " ++ m.RESET,
                .six => m.RED ++ "6 " ++ m.RESET,
                .seven => m.RED ++ "7 " ++ m.RESET,
                .eight => m.RED ++ "8 " ++ m.RESET,
                .nine => m.RED ++ "9 " ++ m.RESET,
                .ten => m.RED ++ "10" ++ m.RESET,
                .jack => m.RED ++ "J " ++ m.RESET,
                .queen => m.RED ++ "Q " ++ m.RESET,
                .king => m.RED ++ "K " ++ m.RESET,
            },
        };
    } else {
        return switch (card.value) {
            .joker => "X", // empty card that'll represent and empty space
            .ace => "A",
            .two => "2",
            .three => "3",
            .four => "4",
            .five => "5",
            .six => "6",
            .seven => "7",
            .eight => "8",
            .nine => "9",
            .ten => "10",
            .jack => "J",
            .queen => "Q",
            .king => "K",
        };
    }
}

// transers usize to string
pub fn shapeString(card: m.Card) []const u8 {
    return switch (card.shape) {
        .hearts => m.RED ++ "󰣐" ++ m.RESET, // hearts
        .spades => "󰣑", // spades
        .diamonds => m.RED ++ "󰣏" ++ m.RESET, // diamonds
        .clubs => "󰣎", // clubs
    };
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
    try stdout.print(m.RED ++ "MOVES: {: >4}             {s: >11} ", .{ m.moves, message });
    try stdout.print("╭───────────────────── " ++ m.RESET ++ "0" ++ m.RED ++ " ─────────────────────╮\n", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "8" ++ m.RED ++ " ───╮ ", .{});

    var gap: usize = 0;
    for (0..3) |row| {
        if (!m.top_field[row][1].isJoker()) gap += 1;
    }

    // because when there are more cards in stack 9 the cards spread out
    // so we need to move the label 9 too
    switch (gap) {
        0, 1 => {},
        2 => try stdout.print("   ", .{}),
        else => try stdout.print("      ", .{}),
    }
    try stdout.print("╭─── " ++ m.RESET ++ "9" ++ m.RED ++ " ───╮ ", .{});
    switch (gap) {
        0, 1 => try stdout.print("            ", .{}),
        2 => try stdout.print("         ", .{}),
        else => try stdout.print("      ", .{}),
    }

    try stdout.print("├─── " ++ m.RESET ++ "1" ++ m.RED ++ " ───╮ ╭─── " ++ m.RESET ++ "2" ++ m.RED ++ " ───╮ ", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "3" ++ m.RED ++ " ───╮ ╭─── " ++ m.RESET ++ "4" ++ m.RED ++ " ───┤" ++ m.RESET ++ "\n", .{});
}

// prints the labels above bottom field
pub fn bottomLabels() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print(m.RED ++ "╭─── " ++ m.RESET ++ "1" ++ m.RED ++ " ───╮ ", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "2" ++ m.RED ++ " ───╮ ", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "3" ++ m.RED ++ " ───╮ ", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "4" ++ m.RED ++ " ───╮ ", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "5" ++ m.RED ++ " ───╮ ", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "6" ++ m.RED ++ " ───╮ ", .{});
    try stdout.print("╭─── " ++ m.RESET ++ "7" ++ m.RED ++ " ───╮ \n" ++ m.RESET, .{});
}

// function that gets user intiger input and returns it
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
pub fn isWinnable() bool {
    var uncovered_cards: usize = 0;

    // checks the top field
    for (m.top_field) |row| {
        for (row, 0..) |card, i| {
            if (card.visible == true and !card.isJoker()) uncovered_cards += 1;
            if (card.visible == false and !card.isJoker() and i == 0) uncovered_cards += 1;
        }
    }

    // checks the bottom field
    for (m.bottom_field) |row| {
        for (row) |card| {
            if (card.visible == true and !card.isJoker()) uncovered_cards += 1;
        }
    }

    if (uncovered_cards == 52) return true else return false;
}

// when all cards are in the final deck
pub fn isWon() bool {
    var cards_in_final_decks: usize = 0;

    for (0..13) |row| {
        for (2..6) |column| {
            if (!m.top_field[row][column].isJoker()) cards_in_final_decks += 1;
        }
    }
    if (cards_in_final_decks == 52) return true else return false;
}
