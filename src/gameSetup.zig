const std = @import("std");
const main = @import("main.zig");
const moveCard = @import("moveCard.zig");

// generates all possible cards and places them in a deck
pub fn fillDeck() void {

    // there's 4  possible shapes
    var card_index: usize = 0;
    for (0..4) |shape| {

        // 0 reserved for an empty card that represents empty space
        // it also moves the index up so it matches card numbering
        for (1..14) |value| {
            main.deck[card_index] = main.Card{
                .value = @intCast(value),
                .shape = @intCast(shape),
                .visivility = @intFromEnum(main.Visibility.covered),
            };
            card_index += 1;
        }
    }
}

// shuffle magic! done by the Fisher–Yates shuffeling algorithm
pub fn shuffleDeck() !void {

    // generating a random seed that ensures that the deck will be shuffled
    // differently each time
    var card_index: usize = main.num_of_cards - 1;
    const rand = std.Random.DefaultPrng;
    var prng = rand.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    while (card_index > 0) : (card_index -= 1) {

        // randomly choosing a card that will be swapped
        const j = prng.random().intRangeAtMost(usize, 0, card_index);
        const temp = main.deck[card_index];
        main.deck[card_index] = main.deck[j];
        main.deck[j] = temp;
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
        while (column < main.num_of_bot_field_columns) : (column += 1) {
            main.bottom_field[row][column] = main.deck[card_index];
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
    const num_of_rem_cards: usize = main.num_of_cards - card_index;
    for (0..num_of_rem_cards) |row| {

        // remaining cards are placed in to the eighth stack in the top field
        main.top_field[row][0] = main.deck[card_index];
        card_index += 1;
    }
}

// when the field is filled with cards they all are covered. This function
// uncoveres all the top cards in the bottom field.
pub fn uncoverCards() void {

    // steps thrue all the columns
    for (0..main.bottom_field[0].len) |column| {

        // uncover top most card
        const row = moveCard.findFirstCardBottom(@intCast(column));
        main.bottom_field[row - 1][column].visivility = @intFromEnum(main.Visibility.uncovered);
    }
}
