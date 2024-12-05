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

    const content = try std.fs.cwd().readFileAlloc(allocator, "inputs/day05.txt", std.math.maxInt(u16));
    defer allocator.free(content);

    var left_list = std.ArrayList(u32).init(allocator);
    var right_list = std.ArrayList(u32).init(allocator);
    defer left_list.deinit();
    defer right_list.deinit();

    var has_passed_rules = false;
    var lines = std.mem.tokenizeAny(u8, content, "\n");

    var middle_values = std.ArrayList(u32).init(allocator);
    var corrected_middle_values = std.ArrayList(u32).init(allocator);
    defer middle_values.deinit();
    defer corrected_middle_values.deinit();

    while (lines.next()) |line| {
        if (!has_passed_rules and std.mem.count(u8, line, "|") == 0) {
            has_passed_rules = true;
        }

        if (!has_passed_rules) {
            var rule = std.mem.tokenizeAny(u8, line, "|");
            try left_list.append(try parseInt(u32, rule.next().?, 10));
            try right_list.append(try parseInt(u32, rule.next().?, 10));
            continue;
        }

        var sequence = std.ArrayList(u32).init(allocator);
        defer sequence.deinit();

        var seq_raw = std.mem.tokenizeAny(u8, line, ",");
        while (seq_raw.next()) |seq_no| {
            try sequence.append(try parseInt(u32, seq_no, 10));
        }

        var bad_sequence = false;

        for (0..sequence.items.len) |seq_no_idx| {
            var values_before = std.ArrayList(u32).init(allocator);
            defer values_before.deinit();

            for (0..right_list.items.len) |idx| {
                if (right_list.items[idx] == sequence.items[seq_no_idx]) {
                    try values_before.append(left_list.items[idx]);
                }
            }

            for (values_before.items) |value| {
                if (std.mem.count(u32, sequence.items[seq_no_idx..], &[_]u32{value}) > 0) {
                    bad_sequence = true;
                    break;
                }
            }
        }

        if (!bad_sequence) {
            try middle_values.append(sequence.items[sequence.items.len / 2]);
            continue;
        }

        // Only Bad Sequences From Here. Also Code From Here Is Very Slow And Takes Few Seconds to complete.

        var corrected = false;
        while (!corrected) {
            corrected = true;
            seq_check: for (0..sequence.items.len) |seq_no_idx| {
                var values_before = std.ArrayList(u32).init(allocator);
                defer values_before.deinit();

                for (0..right_list.items.len) |idx| {
                    if (right_list.items[idx] == sequence.items[seq_no_idx]) {
                        try values_before.append(left_list.items[idx]);
                    }
                }

                // Bubble sort-ish method.
                for (values_before.items) |value| {
                    for (seq_no_idx + 1..sequence.items.len) |seq_no_idx_2| {
                        if (sequence.items[seq_no_idx_2] == value) {
                            corrected = false;
                            sequence.items[seq_no_idx_2] = sequence.items[seq_no_idx];
                            sequence.items[seq_no_idx] = value;
                            break :seq_check;
                        }
                    }
                }
            }
        }

        try corrected_middle_values.append(sequence.items[sequence.items.len / 2]);
    }

    var sum_middle_values: usize = 0;
    for (middle_values.items) |value| {
        sum_middle_values += value;
    }

    var sum_corrected_middle_values: usize = 0;
    for (corrected_middle_values.items) |value| {
        sum_corrected_middle_values += value;
    }

    std.log.info("Solution 1: Sum middle values: {}", .{sum_middle_values});
    std.log.info("Solution 2: Sum corrected middle values: {}", .{sum_corrected_middle_values});
}
