const std = @import("std");
const main = @import("main.zig");
const helpFn = @import("helpFn.zig");

// flips cards between stack 8 and 9
pub fn flipCard() void {
    var row_in_stack_9: usize = 0;
    while (main.top_field[row_in_stack_9][1].value != @intFromEnum(main.Value.joker)) : (row_in_stack_9 += 1) {}

    // If there's no cards in stack 8 all cards in stack 9 go back to stack 8
    // and get covered again
    if (main.top_field[0][0].value == @intFromEnum(main.Value.joker)) {
        const num_of_cards_in_stack_9: usize = row_in_stack_9;
        for (0..num_of_cards_in_stack_9) |value| {
            row_in_stack_9 -= 1;
            main.top_field[value][0] = main.top_field[row_in_stack_9][1];
            main.top_field[value][0].visivility = @intFromEnum(main.Visibility.covered);
            main.top_field[row_in_stack_9][1].value = @intFromEnum(main.Value.joker);
        }

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
pub fn findExactCardBottom(column: u8, val: u8) u8 {
    var row: usize = 0;
    while (main.bottom_field[row][column].value != val or main.bottom_field[row][column].visivility != @intFromEnum(main.Visibility.uncovered)) : (row += 1) {
        if (row == main.num_of_bot_field_rows - 1) {
            break;
        }
    }
    return @intCast(row);
}

// checks if a card or set of cards can be moved withinn the bottom field
pub fn b2bMove(row_from: u8, column_from: u8, column_to: u8) void {

    // finds the first spot where isn't a card in the column where we want to
    // put our chosen card
    var row_to: usize = 0;
    while (main.bottom_field[row_to][column_to].value != @intFromEnum(main.Value.joker)) : (row_to += 1) {}

    // finds out how mave cards should move
    var amount_of_cards: usize = 0;
    while (main.bottom_field[row_from + amount_of_cards][column_from].value != @intFromEnum(main.Value.joker)) : (amount_of_cards += 1) {}

    // if we're trying to place a card on a stack with no cards and the card
    // isn't a king return
    if (row_to == 0 and main.bottom_field[row_from][column_from].value != @intFromEnum(main.Value.king)) {
        return;
    }

    // if we're trying to move king to the empty space allow it
    if (row_to == 0 and main.bottom_field[row_from][column_from].value == @intFromEnum(main.Value.king)) {
        b2bMoveRun(row_from, column_from, amount_of_cards, row_to, column_to);
        return;
    }

    // if the card is a different color and its value is one less then the one
    // we're placing it on return true
    if (validMoveCheck(main.bottom_field[row_from][column_from], main.bottom_field[row_to - 1][column_to])) {
        b2bMoveRun(row_from, column_from, amount_of_cards, row_to, column_to);
    }
}

// moves a card or set of cards within the bottom field
fn b2bMoveRun(row_from: u8, column_from: u8, amount_of_cards: usize, row_to: usize, column_to: u8) void {

    // if the card is the only card in the stack, there's no reason to uncover
    // the card below it cuz there's none
    if (row_from != 0) {
        main.bottom_field[row_from - 1][column_from].visivility = @intFromEnum(main.Visibility.uncovered);
    }

    // loops over all the cards that should be moved and moves them
    var index: usize = 0;
    while (index < amount_of_cards) : (index += 1) {
        main.bottom_field[row_to + index][column_to] = main.bottom_field[row_from + index][column_from];
        main.bottom_field[row_from + index][column_from].value = @intFromEnum(main.Value.joker);
    }
}

// checks if the move is legal. If the card is a different color and its value
// is one less then the one we're placing it on return true
fn validMoveCheck(card_from: main.Card, card_to: main.Card) bool {
    if (card_from.value == card_to.value - 1 and helpFn.isRed(card_from.shape) != helpFn.isRed(card_to.shape)) {
        return true;
    }
    return false;
}

// moves cards from top field to bottom field
pub fn t2bMove(column_from: u8, column_to: u8) void {

    // if theres no cards do nothing
    const row_from = findFirstCardTop(column_from);
    if (row_from == 0) return;

    // if were placing a card on an empty spot and it's not a king return
    const row_to = findFirstCardBottom(column_to);
    if (row_to == 0 and main.top_field[row_from - 1][column_from].value != @intFromEnum(main.Value.king)) {
        return;
    }

    // else move the king to the empty space
    if (row_to == 0 and main.top_field[row_from - 1][column_from].value == @intFromEnum(main.Value.king)) {
        main.bottom_field[row_to][column_to] = main.top_field[row_from - 1][column_from];
        main.top_field[row_from - 1][column_from].value = @intFromEnum(main.Value.joker);
        return;
    }

    if (validMoveCheck(main.top_field[row_from - 1][column_from], main.bottom_field[row_to - 1][column_to])) {
        main.bottom_field[row_to][column_to] = main.top_field[row_from - 1][column_from];
        main.top_field[row_from - 1][column_from].value = @intFromEnum(main.Value.joker);
    }
}

// finds the top most card in a bottom field stack
pub fn findFirstCardBottom(column: u8) u8 {
    var row: usize = 0;
    while (main.bottom_field[row][column].value != @intFromEnum(main.Value.joker)) : (row += 1) {}
    return @intCast(row);
}

// finds the top most card in a top field stack
fn findFirstCardTop(column: u8) u8 {
    var row: usize = 0;
    while (main.top_field[row][column].value != @intFromEnum(main.Value.joker)) : (row += 1) {}
    return @intCast(row);
}

// prototyping a funciton that will move cards between decks
pub fn moveCardTestPrint() void {
    std.debug.print("Success!\n", .{});
}
