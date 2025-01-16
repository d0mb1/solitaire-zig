const std = @import("std");
const main = @import("main.zig");
// importing file with functions that help with printing card symbols
const hf = @import("helpFn.zig");

pub fn topCardPrint() void {
    std.debug.print("╭─────────╮ ", .{});
}

fn middleCardPrint(card: main.Card) void {
    // checks if the card is visible
    if (hf.isVisible(card.vis)) {
        std.debug.print("│         │ ", .{});
    } else {
        std.debug.print("│ ∷∷∷∷∷∷∷ │ ", .{});
    }
}

fn bottomCardPrint() void {
    std.debug.print("╰─────────╯ ", .{});
}

fn emptyPrint() void {
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

fn middleCardPrintSymbols(card: main.Card) void {
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

fn bottomCardPrintSymbols(card: main.Card) void {
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
pub fn restOfCardPrint(row: usize, card: usize, symbols: bool) void {
    var i: usize = 0;
    // finding the top card in the stack and counting how many rows above it is
    while (main.bottom_field[row - i][card].val == @intFromEnum(main.Value.joker)) : (i += 1) {
        if (row - i == 0) {
            break;
        }
    }
    // finding out if the funtion should print a symbol part of a card or not
    // and prints apropriately
    switch (symbols) {
        true => switch (i) {
            0 => middleCardPrint(main.bottom_field[row - i][card]),
            1 => middleCardPrintSymbols(main.bottom_field[row - i][card]),
            2 => bottomCardPrintSymbols(main.bottom_field[row - i][card]),
            else => emptyPrint(),
        },
        false => switch (i) {
            0...2 => middleCardPrint(main.bottom_field[row - i][card]),
            3 => bottomCardPrint(),
            else => emptyPrint(),
        },
    }
}
