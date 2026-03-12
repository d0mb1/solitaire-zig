const std = @import("std");
const m = @import("main.zig");
const helpFn = @import("helpFn.zig");

pub fn topCardPrint(stdout: anytype) !void {
    try stdout.print("╭─────────╮ ", .{});
}

pub fn middleCardPrint(stdout: anytype, card: m.Card) !void {
    // checks if the card is visible
    if (card.visible) {
        try stdout.print("│         │ ", .{});
    } else {
        try stdout.print("│ ∷∷∷∷∷∷∷ │ ", .{});
    }
}

pub fn bottomCardPrint(stdout: anytype) !void {
    try stdout.print("╰─────────╯ ", .{});
}

// prints the outline of a card if the spot is empty
pub fn emptySpacePrint(stdout: anytype, part_of_card: usize) !void {
    switch (part_of_card) {
        0 => try stdout.print("╭─  ───  ─╮ ", .{}),
        2, 4 => try stdout.print("│         │ ", .{}),
        6 => try stdout.print("╰─  ───  ─╯ ", .{}),
        else => try emptyPrint(stdout),
    }
}

// prints empty space of card width size
pub fn emptyPrint(stdout: anytype) !void {
    try stdout.print("            ", .{});
}

pub fn topCardPrintSymbols(stdout: anytype, card: m.Card) !void {
    // checks if the card is visible
    if (card.visible) {

        // check what color should the output be
        try stdout.print("│{s: >2}     {s} │ ", .{
            helpFn.valueString(card, .top),
            helpFn.shapeString(card),
        });
    } else {
        try middleCardPrint(stdout, card);
    }
}

pub fn middleCardPrintSymbols(stdout: anytype, card: m.Card) !void {
    // checks if the card is visible
    if (card.visible) {

        // check what color should the output be
        try stdout.print("│    {s}    │ ", .{helpFn.shapeString(card)});
    } else {
        try middleCardPrint(stdout, card);
    }
}

pub fn bottomCardPrintSymbols(stdout: anytype, card: m.Card) !void {
    // checks if the card is visible
    if (card.visible) {

        // check what color should the output be
        try stdout.print("│ {s}     {s: <2}│ ", .{
            helpFn.shapeString(card),
            helpFn.valueString(card, .bottom),
        });
    } else {
        try middleCardPrint(stdout, card);
    }
}

// prints the bottom part of cards
pub fn restOfCardPrint(stdout: anytype, row: usize, column: usize, symbols: bool) !void {
    var index: usize = 0;

    // finding the top card in the stack and counting how many rows above it is
    while (m.bottom_field[row - index][column].isJoker()) : (index += 1) {
        if (row - index == 0) {
            break;
        }
    }

    // findout if the funtion should print a symbol part of a card or not and
    // prints apropriately
    switch (symbols) {
        true => switch (index) {
            0 => try middleCardPrint(stdout, m.bottom_field[row - index][column]),
            1 => try middleCardPrintSymbols(stdout, m.bottom_field[row - index][column]),
            2 => try bottomCardPrintSymbols(stdout, m.bottom_field[row - index][column]),
            else => try emptyPrint(stdout),
        },
        false => switch (index) {
            0...2 => try middleCardPrint(stdout, m.bottom_field[row - index][column]),
            3 => try bottomCardPrint(stdout),
            else => try emptyPrint(stdout),
        },
    }
}

// prints the bottom field
pub fn printBottomField(stdout: anytype) !void {
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
            if (!m.bottom_field[row][column].isJoker()) {
                try topCardPrint(stdout);
            } else {

                // checks if the stack is empty
                if (m.bottom_field[0][column].isJoker()) {

                    // if it's empty call a function that prints card outline
                    try emptySpacePrint(stdout, part_of_card);
                } else {
                    try restOfCardPrint(stdout, row, column, false);
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
            if (!m.bottom_field[row][column].isJoker()) {
                try topCardPrintSymbols(stdout, m.bottom_field[row][column]);
            } else {

                // checks if the stack is empty
                if (m.bottom_field[0][column].isJoker()) {

                    // is it's empty call a function that prints card outline
                    try emptySpacePrint(stdout, part_of_card);
                } else {
                    try restOfCardPrint(stdout, row, column, true);
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
pub fn spreadCards(stdout: anytype, part_of_card: usize, index: usize) !void {
    switch (index) {
        0 => {
            try emptySpacePrint(stdout, part_of_card);
            try emptyPrint(stdout);
        },
        1 => {
            switch (part_of_card) {
                0 => {
                    try topCardPrint(stdout);
                    try emptyPrint(stdout);
                },
                1 => {
                    try topCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try emptyPrint(stdout);
                },
                2, 4 => {
                    try middleCardPrint(stdout, m.top_field[index - 1][1]);
                    try emptyPrint(stdout);
                },
                3 => {
                    try middleCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try emptyPrint(stdout);
                },
                5 => {
                    try bottomCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try emptyPrint(stdout);
                },
                6 => {
                    try bottomCardPrint(stdout);
                    try emptyPrint(stdout);
                },
                else => unreachable,
            }
        },
        2 => {
            switch (part_of_card) {
                0 => {
                    try stdout.print("╭──", .{});
                    try topCardPrint(stdout);
                    try stdout.print("         ", .{});
                },
                1 => {
                    if ((m.top_field[index - 2][1].isRed())) {
                        try stdout.print("│" ++ m.RED ++ "{s: >2}" ++ m.RESET, .{helpFn.valueString(m.top_field[index - 2][1], .top)});
                    } else {
                        try stdout.print("│{s: >2}", .{helpFn.valueString(m.top_field[index - 2][1], .top)});
                    }
                    try topCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                2, 4 => {
                    try stdout.print("│  ", .{});
                    try middleCardPrint(stdout, m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                3 => {
                    try stdout.print("│  ", .{});
                    try middleCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                5 => {
                    if ((m.top_field[index - 2][1].isRed())) {
                        try stdout.print("│ " ++ m.RED ++ "{s}" ++ m.RESET, .{helpFn.shapeString(m.top_field[index - 2][1])});
                    } else {
                        try stdout.print("│ {s}", .{helpFn.shapeString(m.top_field[index - 2][1])});
                    }
                    try bottomCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try stdout.print("         ", .{});
                },
                6 => {
                    try stdout.print("╰──", .{});
                    try bottomCardPrint(stdout);
                    try stdout.print("         ", .{});
                },
                else => unreachable,
            }
        },
        else => {
            switch (part_of_card) {
                0 => {
                    try stdout.print("╭──╭──", .{});
                    try topCardPrint(stdout);
                    try stdout.print("      ", .{});
                },
                1 => {
                    try stdout.print("│{s: >2}", .{helpFn.valueString(m.top_field[index - 3][1], .top)});
                    try stdout.print("│{s: >2}", .{helpFn.valueString(m.top_field[index - 2][1], .top)});
                    try topCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                2, 4 => {
                    try stdout.print("│  │  ", .{});
                    try middleCardPrint(stdout, m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                3 => {
                    try stdout.print("│  │  ", .{});
                    try middleCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                5 => {
                    try stdout.print("│ {s}", .{helpFn.shapeString(m.top_field[index - 3][1])});
                    try stdout.print("│ {s}", .{helpFn.shapeString(m.top_field[index - 2][1])});
                    try bottomCardPrintSymbols(stdout, m.top_field[index - 1][1]);
                    try stdout.print("      ", .{});
                },
                6 => {
                    try stdout.print("╰──╰──", .{});
                    try bottomCardPrint(stdout);
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
pub fn printTopField(stdout: anytype) !void {
    var row: usize = 0;

    // there's 7 parts/rows to a card (top outline, top part with symbols,
    // top blank part, middle part with symbols, etc.). part_of_card keeps
    // track of which part should be printed
    var part_of_card: usize = 0;
    while (part_of_card < 7) : (part_of_card += 1) {
        for (0..m.top_field[0].len) |column| {
            while (row < m.num_of_bot_field_rows and !m.top_field[row][column].isJoker()) {
                row += 1;
            }
            if (column == 1) {
                try spreadCards(stdout, part_of_card, row);
            } else if (row == 0) {
                try emptySpacePrint(stdout, part_of_card);
            } else {
                switch (part_of_card) {
                    0 => try topCardPrint(stdout),
                    1 => try topCardPrintSymbols(stdout,m.top_field[row - 1][column]),
                    2, 4 => try middleCardPrint(stdout, m.top_field[row - 1][column]),
                    3 => try middleCardPrintSymbols(stdout, m.top_field[row - 1][column]),
                    5 => try bottomCardPrintSymbols(stdout, m.top_field[row - 1][column]),
                    6 => try bottomCardPrint(stdout),
                    else => unreachable,
                }
            }
            row = 0;
        }
        try stdout.print("\n", .{});
    }
}

pub fn printFields(stdout: anytype, time: i64) !void {
    try stdout.print("\x1B[2J\x1B[H", .{});
    try helpFn.topLabels(stdout, time);
    try printTopField(stdout);
    try stdout.print("\n", .{});
    try helpFn.bottomLabels(stdout);
    try printBottomField(stdout);
}
