const std = @import("std");
const main = @import("main.zig");
const helpFn = @import("helpFn.zig");

pub fn topCardPrint() void {
    std.debug.print("╭─────────╮ ", .{});
}

pub fn middleCardPrint(card: main.Card) void {
    // checks if the card is visible
    if (helpFn.isVisible(card.visivility)) {
        std.debug.print("│         │ ", .{});
    } else {
        std.debug.print("│ ∷∷∷∷∷∷∷ │ ", .{});
    }
}

pub fn bottomCardPrint() void {
    std.debug.print("╰─────────╯ ", .{});
}

// prints the outline of a card if the spot is empty
pub fn emptySpacePrint(part_of_card: usize) void {
    switch (part_of_card) {
        0 => std.debug.print("╭─  ───  ─╮ ", .{}),
        2, 4 => std.debug.print("│         │ ", .{}),
        6 => std.debug.print("╰─  ───  ─╯ ", .{}),
        else => emptyPrint(),
    }
}

// prints empty space of card width size
pub fn emptyPrint() void {
    std.debug.print("            ", .{});
}

pub fn topCardPrintSymbols(card: main.Card) void {
    // checks if the card is visible
    if (helpFn.isVisible(card.visivility)) {
        // check what color should the output be
        std.debug.print("│{s: >2}     {s} │ ", .{
            helpFn.usizeToValue(card, true),
            helpFn.usizeToShape(card),
        });
    } else {
        middleCardPrint(card);
    }
}

pub fn middleCardPrintSymbols(card: main.Card) void {
    // checks if the card is visible
    if (helpFn.isVisible(card.visivility)) {
        // check what color should the output be
        std.debug.print("│    {s}    │ ", .{helpFn.usizeToShape(card)});
    } else {
        middleCardPrint(card);
    }
}

pub fn bottomCardPrintSymbols(card: main.Card) void {
    // checks if the card is visible
    if (helpFn.isVisible(card.visivility)) {
        // check what color should the output be
        std.debug.print("│ {s}     {s: <2}│ ", .{
            helpFn.usizeToShape(card),
            helpFn.usizeToValue(card, false),
        });
    } else {
        middleCardPrint(card);
    }
}

// prints the bottom part of cards
pub fn restOfCardPrint(row: usize, column: usize, symbols: bool) void {
    var index: usize = 0;
    // finding the top card in the stack and counting how many rows above it is
    while (main.bottom_field[row - index][column].value == @intFromEnum(main.Value.joker)) : (index += 1) {
        if (row - index == 0) {
            break;
        }
    }
    // findout if the funtion should print a symbol part of a card or not
    // and prints apropriately
    switch (symbols) {
        true => switch (index) {
            0 => middleCardPrint(main.bottom_field[row - index][column]),
            1 => middleCardPrintSymbols(main.bottom_field[row - index][column]),
            2 => bottomCardPrintSymbols(main.bottom_field[row - index][column]),
            else => emptyPrint(),
        },
        false => switch (index) {
            0...2 => middleCardPrint(main.bottom_field[row - index][column]),
            3 => bottomCardPrint(),
            else => emptyPrint(),
        },
    }
}

// prints the bottom field
pub fn printBottomField() void {
    var count_down: usize = 0;
    // part of card keeps track of what part of card should be printed
    var part_of_card: usize = 0;
    // iterates over rows in a field
    for (0..main.bottom_field.len) |row| {
        var empty_cards: usize = 0;
        // iterates over columns / cards in a row
        for (0..main.bottom_field[row].len) |column| {
            // checks if the card isn't joker (empty space)
            if (main.bottom_field[row][column].value != @intFromEnum(main.Value.joker)) {
                topCardPrint();
            } else {
                // checks if the stack is empty
                if (main.bottom_field[0][column].value == @intFromEnum(main.Value.joker)) {
                    // is it's empty call a function that prints card outline
                    emptySpacePrint(part_of_card);
                } else {
                    restOfCardPrint(row, column, false);
                }
                empty_cards += 1;
            }
        }
        part_of_card += 1;
        // checks if the row is empty / there's only empty cards
        if (empty_cards == main.num_of_bot_field_columns) {
            // if the whole row is empty adds 1 to a count down
            count_down += 1;
            if (count_down == 4) {
                // when count-down gets to 3 it breaks the loop preventing
                // the function from printing unnecessary rows
                std.debug.print("\n", .{});
                break;
            }
        }
        std.debug.print("\n", .{});
        // iterates over columns / cards in a row
        for (0..main.bottom_field[row].len) |column| {
            // checks if the card isn't joker (empty space)
            if (main.bottom_field[row][column].value != @intFromEnum(main.Value.joker)) {
                topCardPrintSymbols(main.bottom_field[row][column]);
            } else {
                // checks if the stack is empty
                if (main.bottom_field[0][column].value == @intFromEnum(main.Value.joker)) {
                    // is it's empty call a function that prints card outline
                    emptySpacePrint(part_of_card);
                } else {
                    restOfCardPrint(row, column, true);
                }
            }
        }
        part_of_card += 1;
        std.debug.print("\n", .{});
    }
}

// function that is very long but also very simple. When there's more cards in
// the 9th stack it will show 3 top most cards

// part_of_card represesnts which part of a card should be printed

// index represents how many cards are on the stack and determines what
// should be printed
pub fn spreadCards(part_of_card: usize, index: usize) void {
    switch (index) {
        0 => {
            emptySpacePrint(part_of_card);
            emptyPrint();
        },
        1 => {
            switch (part_of_card) {
                0 => {
                    topCardPrint();
                    emptyPrint();
                },
                1 => {
                    topCardPrintSymbols(main.top_field[index - 1][1]);
                    emptyPrint();
                },
                2, 4 => {
                    middleCardPrint(main.top_field[index - 1][1]);
                    emptyPrint();
                },
                3 => {
                    middleCardPrintSymbols(main.top_field[index - 1][1]);
                    emptyPrint();
                },
                5 => {
                    bottomCardPrintSymbols(main.top_field[index - 1][1]);
                    emptyPrint();
                },
                6 => {
                    bottomCardPrint();
                    emptyPrint();
                },
                else => unreachable,
            }
        },
        2 => {
            switch (part_of_card) {
                0 => {
                    std.debug.print("╭──", .{});
                    topCardPrint();
                    std.debug.print("         ", .{});
                },
                1 => {
                    if (helpFn.isRed(main.top_field[index - 2][1].shape)) {
                        std.debug.print("│\x1b[31m{s: >2}\x1b[0m", .{helpFn.usizeToValue(main.top_field[index - 2][1], true)});
                    } else {
                        std.debug.print("│{s: >2}", .{helpFn.usizeToValue(main.top_field[index - 2][1], true)});
                    }
                    topCardPrintSymbols(main.top_field[index - 1][1]);
                    std.debug.print("         ", .{});
                },
                2, 4 => {
                    std.debug.print("│  ", .{});
                    middleCardPrint(main.top_field[index - 1][1]);
                    std.debug.print("         ", .{});
                },
                3 => {
                    std.debug.print("│  ", .{});
                    middleCardPrintSymbols(main.top_field[index - 1][1]);
                    std.debug.print("         ", .{});
                },
                5 => {
                    if (helpFn.isRed(main.top_field[index - 2][1].shape)) {
                        std.debug.print("│ \x1b[31m{s}\x1b[0m", .{helpFn.usizeToShape(main.top_field[index - 2][1])});
                    } else {
                        std.debug.print("│ {s}", .{helpFn.usizeToShape(main.top_field[index - 2][1])});
                    }
                    bottomCardPrintSymbols(main.top_field[index - 1][1]);
                    std.debug.print("          ", .{});
                },
                6 => {
                    std.debug.print("╰──", .{});
                    bottomCardPrint();
                    std.debug.print("         ", .{});
                },
                else => unreachable,
            }
        },
        else => {
            switch (part_of_card) {
                0 => {
                    std.debug.print("╭──╭──", .{});
                    topCardPrint();
                    std.debug.print("      ", .{});
                },
                1 => {
                    std.debug.print("│{s: >2}", .{helpFn.usizeToValue(main.top_field[index - 3][1], true)});
                    std.debug.print("│{s: >2}", .{helpFn.usizeToValue(main.top_field[index - 2][1], true)});
                    topCardPrintSymbols(main.top_field[index - 1][1]);
                    std.debug.print("      ", .{});
                },
                2, 4 => {
                    std.debug.print("│  │  ", .{});
                    middleCardPrint(main.top_field[index - 1][1]);
                    std.debug.print("      ", .{});
                },
                3 => {
                    std.debug.print("│  │  ", .{});
                    middleCardPrintSymbols(main.top_field[index - 1][1]);
                    std.debug.print("      ", .{});
                },
                5 => {
                    std.debug.print("│ {s}", .{helpFn.usizeToShape(main.top_field[index - 3][1])});
                    std.debug.print("│ {s}", .{helpFn.usizeToShape(main.top_field[index - 2][1])});
                    bottomCardPrintSymbols(main.top_field[index - 1][1]);
                    std.debug.print("      ", .{});
                },
                6 => {
                    std.debug.print("╰──╰──", .{});
                    bottomCardPrint();
                    std.debug.print("      ", .{});
                },
                else => unreachable,
            }
        },
        // previously this function showed 5 cards on stack 9. Now Only 3
        // 4 => {
        //     switch (part_of_card) {
        //         0 => {
        //             std.debug.print("╭──╭──╭──", .{});
        //             topCardPrint();
        //             std.debug.print("   ", .{});
        //         },
        //         1 => {
        //             std.debug.print("│{s: >2}", .{hf.usizeToValue(main.top_field[index - 4][1], true)});
        //             std.debug.print("│{s: >2}", .{hf.usizeToValue(main.top_field[index - 3][1], true)});
        //             std.debug.print("│{s: >2}", .{hf.usizeToValue(main.top_field[index - 2][1], true)});
        //             topCardPrintSymbols(main.top_field[index - 1][1]);
        //             std.debug.print("   ", .{});
        //         },
        //         2, 4 => {
        //             std.debug.print("│  │  │  ", .{});
        //             middleCardPrint(main.top_field[index - 1][1]);
        //             std.debug.print("   ", .{});
        //         },
        //         3 => {
        //             std.debug.print("│  │  │  ", .{});
        //             middleCardPrintSymbols(main.top_field[index - 1][1]);
        //             std.debug.print("   ", .{});
        //         },
        //         5 => {
        //             std.debug.print("│ {s}", .{hf.usizeToShape(main.top_field[index - 4][1])});
        //             std.debug.print("│ {s}", .{hf.usizeToShape(main.top_field[index - 3][1])});
        //             std.debug.print("│ {s}", .{hf.usizeToShape(main.top_field[index - 2][1])});
        //             bottomCardPrintSymbols(main.top_field[index - 1][1]);
        //             std.debug.print("   ", .{});
        //         },
        //         6 => {
        //             std.debug.print("╰──╰──╰──", .{});
        //             bottomCardPrint();
        //             std.debug.print("   ", .{});
        //         },
        //         else => unreachable,
        //     }
        // },
        // else => {
        //     switch (part_of_card) {
        //         0 => {
        //             std.debug.print("╭──╭──╭──╭──", .{});
        //             topCardPrint();
        //         },
        //         1 => {
        //             std.debug.print("│{s: >2}", .{hf.usizeToValue(main.top_field[index - 5][1], true)});
        //             std.debug.print("│{s: >2}", .{hf.usizeToValue(main.top_field[index - 4][1], true)});
        //             std.debug.print("│{s: >2}", .{hf.usizeToValue(main.top_field[index - 3][1], true)});
        //             std.debug.print("│{s: >2}", .{hf.usizeToValue(main.top_field[index - 2][1], true)});
        //             topCardPrintSymbols(main.top_field[index - 1][1]);
        //         },
        //         2, 4 => {
        //             std.debug.print("│  │  │  │  ", .{});
        //             middleCardPrint(main.top_field[index - 1][1]);
        //         },
        //         3 => {
        //             std.debug.print("│  │  │  │  ", .{});
        //             middleCardPrintSymbols(main.top_field[index - 1][1]);
        //         },
        //         5 => {
        //             std.debug.print("│ {s}", .{hf.usizeToShape(main.top_field[index - 5][1])});
        //             std.debug.print("│ {s}", .{hf.usizeToShape(main.top_field[index - 4][1])});
        //             std.debug.print("│ {s}", .{hf.usizeToShape(main.top_field[index - 3][1])});
        //             std.debug.print("│ {s}", .{hf.usizeToShape(main.top_field[index - 2][1])});
        //             bottomCardPrintSymbols(main.top_field[index - 1][1]);
        //         },
        //         6 => {
        //             std.debug.print("╰──╰──╰──╰──", .{});
        //             bottomCardPrint();
        //         },
        //         else => unreachable,
        //     }
        // },
    }
}

// I know I can probably save the indexes in to an array and then print the
// cards which would be more effective since it wouldn't have to pass each
// column multiple times but this was easier
// TODO: Fix this later
pub fn printTopField() void {
    var index: usize = 0;
    // there's 7 rows to a card. part_of_card keeps track of which part
    // should be printed
    var part_of_card: usize = 0;
    while (part_of_card < 7) : (part_of_card += 1) {
        for (0..main.top_field[0].len) |column| {
            // if (column == 2) {
            //     emptyPrint();
            // }
            while (main.top_field[index][column].value != @intFromEnum(main.Value.joker)) {
                index += 1;
            }
            if (column == 1) {
                spreadCards(part_of_card, index);
            } else if (index == 0) {
                emptySpacePrint(part_of_card);
            } else {
                switch (part_of_card) {
                    0 => topCardPrint(),
                    1 => topCardPrintSymbols(main.top_field[index - 1][column]),
                    2, 4 => middleCardPrint(main.top_field[index - 1][column]),
                    3 => middleCardPrintSymbols(main.top_field[index - 1][column]),
                    5 => bottomCardPrintSymbols(main.top_field[index - 1][column]),
                    6 => bottomCardPrint(),
                    else => unreachable,
                }
            }
            index = 0;
        }
        std.debug.print("\n", .{});
    }
}
