const std = @import("std");
const main = @import("main.zig");

// prototyping a funciton that will move cards between decks
pub fn moveCard() void {
    std.debug.print("Success!\n", .{});
}

pub fn cardFlip() void {
    var index1: usize = 0;
    while (main.top_field[index1][1].val != @intFromEnum(main.Val.joker)) {
        index1 += 1;
    }
    std.debug.print("index1: {}\n", .{index1});
    if (main.top_field[0][0].val == @intFromEnum(main.Val.joker)) {
        const index0: usize = index1;
        for (0..index0) |value| {
            index1 -= 1;
            main.top_field[value][0] = main.top_field[index1][1];
            main.top_field[value][0].vis = @intFromEnum(main.Vis.covered);
            main.top_field[index1][1].val = @intFromEnum(main.Val.joker);
            std.debug.print("index1: {}\n", .{index1});
        }
    } else {
        var index0: usize = 0;
        while (main.top_field[index0][0].val != @intFromEnum(main.Val.joker)) {
            index0 += 1;
        }
        std.debug.print("index0: {}\n", .{index0});
        main.top_field[index1][1] = main.top_field[index0 - 1][0];
        main.top_field[index1][1].vis = @intFromEnum(main.Vis.uncovered);
        main.top_field[index0 - 1][0].val = @intFromEnum(main.Val.joker);
    }
}
