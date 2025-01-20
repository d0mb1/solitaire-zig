const std = @import("std");
const main = @import("main.zig");

// prototyping a funciton that will move cards between decks
pub fn moveCard() void {
    std.debug.print("Success!\n", .{});
}

pub fn flipCard() void {
    var row_in_stack_9: usize = 0;
    while (main.top_field[row_in_stack_9][1].value != @intFromEnum(main.Value.joker)) : (row_in_stack_9 += 1) {}
    // If there's no cards in stack 8 all cards in stack 9 go back to stack 8 and get covered again
    if (main.top_field[0][0].value == @intFromEnum(main.Value.joker)) {
        const num_of_cards_in_stack_9: usize = row_in_stack_9;
        for (0..num_of_cards_in_stack_9) |value| {
            row_in_stack_9 -= 1;
            main.top_field[value][0] = main.top_field[row_in_stack_9][1];
            main.top_field[value][0].visivility = @intFromEnum(main.Visibility.covered);
            main.top_field[row_in_stack_9][1].value = @intFromEnum(main.Value.joker);
        }
        main.label_gap = 0;
        // moves card from stack 8 to 9 and uncoveres it.
    } else {
        var row_in_stack_8: usize = 0;
        while (main.top_field[row_in_stack_8][0].value != @intFromEnum(main.Value.joker)) : (row_in_stack_8 += 1) {}
        main.top_field[row_in_stack_9][1] = main.top_field[row_in_stack_8 - 1][0];
        main.top_field[row_in_stack_9][1].visivility = @intFromEnum(main.Visibility.uncovered);
        main.top_field[row_in_stack_8 - 1][0].value = @intFromEnum(main.Value.joker);
    }
}

// find a card in a stack and returns the row index
pub fn findCard(column: u8, val: u8) usize {
    var row: usize = 0;
    while (main.bottom_field[row][column].value != val or main.bottom_field[row][column].visivility != @intFromEnum(main.Visibility.uncovered)) : (row += 1) {
        if (row == main.num_of_bot_field_rows - 1) {
            break;
        }
    }
    return row;
}
