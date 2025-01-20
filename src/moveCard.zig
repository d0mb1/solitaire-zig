const std = @import("std");
const main = @import("main.zig");
const helpFn = @import("helpFn.zig");

// prototyping a funciton that will move cards between decks
pub fn moveCardTestPrint() void {
    std.debug.print("Success!\n", .{});
}

// find a card in a stack and returns the row index
pub fn findCard(column: u8, val: u8) u8 {
    var row: usize = 0;
    while (main.bottom_field[row][column].value != val or main.bottom_field[row][column].visivility != @intFromEnum(main.Visibility.uncovered)) : (row += 1) {
        if (row == main.num_of_bot_field_rows - 1) {
            break;
        }
    }
    return @intCast(row);
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

// moves cards between stack in to bottom field
pub fn bottom2bottomMove(row_from: u8, column_from: u8, column_to: u8) void {
    var amout_of_cards: usize = 0;
    var row_to: usize = 0;
    // finds the first spot where isn't a card in the column where we want to put our chosen card
    while (main.bottom_field[row_to][column_to].value != @intFromEnum(main.Value.joker)) : (row_to += 1) {}
    // finds out how mave cards should move
    while (main.bottom_field[row_from + amout_of_cards][column_from].value != @intFromEnum(main.Value.joker)) : (amout_of_cards += 1) {}
    var index: usize = 0;
    // if the card is a different color and its value is one less then the one we're placing it on place the card. Else do nothing
    if (main.bottom_field[row_from][column_from].value == main.bottom_field[row_to - 1][column_to].value - 1 and helpFn.isRed(main.bottom_field[row_from][column_from].shape) != helpFn.isRed(main.bottom_field[row_to - 1][column_to].shape)) {
        // if the card is the only card in the stack, there's no reason to uncover the card below it cuz there's none
        if (row_from != 0) {
            main.bottom_field[row_from - 1][column_from].visivility = @intFromEnum(main.Visibility.uncovered);
        }
        // loops over all the cards that should be moved and moves them
        while (index < amout_of_cards) : (index += 1) {
            main.bottom_field[row_to + index][column_to] = main.bottom_field[row_from + index][column_from];
            main.bottom_field[row_from + index][column_from].value = @intFromEnum(main.Value.joker);
        }
    }
}
