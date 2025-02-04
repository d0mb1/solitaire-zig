const std = @import("std");
const m = @import("main.zig");
const helpFn = @import("helpFn.zig");
const printCard = @import("printCard.zig");

// flips cards between stack 8 and 9
pub fn flipCard() void {
    var row_in_stack_9: usize = 0;
    const stack_9_column = 1;
    while (!m.top_field[row_in_stack_9][stack_9_column].isJoker()) : (row_in_stack_9 += 1) {}

    // If there's no cards in stack 8 all cards in stack 9 go back to stack 8
    // and get covered again
    if (m.top_field[0][0].isJoker()) {

        // if there's also no cards in stack 9 do nothing
        if (m.top_field[0][stack_9_column].isJoker()) {
            return;
        }
        const num_of_cards_in_stack_9: usize = row_in_stack_9;
        for (0..num_of_cards_in_stack_9) |value| {
            row_in_stack_9 -= 1;
            m.top_field[value][0] = m.top_field[row_in_stack_9][stack_9_column];
            m.top_field[value][0].visible = false;
            m.top_field[row_in_stack_9][stack_9_column].value = .joker;
        }
        m.moves += 1;

        // moves card from stack 8 to 9 and uncoveres it.
    } else {
        var row_in_stack_8: usize = 0;
        while (!m.top_field[row_in_stack_8][0].isJoker()) : (row_in_stack_8 += 1) {}
        m.top_field[row_in_stack_9][stack_9_column] = m.top_field[row_in_stack_8 - 1][0];
        m.top_field[row_in_stack_9][stack_9_column].visible = true;
        m.top_field[row_in_stack_8 - 1][0].value = .joker;
        m.moves += 1;
    }
}

// find a card in a stack and returns the row index
pub fn findExactCardBottom(column: u8, val: u8) u8 {
    var row: usize = 0;
    while (@intFromEnum(m.bottom_field[row][column].value) != val or m.bottom_field[row][column].visible != true) : (row += 1) {
        if (row == m.num_of_bot_field_rows - 1) {
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
    while (!m.bottom_field[row_to][column_to].isJoker()) : (row_to += 1) {}

    // finds out how mave cards should move
    var amount_of_cards: usize = 0;
    while (!m.bottom_field[row_from + amount_of_cards][column_from].isJoker()) : (amount_of_cards += 1) {}

    // if we're trying to place a card on a stack with no cards and the card
    // isn't a king return
    if (row_to == 0 and !m.bottom_field[row_from][column_from].isValue(.king)) {
        return;
    }

    // if we're trying to move king to the empty space allow it
    if (row_to == 0 and m.bottom_field[row_from][column_from].isValue(.king)) {
        b2bMoveRun(row_from, column_from, amount_of_cards, row_to, column_to);
        return;
    }

    // if the card is a different color and its value is one less then the one
    // we're placing it on return true
    if (validMoveCheck(m.bottom_field[row_from][column_from], m.bottom_field[row_to - 1][column_to])) {
        b2bMoveRun(row_from, column_from, amount_of_cards, row_to, column_to);
    }
}

// moves a card or set of cards within the bottom field
fn b2bMoveRun(row_from: u8, column_from: u8, amount_of_cards: usize, row_to: usize, column_to: u8) void {

    // if the card is the only card in the stack, there's no reason to uncover
    // the card below it cuz there's none
    if (row_from != 0) {
        m.bottom_field[row_from - 1][column_from].visible = true;
    }

    // loops over all the cards that should be moved and moves them
    var index: usize = 0;
    while (index < amount_of_cards) : (index += 1) {
        m.bottom_field[row_to + index][column_to] = m.bottom_field[row_from + index][column_from];
        m.bottom_field[row_from + index][column_from].value = .joker;
    }
    m.moves += 1;
}

// checks if the move is legal. If the card is a different color and its value
// is one less then the one we're placing it on return true
fn validMoveCheck(card_from: m.Card, card_to: m.Card) bool {
    if (card_to.isOneBiggerThan(card_from) and card_from.isRed() != card_to.isRed()) {
        return true;
    }
    return false;
}

// moves cards from top field to bottom field
pub fn t2bMove(column_from: u8, column_to: u8) void {

    // if theres no cards do nothing
    const row_from = findFirstCardTop(column_from);
    if (row_from == 0) return;

    // if we're placing a card on an empty spot and it's not a king return
    const row_to = findFirstCardBottom(column_to);
    if (row_to == 0 and !m.top_field[row_from - 1][column_from].isValue(.king)) {
        return;
    }

    // else move the king to the empty space
    if (row_to == 0 and m.top_field[row_from - 1][column_from].isValue(.king)) {
        m.bottom_field[row_to][column_to] = m.top_field[row_from - 1][column_from];
        m.top_field[row_from - 1][column_from].value = .joker;
        m.moves += 1;
        return;
    }

    if (validMoveCheck(m.top_field[row_from - 1][column_from], m.bottom_field[row_to - 1][column_to])) {
        m.bottom_field[row_to][column_to] = m.top_field[row_from - 1][column_from];
        m.top_field[row_from - 1][column_from].value = .joker;
        m.moves += 1;
    }
}

// finds the top most card in a bottom field stack
pub fn findFirstCardBottom(column: u8) u8 {
    var row: usize = 0;
    while (!m.bottom_field[row][column].isJoker()) : (row += 1) {}
    return @intCast(row);
}

// finds the top most card in a top field stack
pub fn findFirstCardTop(column: u8) u8 {
    var row: usize = 0;
    while (!m.top_field[row][column].isJoker()) : (row += 1) {}
    return @intCast(row);
}

// moves a card from the bottom field to one of the final fields
pub fn b2finalMove(column_from: u8) void {

    // finds the card we want to move
    const row_from = findFirstCardBottom(column_from);

    // if there's no cards return
    if (row_from == 0) return;

    // finds the stack that corresponds to the shape of the picked card or an empty space
    var final_column: usize = 0;
    for (2..m.top_field[0].len) |column_to| {
        if (m.bottom_field[row_from - 1][column_from].isShape(m.top_field[0][column_to].shape) or m.top_field[0][column_to].isJoker()) {
            final_column = column_to;
            break;
        }
    }

    // finds the spot where we want to place the card
    const row_to = findFirstCardTop(@intCast(final_column));

    // if the card is an ace we don't have to check the value of the card underneath
    if (m.bottom_field[row_from - 1][column_from].isValue(.ace)) {
        m.top_field[row_to][final_column] = m.bottom_field[row_from - 1][column_from];
        m.bottom_field[row_from - 1][column_from].value = .joker;
        m.moves += 1;

        // if it's not the only card in the stack uncover the card underneath it
        if (row_from != 1) {
            m.bottom_field[row_from - 2][column_from].visible = true;
        }
        return;
    }
    if (row_to == 0) return;

    // check if it's valid move
    if (m.bottom_field[row_from - 1][column_from].isOneBiggerThan(m.top_field[row_to - 1][final_column])) {
        m.top_field[row_to][final_column] = m.bottom_field[row_from - 1][column_from];
        m.bottom_field[row_from - 1][column_from].value = .joker;

        // if it's not the only card in the stack uncover the card underneath it
        if (row_from != 1) {
            m.bottom_field[row_from - 2][column_from].visible = true;
        }
        m.moves += 1;
    }
}

pub fn t2finalMove() void {
    const row_from = findFirstCardTop(1);
    const strack9column = 1;

    // if the stack is empty there is nothing to move
    if (row_from == 0) return;

    // finds the stack that corresponds to the shape of the picked card or an empty space
    var final_column: usize = 0;
    for (2..m.top_field[0].len) |column_to| {
        if (m.top_field[row_from - 1][strack9column].isShape(m.top_field[0][column_to].shape) or m.top_field[0][column_to].isJoker()) {
            final_column = column_to;
            break;
        }
    }

    // finds the spot where we want to place the card
    const row_to = findFirstCardTop(@intCast(final_column));

    // if the card is an ace we don't have to check the value of the card underneath
    if (m.top_field[row_from - 1][strack9column].isValue(.ace)) {
        m.top_field[row_to][final_column] = m.top_field[row_from - 1][strack9column];
        m.top_field[row_from - 1][strack9column].value = .joker;
        m.moves += 1;
        return;
    }
    if (row_to == 0) return;

    // check if it's valid move
    if (m.top_field[row_from - 1][strack9column].isOneBiggerThan(m.top_field[row_to - 1][final_column])) {
        m.top_field[row_to][final_column] = m.top_field[row_from - 1][strack9column];
        m.top_field[row_from - 1][strack9column].value = .joker;
        m.moves += 1;
    }
}

pub fn final2bMove(column_from: u8, column_to: u8) void {

    // find the card we want to move
    const row_from = findFirstCardTop(column_from);

    // if there's no card return
    if (row_from == 0) return;

    // find the place where we want to place the card
    const row_to = findFirstCardBottom(column_to);

    // if there's no cards there's no reason to put the card there
    if (row_to == 0) return;

    // check if the move follows the rules of the game and if yes place the card
    if (validMoveCheck(m.top_field[row_from - 1][column_from], m.bottom_field[row_to - 1][column_to])) {
        m.bottom_field[row_to][column_to] = m.top_field[row_from - 1][column_from];
        m.top_field[row_from - 1][column_from].value = .joker;
        m.moves += 1;
    }
}

// Automatically moves all possible cards to the final stacks
pub fn autoComplete(time: i64) !void {
    const stdout = std.io.getStdOut().writer();
    var moved: bool = true;
    while (moved) {
        moved = false;

        // Check discard pile (stack 9)
        const prev_moves = m.moves;
        t2finalMove();
        if (m.moves > prev_moves) {
            moved = true;
            try printCard.printFields(time);
            stdout.print("AUTOCOMPLEATING...\n", .{});
            std.time.sleep(500000000);
            continue;
        }

        // Check each bottom field stack
        for (0..m.num_of_bot_field_columns) |column| {
            const prev_moves_col = m.moves;
            b2finalMove(@intCast(column));
            if (m.moves > prev_moves_col) {
                moved = true;
                try printCard.printFields(time);
                stdout.print("AUTOCOMPLEATING...\n", .{});
                std.time.sleep(500000000);
                break;
            }
        }

        if (moved) continue;

        if (helpFn.isWon()) break;

        if (moved) {} else {
            moved = true;
            flipCard();
            try printCard.printFields(time);
            stdout.print("AUTOCOMPLEATING...\n", .{});
            std.time.sleep(500000000);
        }
    }
}
