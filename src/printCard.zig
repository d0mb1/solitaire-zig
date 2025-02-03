const std = @import("std");
const m = @import("main.zig");
const helpFn = @import("helpFn.zig");

pub fn topCardPrint() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("╭─────────╮ ", .{});
}

pub fn middleCardPrint(card: m.Card) !void {
    const stdout = std.io.getStdOut().writer();

    // checks if the card is visible
    if (card.visible) {
        try stdout.print("│         │ ", .{});
    } else {
        try stdout.print("│ ∷∷∷∷∷∷∷ │ ", .{});
    }
}

pub fn bottomCardPrint() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("╰─────────╯ ", .{});
}

// prints the outline of a card if the spot is empty
pub fn emptySpacePrint(part_of_card: usize) !void {
    const stdout = std.io.getStdOut().writer();
    switch (part_of_card) {
        0 => try stdout.print("╭─  ───  ─╮ ", .{}),
        2, 4 => try stdout.print("│         │ ", .{}),
        6 => try stdout.print("╰─  ───  ─╯ ", .{}),
        else => try emptyPrint(),
    }
}

// prints empty space of card width size
pub fn emptyPrint() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("            ", .{});
}

pub fn topCardPrintSymbols(card: m.Card) !void {
    const stdout = std.io.getStdOut().writer();

    // checks if the card is visible
    if (card.visible) {

        // check what color should the output be
        try stdout.print("│{s: >2}     {s} │ ", .{
            helpFn.valueString(card, .top),
            helpFn.shapeString(card),
        });
    } else {
        try middleCardPrint(card);
    }
}

pub fn middleCardPrintSymbols(card: m.Card) !void {
    const stdout = std.io.getStdOut().writer();

    // checks if the card is visible
    if (card.visible) {

        // check what color should the output be
        try stdout.print("│    {s}    │ ", .{helpFn.shapeString(card)});
    } else {
        try middleCardPrint(card);
    }
}

pub fn bottomCardPrintSymbols(card: m.Card) !void {
    const stdout = std.io.getStdOut().writer();

    // checks if the card is visible
    if (card.visible) {

        // check what color should the output be
        try stdout.print("│ {s}     {s: <2}│ ", .{
            helpFn.shapeString(card),
            helpFn.valueString(card, .bottom),
        });
    } else {
        try middleCardPrint(card);
    }
}

// prints the bottom part of cards
pub fn restOfCardPrint(row: usize, column: usize, symbols: bool) !void {
    var index: usize = 0;

    // finding the top card in the stack and counting how many rows above it is
    while (m.bottom_field[row - index][column].value == @intFromEnum(m.Value.joker)) : (index += 1) {
        if (row - index == 0) {
            break;
        }
    }

    // findout if the funtion should print a symbol part of a card or not and
    // prints apropriately
    switch (symbols) {
        true => switch (index) {
            0 => try middleCardPrint(m.bottom_field[row - index][column]),
            1 => try middleCardPrintSymbols(m.bottom_field[row - index][column]),
            2 => try bottomCardPrintSymbols(m.bottom_field[row - index][column]),
            else => try emptyPrint(),
        },
        false => switch (index) {
            0...2 => try middleCardPrint(m.bottom_field[row - index][column]),
            3 => try bottomCardPrint(),
            else => try emptyPrint(),
        },
    }
}

// prints the bottom field
pub fn printBottomField() !void {
    const stdout = std.io.getStdOut().writer();

    // count downs to three and then stops print
    var count_down: usize = 0;

    // part of card keeps track of what part of card should be printed
    var part_of_card: usize = 0;

    // iterates over rows in the bottom field
    for (0..m.bottom_field.len) |row| {

        // counts how many spaces are empty on a row
        var empty_cards: usize = 0;

        // iterates over columns / cards in a row
        for (0..m.bottom_field[row].len) |column| {

            // checks if the card isn't joker (empty space)
            if (m.bottom_field[row][column].value != @intFromEnum(m.Value.joker)) {
                try topCardPrint();
            } else {

                // checks if the stack is empty
                if (m.bottom_field[0][column].value == @intFromEnum(m.Value.joker)) {

                    // if it's empty call a function that prints card outline
                    try emptySpacePrint(part_of_card);
                } else {
                    try restOfCardPrint(row, column, false);
                }
                empty_cards += 1;
            }
        }
        part_of_card += 1;

        // checks if the row is empty / there's only empty cards
        // (empty_cards = 7)
        if (empty_cards == m.num_of_bot_field_columns) {

            // if the whole row is empty adds 1 to a count down
            count_down += 1;
            if (count_down == 4) {

                // When count-down gets to 4 it breaks the loop preventing
                // the function from printing unnecessary rows.
                // It counts down to 4 because we need the print to finish
                // printing the bottom cards that are shown whole
                try stdout.print("\n", .{});
                break;
            }
        }
        try stdout.print("\n", .{});

        // iterates over columns / cards in a row
        for (0..m.bottom_field[row].len) |column| {

            // checks if the card isn't joker (empty space)
            if (m.bottom_field[row][column].value != @intFromEnum(m.Value.joker)) {
                try topCardPrintSymbols(m.bottom_field[row][column]);
            } else {

                // checks if the stack is empty
                if (m.bottom_field[0][column].value == @intFromEnum(m.Value.joker)) {

                    // is it's empty call a function that prints card outline
                    try emptySpacePrint(part_of_card);
                } else {
                    try restOfCardPrint(row, column, true);
                }
            }
        }
        part_of_card += 1;
        try stdout.print("\n", .{});
    }
}

// function that is very long but also very simple. When there's more cards in
// the 9th stack it will show 3 top most cards

// part_of_card represesnts which part of a card should be printed

// index represents how many cards are on the stack and determines what
// should be printed (0 to 3 depending on the index)
pub fn spreadCards(part_of_card: usize, index: usize) !void {
    const stdout = std.io.getStdOut().writer();
    switch (index) {
        0 => {
            try emptySpacePrint(part_of_card);
            try emptyPrint();
        },
        1 => {
            switch (part_of_card) {
                0 => {
                    try topCardPrint();
                    try emptyPrint();
                },
                1 => {
                    try topCardPrintSymbols(m.top_field[index - 1][1]);
                    try emptyPrint();
                },
                2, 4 => {
                    try middleCardPrint(m.top_field[index - 1][1]);
                    try emptyPrint();
                },
                3 => {
                    try middleCardPrintSymbols(m.top_field[index - 1][1]);
                    try emptyPrint();
                },
                5 => {
                    try bottomCardPrintSymbols(m.top_field[index - 1][1]);
                    try emptyPrint();
                },
                6 => {
                    try bottomCardPrint();
                    try emptyPrint();
                },
                else => unreachable,
            }
        },
        2 => {
            switch (part_of_card) {
                0 => {
                    try stdout.print("╭──", .{});
                    try topCardPrint();
                    try stdout.print("         ", .{});
                },
                1 => {
                    if (helpFn.isRed(m.top_field[index - 2][1].shape)) {
                        try stdout.print("│" ++ m.RED ++ "{s: >2}" ++ m.RESET, .{helpFn.valueString(m.top_field[index - 2][1], .top)});
                    } else {
                        try stdout.print("│{s: >2}", .{helpFn.valueString(m.top_field[index - 2][1], .top)});
                    }
                    try topCardPrintSymbols(m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                2, 4 => {
                    try stdout.print("│  ", .{});
                    try middleCardPrint(m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                3 => {
                    try stdout.print("│  ", .{});
                    try middleCardPrintSymbols(m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                5 => {
                    if (helpFn.isRed(m.top_field[index - 2][1].shape)) {
                        try stdout.print("│ " ++ m.RED ++ "{s}" ++ m.RESET, .{helpFn.shapeString(m.top_field[index - 2][1])});
                    } else {
                        try stdout.print("│ {s}", .{helpFn.shapeString(m.top_field[index - 2][1])});
                    }
                    try bottomCardPrintSymbols(m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                6 => {
                    try stdout.print("╰──", .{});
                    try bottomCardPrint();
                    try stdout.print("         ", .{});
                },
                else => unreachable,
            }
        },
        else => {
            switch (part_of_card) {
                0 => {
                    try stdout.print("╭──╭──", .{});
                    try topCardPrint();
                    try stdout.print("      ", .{});
                },
                1 => {
                    try stdout.print("│{s: >2}", .{helpFn.valueString(m.top_field[index - 3][1], .top)});
                    try stdout.print("│{s: >2}", .{helpFn.valueString(m.top_field[index - 2][1], .top)});
                    try topCardPrintSymbols(m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                2, 4 => {
                    try stdout.print("│  │  ", .{});
                    try middleCardPrint(m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                3 => {
                    try stdout.print("│  │  ", .{});
                    try middleCardPrintSymbols(m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                5 => {
                    try stdout.print("│ {s}", .{helpFn.shapeString(m.top_field[index - 3][1])});
                    try stdout.print("│ {s}", .{helpFn.shapeString(m.top_field[index - 2][1])});
                    try bottomCardPrintSymbols(m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                6 => {
                    try stdout.print("╰──╰──", .{});
                    try bottomCardPrint();
                    try stdout.print("      ", .{});
                },
                else => unreachable,
            }
        },
    }
}

// I know I can probably save the indexes in to an array and then print the
// cards which would be more effective since it wouldn't have to pass each
// column multiple times but this was easier
// TODO: Fix this later
pub fn printTopField() !void {
    const stdout = std.io.getStdOut().writer();
    var index: usize = 0;

    // there's 7 parts/rows to a card (top outline, top part with symbols,
    // top blank part, middle part with symbols, etc.). part_of_card keeps
    // track of which part should be printed
    var part_of_card: usize = 0;
    while (part_of_card < 7) : (part_of_card += 1) {
        for (0..m.top_field[0].len) |column| {
            while (m.top_field[index][column].value != @intFromEnum(m.Value.joker)) {
                index += 1;
            }
            if (column == 1) {
                try spreadCards(part_of_card, index);
            } else if (index == 0) {
                try emptySpacePrint(part_of_card);
            } else {
                switch (part_of_card) {
                    0 => try topCardPrint(),
                    1 => try topCardPrintSymbols(m.top_field[index - 1][column]),
                    2, 4 => try middleCardPrint(m.top_field[index - 1][column]),
                    3 => try middleCardPrintSymbols(m.top_field[index - 1][column]),
                    5 => try bottomCardPrintSymbols(m.top_field[index - 1][column]),
                    6 => try bottomCardPrint(),
                    else => unreachable,
                }
            }
            index = 0;
        }
        try stdout.print("\n", .{});
    }
}
