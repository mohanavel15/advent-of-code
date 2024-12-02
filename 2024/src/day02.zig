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

    var levels_safety = std.ArrayList(bool).init(allocator);
    var levels_safety2 = std.ArrayList(bool).init(allocator);
    defer levels_safety.deinit();
    defer levels_safety2.deinit();

    var lines = std.mem.tokenizeAny(u8, content, "\n");

    while (lines.next()) |line| {
        var numbers = std.mem.tokenizeAny(u8, line, " ");

        var levels = std.ArrayList(i32).init(allocator);
        defer levels.deinit();

        while (numbers.next()) |number| {
            const n = try parseInt(i32, number, 10);
            try levels.append(n);
        }

        const safe = montonic(levels.items) and checkRange(levels.items);
        try levels_safety.append(safe);

        for (0..levels.items.len) |skip_idx| {
            var new_levels = try levels.clone();
            defer new_levels.deinit();

            _ = new_levels.orderedRemove(skip_idx);

            const safe2 = montonic(new_levels.items) and checkRange(new_levels.items);
            if (safe2) {
                try levels_safety2.append(safe2);
                break;
            }
        }
    }

    const sum_of_safe = std.mem.count(bool, levels_safety.items, &[_]bool{true});
    std.log.info("Solution 1: Number of Safe : {}", .{sum_of_safe});

    const sum_of_safe2 = std.mem.count(bool, levels_safety2.items, &[_]bool{true});
    std.log.info("Solution 2: Number of Safe : {}", .{sum_of_safe2});
}

fn montonic(values: []i32) bool {
    var isAsc: bool = true;
    for (1..values.len) |idx| {
        if (values[idx - 1] > values[idx]) {
            isAsc = false;
            break;
        }
    }

    var isDsc: bool = true;
    for (1..values.len) |idx| {
        if (values[idx - 1] < values[idx]) {
            isDsc = false;
            break;
        }
    }

    return isAsc or isDsc;
}

fn checkRange(values: []i32) bool {
    for (1..values.len) |idx| {
        const diff = values[idx - 1] - values[idx];
        if (diff < -3 or diff > 3 or diff == 0) {
            return false;
        }
    }

    return true;
}
