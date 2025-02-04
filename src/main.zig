const std = @import("std");
const printCard = @import("printCard.zig");
const helpFn = @import("helpFn.zig");
const gameSetup = @import("gameSetup.zig");
const moveCard = @import("moveCard.zig");

const stdin = std.io.getStdIn().reader();

// color for terminal
pub const RED: []const u8 = "\x1b[31m";
pub const RESET: []const u8 = "\x1b[0m";

// creating a card struct
pub const Card = struct {
    value: Values,
    shape: Shapes,
    visible: bool,

    // create a card
    pub fn init(self: *Card, val_index: usize, shp_index: usize) void {
        self.value = Values.init(val_index);
        self.shape = Shapes.init(shp_index);
        self.visible = false;
    }

    //checks if card is joker
    pub fn isJoker(self: Card) bool {
        return if (self.value == Values.joker) true else false;
    }

    //checks if card is red
    pub fn isRed(self: Card) bool {
        // if (0 == shape % 2) return true else return false;
        return if (@intFromEnum(self.shape) % 2 == 0) true else false;
    }

    // checks if card is the input value
    pub fn isValue(self: Card, value: Values) bool {
        return if (self.value == value) true else false;
    }

    // checks if card is the input shape
    pub fn isShape(self: Card, shape: Shapes) bool {
        return if (self.shape == shape) true else false;
    }

    // checks if the card value is one bigger than the input card
    pub fn isOneBiggerThan(self: Card, card: Card) bool {
        return if (@intFromEnum(self.value) == @intFromEnum(card.value) + 1) true else false;
    }
};

// creating enums so we can easily check card properties in if statements
pub const Values = enum {
    joker,
    ace,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    ten,
    jack,
    queen,
    king,

    pub fn init(i: usize) Values {
        return switch (i) {
            0 => .joker,
            1 => .ace,
            2 => .two,
            3 => .three,
            4 => .four,
            5 => .five,
            6 => .six,
            7 => .seven,
            8 => .eight,
            9 => .nine,
            10 => .ten,
            11 => .jack,
            12 => .queen,
            13 => .king,
            else => unreachable,
        };
    }
};
// reds are even and blacks are odd for easier checking when placing on a stack
pub const Shapes = enum {
    hearts,
    spades,
    diamonds,
    clubs,

    pub fn init(i: usize) Shapes {
        return switch (i) {
            0 => .hearts,
            1 => .spades,
            2 => .diamonds,
            3 => .clubs,
            else => unreachable,
        };
    }
};
// if the symbol is on the top of a card or bottom
pub const SymbolPosition = enum {
    top,
    bottom,
};

// defines the number of cards in a standard card deck
pub const num_of_cards = 52;

// there can only be 13 cards in a stack in the bottom field. The last card
// always has to be the joker so there's 14 rows
pub const num_of_bot_field_rows = 20;

// there are 7 stacks in the bottom filed in solitaire
pub const num_of_bot_field_columns = 7;

// after dealing cards to the bottom field there will be 24 cards left
// that will placed in to one stack. The last card
// always has to be the joker so there's 14 rows
pub const num_of_top_field_rows = 25;

// there are 6 stacks in the top filed in solitaire
pub const num_of_top_field_columns = 6;

// creating a deck/array that will hold all possible cards
pub var deck: [52]Card = undefined;

pub var bottom_field: [num_of_bot_field_rows][num_of_bot_field_columns]Card = undefined;
pub var top_field: [num_of_top_field_rows][num_of_top_field_columns]Card = undefined;

// keeps tracks of how many moves has player made
pub var moves: u16 = 0;

// --- MAIN FUNCTION --- //
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    gameSetup.generateDeck();
    // shuffle twice just in case
    try gameSetup.shuffleDeck();
    try gameSetup.shuffleDeck();
    gameSetup.fillFields();
    gameSetup.uncoverCards();

    while (true) {
        try stdout.print("\x1B[2J\x1B[H", .{});
        try helpFn.topLabels();
        try printCard.printTopField();
        try stdout.print("\n", .{});
        try helpFn.bottomLabels();
        try printCard.printBottomField();

        try stdout.print("▶ PICK A STACK (0 - 9) FROM WHICH TO TAKE A CARD OUT OF\t▶ ", .{});
        const from = try helpFn.getNum();

        // switch cases that hadel game logic. All posibilities should be
        // handeled here
        switch (from) {

            // from one of the finishing stacks
            0 => {
                try stdout.print("▶ PICK AN EXACT STACK (1 - 4) TO TAKE A CARD OUT OF\t▶ ", .{});
                const from_final = try helpFn.getNum();
                switch (from_final) {

                    // which finishing stack
                    1...4 => {
                        try stdout.print("▶ PICK A STACK (1 - 7) WHERE TO PLACE THE CARD\t\t▶ ", .{});
                        const to = try helpFn.getNum();

                        // where to move the card
                        switch (to) {
                            1...7 => moveCard.final2bMove(from_final + 1, to - 1),
                            52 => if (helpFn.isWinnable()) try moveCard.autoComplete(),
                            else => try stdout.print("Invalid Stack\n", .{}),
                        }
                    },
                    52 => if (helpFn.isWinnable()) try moveCard.autoComplete(),
                    else => try stdout.print("Invalid Stack\n", .{}),
                }
            },

            // from one of the game board stacks
            1...7 => {
                try stdout.print("▶ PICK AN EXACT VALUE (1 - 13) OF A CARD TO MOVE\n  OR PLACE THE LAST CARD TO A FINAL STACK (0)\t\t▶ ", .{});
                const what = try helpFn.getNum();

                // what card is being picked
                switch (what) {

                    // you can place a card straight to final stacks without
                    // choosing a specific card
                    0 => moveCard.b2finalMove(from - 1),
                    1...13 => {
                        const row = moveCard.findExactCardBottom(from - 1, what);

                        // if the card isn't found the loop starts from the
                        // begining
                        if (row == 13) continue;

                        try stdout.print("▶ PICK A STACK (0 - 7) WHERE TO PLACE THE CARD\t\t▶ ", .{});
                        const to = try helpFn.getNum();

                        // where to move the card
                        switch (to) {
                            1...7 => {
                                moveCard.b2bMove(row, from - 1, to - 1);
                            },
                            0 => {
                                moveCard.b2finalMove(from - 1);
                            },
                            52 => if (helpFn.isWinnable()) try moveCard.autoComplete(),
                            else => try stdout.print("Invalid Stack\n", .{}),
                        }
                    },
                    52 => if (helpFn.isWinnable()) try moveCard.autoComplete(),
                    else => try stdout.print("Invalid Card Value\n", .{}),
                }
            },

            // flips cards between stack 8 and 9
            8 => {
                moveCard.flipCard();
            },

            // from the "discard" stack
            9 => {
                try stdout.print("▶ PICK A STACK (0 - 7) WHERE TO PLACE THE CARD\t\t▶ ", .{});
                const to = try helpFn.getNum();

                // where to move card
                switch (to) {
                    1...7 => {
                        // column labels aren't the same as array indexes
                        moveCard.t2bMove(from - 8, to - 1);
                    },
                    0 => moveCard.t2finalMove(),
                    52 => if (helpFn.isWinnable()) try moveCard.autoComplete(),
                    else => try stdout.print("Invalid Stack\n", .{}),
                }
            },
            52 => if (helpFn.isWinnable()) try moveCard.autoComplete(),
            else => try stdout.print("Invalid Stack\n", .{}),
        }

        // if (helpFn.isWinnable()) try moveCard.autoComplete();
        if (helpFn.isWon()) break;
    }
    try stdout.print("\x1B[2J\x1B[H", .{});
    try helpFn.topLabels();
    try printCard.printTopField();
    try stdout.print("\n", .{});
    try helpFn.bottomLabels();
    try printCard.printBottomField();
    try stdout.print("\n", .{});
    try helpFn.winningMessage();
}
