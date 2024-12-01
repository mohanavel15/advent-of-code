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

    const buffer = try allocator.alloc(u8, 15000); // Bigger is safer. Because: readFile(...): if the length matches buffer.len the situation is ambiguous
    defer allocator.free(buffer);

    const content = try std.fs.cwd().readFile("inputs/day01.txt", buffer);

    var left_list = std.ArrayList(u32).init(allocator);
    var right_list = std.ArrayList(u32).init(allocator);
    defer left_list.deinit();
    defer right_list.deinit();

    var lines = std.mem.tokenizeAny(u8, content, "\n");
    while (lines.next()) |line| {
        var numbers = std.mem.tokenizeAny(u8, line, " ");

        const n1 = try parseInt(u32, numbers.next().?, 10);
        const n2 = try parseInt(u32, numbers.next().?, 10);

        try left_list.append(n1);
        try right_list.append(n2);
    }

    std.mem.sort(u32, left_list.items, {}, std.sort.asc(u32));
    std.mem.sort(u32, right_list.items, {}, std.sort.asc(u32));

    var sum_distance: u32 = 0;

    for (0..left_list.items.len) |idx| {
        const left = left_list.items[idx];
        const right = right_list.items[idx];
        var distance: u32 = 0;
        if (left > right) {
            distance = left - right;
        } else {
            distance = right - left;
        }
        sum_distance += distance;
    }

    std.log.info("Solution 1: Sum of Distance: {}", .{sum_distance});

    var sum_similarity_score: usize = 0;
    for (left_list.items) |value| {
        const count = std.mem.count(u32, right_list.items, &[_]u32{value});
        sum_similarity_score += @as(usize, value) * count;
    }

    std.log.info("Solution 2: Sum of Similarity Score: {}", .{sum_similarity_score});
}
