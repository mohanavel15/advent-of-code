const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day03.txt");

pub fn Solution() !void {
    var lines = std.mem.tokenizeAny(u8, DATA, "\n");

    var total_output_joltage: u128 = 0;

    while (lines.next()) |line| {
        var max_joltage: usize = 0;
        for (0..line.len) |i| {
            for (i + 1..line.len) |j| {
                max_joltage = @max(max_joltage, (line[i] - '0') * 10 + (line[j] - '0'));
            }
        }

        total_output_joltage += max_joltage;
    }

    std.debug.print("Day 3 - Solution 1: {d}\n", .{total_output_joltage});

    lines.reset();
    total_output_joltage = 0;

    while (lines.next()) |line| {
        total_output_joltage += max_n_jolt(12, 0, line);
    }

    std.debug.print("Day 3 - Solution 2: {d}\n", .{total_output_joltage});
}

fn max_n_jolt(depth: usize, so_far: u128, remaining: []const u8) u128 {
    var max_joltage: u8 = 0;
    var max_joltage_i: usize = 0;

    for (0..remaining.len - depth + 1) |i| {
        const jolt: u8 = remaining[i] - '0';
        if (max_joltage < jolt) {
            max_joltage = jolt;
            max_joltage_i = i;
        }

        if (jolt == 9) break;
    }

    const new_so_far: u128 = (so_far * 10) + max_joltage;

    if (depth > 1) {
        return max_n_jolt(depth - 1, new_so_far, remaining[max_joltage_i + 1 ..]);
    }

    return new_so_far;
}
