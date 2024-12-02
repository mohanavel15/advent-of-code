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

    const buffer = try allocator.alloc(u8, 20000); // Bigger is safer. Because: readFile(...): if the length matches buffer.len the situation is ambiguous
    defer allocator.free(buffer);

    const content = try std.fs.cwd().readFile("inputs/day02.txt", buffer);

    var change_in_levels = std.ArrayList(bool).init(allocator);
    defer change_in_levels.deinit();

    var lines = std.mem.tokenizeAny(u8, content, "\n");
    while (lines.next()) |line| {
        var numbers = std.mem.tokenizeAny(u8, line, " ");

        var levels = std.ArrayList(u32).init(allocator);
        defer levels.deinit();

        while (numbers.next()) |number| {
            const n = try parseInt(u32, number, 10);
            try levels.append(n);
        }

        var safe: bool = true;
        var order: u32 = 0;
        var sum_of_unsaf = 0;
        for (1..levels.items.len) |idx| {
            const left = levels.items[idx - 1];
            const right = levels.items[idx];

            if (left == right) {
                safe = false;
                break;
            } else if (left > right) {
                if (order == 2) {
                    safe = false;
                    break;
                }
                order = 1;

                if ((left - right) > 3) {
                    safe = false;
                    break;
                }
            } else {
                if (order == 1) {
                    safe = false;
                    break;
                }
                order = 2;

                if ((right - left) > 3) {
                    safe = false;
                    break;
                }
            }
        }

        try change_in_levels.append(safe);
    }

    var sum_of_safe: u32 = 0;

    for (change_in_levels.items) |change| {
        if (change == true) {
            sum_of_safe += 1;
        }
    }

    std.log.info("Solution 1: Number of Safe : {}", .{sum_of_safe});

    // var sum_similarity_score: usize = 0;
    // for (left_list.items) |value| {
    //     const count = std.mem.count(u32, right_list.items, &[_]u32{value});
    //     sum_similarity_score += @as(usize, value) * count;
    // }

    // std.log.info("Solution 2: Sum of Similarity Score: {}", .{sum_similarity_score});
}
