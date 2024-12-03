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

    const content = try std.fs.cwd().readFileAlloc(allocator, "inputs/day03.txt", std.math.maxInt(u16));
    defer allocator.free(content);

    var idx: usize = 0;
    var sum: usize = 0;

    while (idx < content.len) {
        if (content[idx] == 'm' and std.mem.eql(u8, content[idx .. idx + 3], "mul")) {
            idx += 3;
            if (content[idx] != '(') {
                continue;
            }
            idx += 1;

            const start_idx = idx;
            while (content[idx] >= 48 and content[idx] <= 57) {
                idx += 1;
            }
            const end_idx = idx;

            const num1 = try parseInt(usize, content[start_idx..end_idx], 10);

            if (content[idx] != ',') {
                continue;
            }
            idx += 1;

            const start_idx_2 = idx;
            while (content[idx] >= 48 and content[idx] <= 57) {
                idx += 1;
            }
            const end_idx_2 = idx;

            const num2 = try parseInt(usize, content[start_idx_2..end_idx_2], 10);

            if (content[idx] != ')') {
                continue;
            }
            idx += 1;
            sum += num1 * num2;
            continue;
        }
        idx += 1;
    }

    std.log.info("Solution 1: Mul Sum: {}", .{sum});

    idx = 0;
    sum = 0;
    var enabled: bool = true;

    while (idx < content.len) {
        if (content[idx] == 'd' and content.len > idx + 4 and std.mem.eql(u8, content[idx .. idx + 4], "do()")) {
            enabled = true;
            idx += 4;
        }

        if (content[idx] == 'd' and content.len > idx + 7 and std.mem.eql(u8, content[idx .. idx + 7], "don't()")) {
            enabled = false;
            idx += 7;
        }

        if (enabled and content[idx] == 'm' and std.mem.eql(u8, content[idx .. idx + 3], "mul")) {
            idx += 3;
            if (content[idx] != '(') {
                continue;
            }
            idx += 1;

            const start_idx = idx;
            while (content[idx] >= 48 and content[idx] <= 57) {
                idx += 1;
            }
            const end_idx = idx;

            const num1 = try parseInt(usize, content[start_idx..end_idx], 10);

            if (content[idx] != ',') {
                continue;
            }
            idx += 1;

            const start_idx_2 = idx;
            while (content[idx] >= 48 and content[idx] <= 57) {
                idx += 1;
            }
            const end_idx_2 = idx;

            const num2 = try parseInt(usize, content[start_idx_2..end_idx_2], 10);

            if (content[idx] != ')') {
                continue;
            }
            idx += 1;
            sum += num1 * num2;
            continue;
        }
        idx += 1;
    }

    std.log.info("Solution 2: Checked Mul Sum: {}", .{sum});
}
