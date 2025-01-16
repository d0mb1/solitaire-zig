const std = @import("std");

pub fn main() void {
    var arr: [10][10]u64 = undefined;
    // const compare: u64 = 6;
    var index: u64 = 1;
    var i: u64 = 0;
    var j: u64 = 0;

    while (i < arr.len) : (i += 1) {
        while (j < arr[i].len) : (j += 1) {
            arr[i][j] = index;
            index += 1;
        }
        j = 0;
    }
    std.debug.print("{}\n", .{arr[6][6]});

    for (0..arr.len) |row| {
        //
        for (0..arr[row].len) |val| {
            //
            //
            if (row > 0 and arr[row - 1][val] == 6) {
                std.debug.print("{: >3} ", .{arr[row][val]});
            } else {
                std.debug.print("    ", .{});
            }
            // std.debug.print("{: >3} ", .{arr[row][val]});
            //
            //
        }
        std.debug.print("\n", .{});
    }
}
