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
}
