const std = @import("std");
const builtin = @import("builtin");
const m = @import("main.zig");
const moveCard = @import("moveCard.zig");

pub fn generateDeck() void {
    var index: usize = 0;
    for (0..4) |shape| {
        for (1..14) |value| {
            m.deck[index].init(value, shape);
            index += 1;
        }
    }
}

// shuffle magic! done by the Fisher–Yates shuffeling algorithm
pub fn shuffleDeck() !void {

    // generating a random seed that ensures that the deck will be shuffled
    // differently each time
    var card_index: usize = m.num_of_cards - 1;
    const rand = std.Random.DefaultPrng;
    var prng = rand.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    while (card_index > 0) : (card_index -= 1) {

        // randomly choosing a card that will be swapped
        const j = prng.random().intRangeAtMost(usize, 0, card_index);
        const temp = m.deck[card_index];
        m.deck[card_index] = m.deck[j];
        m.deck[j] = temp;
    }
}

// fills both playing fields with cards placed in the deck
pub fn fillFields() void {
    var card_index: usize = 0;
    var column: usize = 0;
    var row: usize = 0;
    var row_start: usize = 0;

    // stagger where the cards are placed
    while (row < 7) : (row += 1) {
        while (column < m.num_of_bot_field_columns) : (column += 1) {
            m.bottom_field[row][column] = m.deck[card_index];
            card_index += 1;
        }
        row_start += 1;
        column = row_start;
    }
    fillTopField(card_index);
}

// fills top fields
fn fillTopField(i: usize) void {
    var card_index: usize = i;
    const num_of_rem_cards: usize = m.num_of_cards - card_index;
    for (0..num_of_rem_cards) |row| {

        // remaining cards are placed in to the eighth stack in the top field
        m.top_field[row][0] = m.deck[card_index];
        card_index += 1;
    }
}

// when the field is filled with cards they all are covered. This function
// uncoveres all the top cards in the bottom field.
pub fn uncoverCards() void {

    // steps thrue all the columns
    for (0..m.bottom_field[0].len) |column| {

        // uncover top most card
        const row = moveCard.findFirstCardBottom(@intCast(column));
        m.bottom_field[row - 1][column].visible = true;
    }
}

// check if running on windows. If so set UTF-8 encoding and enable ascii escape codes
pub fn setupWindowsTerminal() void {
    if (builtin.os.tag == .windows) {
        const w = std.os.windows;
        const kernel32 = w.kernel32;

        _ = kernel32.SetConsoleOutputCP(65001);

        const stdout_handle = w.GetStdHandle(w.STD_OUTPUT_HANDLE) catch return;
        var mode: u32 = undefined;
        if (kernel32.GetConsoleMode(stdout_handle, &mode) != 0) {
            _ = kernel32.SetConsoleMode(stdout_handle, mode | 0x0004);
        }
    }
}
