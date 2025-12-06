const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day06.txt");

pub fn Solution() !void {
    var lines = std.mem.tokenizeAny(u8, DATA, "\n");

    var numbers: [5][1000]usize = undefined;
    var numbers_len: usize = 0;
    var num_per_lin: usize = 0;

    var ops: [1000]u8 = undefined;

    while (lines.next()) |line| {
        if (line[0] == '+' or line[0] == '*') {
            var ops_it = std.mem.tokenizeAny(u8, line, " ");
            while (ops_it.next()) |op| {
                ops[num_per_lin] = op[0];
                num_per_lin += 1;
            }
            break;
        }

        var nums = std.mem.tokenizeAny(u8, line, " ");

        var num_per_line: usize = 0;
        while (nums.next()) |num_str| {
            numbers[numbers_len][num_per_line] = try std.fmt.parseInt(usize, num_str, 10);
            num_per_line += 1;
        }

        numbers_len += 1;
    }

    var results: [1000]usize = undefined;
    @memset(&results, 0);

    for (0..num_per_lin) |i| {
        switch (ops[i]) {
            '+' => {
                for (0..numbers_len) |j| results[i] += numbers[j][i];
            },
            '*' => {
                for (0..numbers_len) |j| {
                    if (results[i] == 0) results[i] = 1;
                    results[i] *= numbers[j][i];
                }
            },

            else => unreachable,
        }
    }

    var total: usize = 0;
    for (0..num_per_lin) |i| {
        total += results[i];
    }

    std.debug.print("Day 6 - Solution 1: {d}\n", .{total});
}
