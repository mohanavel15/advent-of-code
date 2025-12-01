const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day01.txt");

pub fn Solution() !void {
    var lines = std.mem.tokenizeAny(u8, DATA, "\n");

    var dial: i32 = 50;
    var password: usize = 0;

    while (lines.next()) |line| {
        const move = line[0];
        const n = try parseInt(i32, line[1..], 10);

        switch (move) {
            'L' => {
                dial -= n;
            },
            'R' => {
                dial += n;
            },
            else => unreachable,
        }

        dial = @mod(dial, 100);
        if (dial == 0) password += 1;
    }

    std.debug.print("Day 1 - Solution 1: {d}\n", .{password});

    lines = std.mem.tokenizeAny(u8, DATA, "\n");
    dial = 50;
    password = 0;

    while (lines.next()) |line| {
        const move = line[0];
        const n = try parseInt(i32, line[1..], 10);

        switch (move) {
            'L' => {
                dial = (if (dial == 0) 100 else dial) - n;
            },
            'R' => {
                dial += n;
            },
            else => unreachable,
        }

        while (dial < 0) {
            dial += 100;
            password += 1;
        }

        if (dial == 0) password += 1;

        while (dial >= 100) {
            dial -= 100;
            password += 1;
        }
    }

    std.debug.print("Day 1 - Solution 2: {d}\n", .{password});
}
