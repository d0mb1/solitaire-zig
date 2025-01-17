const std = @import("std");
const main = @import("main.zig");

// prototyping a funciton that will move cards between decks
pub fn moveCard() void {
    std.debug.print("Success!\n", .{});
}

pub fn flipCard() void {
    var index1: usize = 0;
    while (main.top_field[index1][1].val != @intFromEnum(main.Val.joker)) : (index1 += 1) {}
    // If there's no cards in stack 8 all cards in stack 9 go back to stack 8 and get covered again
    if (main.top_field[0][0].val == @intFromEnum(main.Val.joker)) {
        const index0: usize = index1;
        for (0..index0) |value| {
            index1 -= 1;
            main.top_field[value][0] = main.top_field[index1][1];
            main.top_field[value][0].vis = @intFromEnum(main.Vis.covered);
            main.top_field[index1][1].val = @intFromEnum(main.Val.joker);
        }
        main.labelGap = 0;
        // moves card from stack 8 to 9 and uncoveres it.
    } else {
        var index0: usize = 0;
        while (main.top_field[index0][0].val != @intFromEnum(main.Val.joker)) : (index0 += 1) {}
        main.top_field[index1][1] = main.top_field[index0 - 1][0];
        main.top_field[index1][1].vis = @intFromEnum(main.Vis.uncovered);
        main.top_field[index0 - 1][0].val = @intFromEnum(main.Val.joker);
    }
}

// find a card in a stack and returns the row index
pub fn findCard(column: u8, val: u8) usize {
    var row: usize = 0;
    while (main.bottom_field[row][column].val != val or main.bottom_field[row][column].vis != @intFromEnum(main.Vis.uncovered)) : (row += 1) {
        if (row == main.bottom_field_rows - 1) {
            break;
        }
    }
    return row;
}
