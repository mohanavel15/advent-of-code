const std = @import("std");
const parseInt = std.fmt.parseInt;

pub fn Solution() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        switch (gpa.deinit()) {
            .leak => std.log.err("Memory Leak!", .{}),
            .ok => {},
        }
    }

    var allocator = gpa.allocator();

    const content = try std.fs.cwd().readFileAlloc(allocator, "inputs/day07.txt", std.math.maxInt(u16));
    defer allocator.free(content);

    var results = std.ArrayList(usize).init(allocator);
    defer results.deinit();

    var lines = std.mem.tokenizeAny(u8, content, "\n");

    while (lines.next()) |line| {
        var values = std.mem.tokenizeAny(u8, line, ": ");
        const result = try parseInt(usize, values.next().?, 10);
        var operands = std.ArrayList(usize).init(allocator);
        defer operands.deinit();
        while (values.next()) |value| {
            try operands.append(try parseInt(usize, value, 10));
        }

        const operators: usize = std.math.pow(usize, 2, operands.items.len - 1);
        for (0..operators) |op| {
            var experimental_result: usize = operands.items[0];
            for (1..operands.items.len) |idx| {
                const operator = (op & (@as(usize, 1) << @intCast(idx - 1))) >> @intCast(idx - 1);
                switch (operator) {
                    0 => experimental_result += operands.items[idx],
                    1 => experimental_result *= operands.items[idx],
                    else => std.debug.panic("How did we get here?: {}", .{operator}),
                }
            }

            if (result == experimental_result) {
                try results.append(result);
                break;
            }
        }
    }

    var result_sum: usize = 0;
    for (results.items) |result| {
        result_sum += result;
    }

    std.log.info("Solution 1: Sum of correct equations: {}", .{result_sum});

    var results2 = std.ArrayList(u128).init(allocator);
    defer results2.deinit();

    lines = std.mem.tokenizeAny(u8, content, "\n");
    while (lines.next()) |line| {
        var values = std.mem.tokenizeAny(u8, line, ": ");
        const result = try parseInt(u128, values.next().?, 10);
        var operands = std.ArrayList(u128).init(allocator);
        defer operands.deinit();
        while (values.next()) |value| {
            try operands.append(try parseInt(u128, value, 10));
        }

        const operators = try allocator.alloc(u2, operands.items.len - 1);
        @memset(operators, 0);

        defer allocator.free(operators);

        const combinations = std.math.pow(usize, 3, operands.items.len - 1);
        for (0..combinations) |_| {
            var experimental_result: u128 = operands.items[0];
            for (0..operators.len) |idx| {
                switch (operators[idx]) {
                    0 => experimental_result += operands.items[idx + 1],
                    1 => experimental_result *= operands.items[idx + 1],
                    2 => {
                        // Following is slow.
                        // const str = try std.fmt.allocPrint(allocator, "{}{}", .{ experimental_result, operands.items[idx + 1] });
                        // experimental_result = try parseInt(u128, str, 10);
                        // allocator.free(str);

                        // Inspiration from others.
                        experimental_result = experimental_result * std.math.pow(u128, 10, std.math.log10_int(operands.items[idx + 1]) + 1) + operands.items[idx + 1];
                    },
                    3 => unreachable,
                }
            }
            if (result == experimental_result) {
                try results2.append(result);
                break;
            }

            increment(operators);
        }
    }

    var result_sum2: u128 = 0;
    for (results2.items) |result| {
        result_sum2 += result;
    }

    std.log.info("Solution 2: Sum of correct equations: {}", .{result_sum2});
}

fn increment(values: []u2) void {
    values[0] += 1;
    var carry: usize = 0;
    if (values[0] == 3) {
        carry += 1;
        values[0] = 0;
    }

    var idx: usize = 1;
    while (idx < values.len and carry > 0) {
        values[idx] += 1;
        carry -= 1;
        if (values[idx] == 3) {
            values[idx] = 0;
            carry += 1;
        }

        idx += 1;
    }
}
