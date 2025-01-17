const std = @import("std");
const main = @import("main.zig");
// importing file with functions that help with printing card symbols
const hf = @import("helpFn.zig");

pub fn topCardPrint() void {
    std.debug.print("╭─────────╮ ", .{});
}

pub fn middleCardPrint(card: main.Card) void {
    // checks if the card is visible
    if (hf.isVisible(card.vis)) {
        std.debug.print("│         │ ", .{});
    } else {
        std.debug.print("│ ∷∷∷∷∷∷∷ │ ", .{});
    }
}

pub fn bottomCardPrint() void {
    std.debug.print("╰─────────╯ ", .{});
}

pub fn emptyPrint() void {
    std.debug.print("            ", .{});
}

pub fn topCardPrintSymbols(card: main.Card) void {
    // checks if the card is visible
    if (hf.isVisible(card.vis)) {
        // check what color should the output be
        if (hf.isRed(card.shp)) {
            std.debug.print("│\x1b[31m{s: >2}     {s}\x1b[0m │ ", .{
                hf.usizeToValue(card.val),
                hf.usizeToShape(card.shp),
            });
        } else {
            std.debug.print("│{s: >2}     {s} │ ", .{
                hf.usizeToValue(card.val),
                hf.usizeToShape(card.shp),
            });
        }
    } else {
        middleCardPrint(card);
    }
}

pub fn middleCardPrintSymbols(card: main.Card) void {
    // checks if the card is visible
    if (hf.isVisible(card.vis)) {
        // check what color should the output be
        if (hf.isRed(card.shp)) {
            std.debug.print("│    \x1b[31m{s}\x1b[0m    │ ", .{hf.usizeToShape(card.shp)});
        } else {
            std.debug.print("│    {s}    │ ", .{hf.usizeToShape(card.shp)});
        }
    } else {
        middleCardPrint(card);
    }
}

pub fn bottomCardPrintSymbols(card: main.Card) void {
    // checks if the card is visible
    if (hf.isVisible(card.vis)) {
        // check what color should the output be
        if (hf.isRed(card.shp)) {
            std.debug.print("│ \x1b[31m{s}     {s: <2}\x1b[0m│ ", .{
                hf.usizeToShape(card.shp),
                hf.usizeToValue(card.val),
            });
        } else {
            std.debug.print("│ {s}     {s: <2}│ ", .{
                hf.usizeToShape(card.shp),
                hf.usizeToValue(card.val),
            });
        }
    } else {
        middleCardPrint(card);
    }
}

// prints the bottom part of cards
pub fn restOfCardPrint(row: usize, column: usize, symbols: bool) void {
    var index: usize = 0;
    // finding the top card in the stack and counting how many rows above it is
    while (main.bottom_field[row - index][column].val == @intFromEnum(main.Val.joker)) : (index += 1) {
        if (row - index == 0) {
            break;
        }
    }
    // finding out if the funtion should print a symbol part of a card or not
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
