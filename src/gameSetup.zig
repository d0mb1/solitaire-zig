const std = @import("std");
const main = @import("main.zig");

// generates all possible cards and places them in a deck
pub fn fillDeck() void {
    var index: usize = 0;
    // there's 4  possible shapes
    for (0..4) |shape| {
        // 0 reserved for an empty card that represents empty space
        // it also moves the index up so it matches card numbering
        for (1..14) |value| {
            main.deck[index] = main.Card{
                .val = @intCast(value),
                .shp = @intCast(shape),
                .vis = @intFromEnum(main.Vis.covered),
            };
            index += 1;
        }
    }
}

// shuffle magic! done by the Fisher–Yates shuffeling algorithm
pub fn shuffle() !void {
    var index: usize = main.num_of_cards - 1;
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    while (index > 0) : (index -= 1) {
        const j = prng.random().intRangeAtMost(usize, 0, index);
        const temp = main.deck[index];
        main.deck[index] = main.deck[j];
        main.deck[j] = temp;
    }
}

// fills both playing fields with cards placed in the deck
pub fn fillFields() void {
    // this part fills the bottom field
    var index: usize = 0;
    var column: usize = 0;
    var row: usize = 0;
    var row_start: usize = 0;
    while (row < 7) : (row += 1) {
        while (column < main.bottom_field_columns) : (column += 1) {
            main.bottom_field[row][column] = main.deck[index];
            index += 1;
        }
        row_start += 1;
        column = row_start;
    }
    fillTopField(index);
}

fn fillTopField(i: usize) void {
    var index: usize = i;
    const num_of_rem_cards: usize = main.num_of_cards - index;
    for (0..num_of_rem_cards) |row| {
        // remaining cards are placed in to the fifth stack in the top field
        main.top_field[row][0] = main.deck[index];
        index += 1;
    }
}

// when the field is filled with cards they all are covered. This function
// uncoveres all the top cards in the bottom field.
pub fn uncoverCards() void {
    var index: usize = 0;
    // steps thrue all the columns
    for (0..main.bottom_field[0].len) |column| {
        // finds the top card in a stack and sets it to uncovered
        while (main.bottom_field[index][column].val != @intFromEnum(main.Val.joker)) {
            index += 1;
        }
        main.bottom_field[index - 1][column].vis = @intFromEnum(main.Vis.uncovered);
        index = 0;
    }
}
