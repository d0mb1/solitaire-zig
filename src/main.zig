// ---SOLITAIRE--- //

// For running this game you'll need to have a nerd font installed
// and set up in your terminal. If you're using windows you'll also need to
// run "chcp 65001" command to enable unicode in your terminal.
// Also for some reason it only works when using the Command Prompt
// and not Windows PowerShell. Why? IDK. Maybe cuz Windows is shit.
// Haven't tried any other Windows shell.

// importing standard library
const std = @import("std");
// importing file with card print functions
const printCard = @import("printCard.zig");
const helpFn = @import("helpFn.zig");
const gameSetup = @import("gameSetup.zig");
const moveCard = @import("moveCard.zig");

const stdin = std.io.getStdIn().reader();

pub const RED: []const u8 = "\x1b[31m";
pub const RESET: []const u8 = "\x1b[0m";

// creating a card struct
// I'd like to give the different properties the type of enums
// but I've run in to a problem when I wanted to generate the deck
// but since you can't iterate over enums as far as I know
// I had to do it this way
pub const Card = struct {
    value: Values,
    shape: Shapes,
    visible: bool,

    pub fn isJoker(self: Card) bool {
        if (self.value == Values.joker) return true else return false;
    }

    pub fn isRed(self: Card) bool {
        // if (0 == shape % 2) return true else return false;
        if (@intFromEnum(self.shape) % 2 == 0) return true else return false;
    }

    pub fn isSameShapeAs(self: Card, card: Card) bool {
        if (self.shape == card.shape) return true else return false;
    }

    pub fn isShape(self: Card, shape: Shapes) bool {
        if (self.shape == shape) return true else return false;
    }

    pub fn isValue(self: Card, value: Values) bool {
        if (self.value == value) return true else return false;
    }

    pub fn isOneBiggerThen(self: Card, card: Card) bool {
        if (@intFromEnum(self.value) == @intFromEnum(card.value) + 1) return true else return false;
    }
};

// creating enums so we can easily check card properties in if statements
pub const Values = enum(u4) {
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
};
// reds are even and blacks are odd for easier checking when placing on a stack
pub const Shapes = enum(u2) {
    hearts,
    spades,
    diamonds,
    clubs,
};

pub const SymbolPosition = enum(u1) {
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

// creating a deck/array with all possible cards
pub var deck = [52]Card{
    .{ .value = Values.ace, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.two, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.three, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.four, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.five, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.six, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.seven, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.eight, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.nine, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.ten, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.jack, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.queen, .shape = Shapes.hearts, .visible = false },
    .{ .value = Values.king, .shape = Shapes.hearts, .visible = false },

    .{ .value = Values.ace, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.two, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.three, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.four, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.five, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.six, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.seven, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.eight, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.nine, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.ten, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.jack, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.queen, .shape = Shapes.spades, .visible = false },
    .{ .value = Values.king, .shape = Shapes.spades, .visible = false },

    .{ .value = Values.ace, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.two, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.three, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.four, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.five, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.six, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.seven, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.eight, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.nine, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.ten, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.jack, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.queen, .shape = Shapes.diamonds, .visible = false },
    .{ .value = Values.king, .shape = Shapes.diamonds, .visible = false },

    .{ .value = Values.ace, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.two, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.three, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.four, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.five, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.six, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.seven, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.eight, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.nine, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.ten, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.jack, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.queen, .shape = Shapes.clubs, .visible = false },
    .{ .value = Values.king, .shape = Shapes.clubs, .visible = false },
};

pub var bottom_field: [num_of_bot_field_rows][num_of_bot_field_columns]Card = undefined;
pub var top_field: [num_of_top_field_rows][num_of_top_field_columns]Card = undefined;

// keeps tracks of how many moves has player made
pub var moves: u16 = 0;

// --- MAIN FUNCTION --- //
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

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
                            else => try stdout.print("Invalid Stack\n", .{}),
                        }
                    },
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
                            else => try stdout.print("Invalid Stack\n", .{}),
                        }
                    },
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
                    else => try stdout.print("Invalid Stack\n", .{}),
                }
            },
            else => try stdout.print("Invalid Stack\n", .{}),
        }
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
