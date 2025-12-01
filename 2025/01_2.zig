const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("01.txt", .{});
    defer file.close();

    var buf: [4096]u8 = undefined;
    var file_reader = file.reader(&buf);
    const reader = &file_reader.interface;

    var pos: i32 = 50;
    var counter: i32 = 0;
    while (try reader.takeDelimiter('\n')) |line| {
        const dir = line[0];
        const clicks = std.fmt.parseInt(i32, line[1..], 10) catch |err| {
            std.debug.print("err: {}\n", .{err});
            return error.InvalidInput;
        };

        switch (dir) {
            'R' => {
                counter += @divTrunc(clicks, 100);
                if (pos + @rem(clicks, 100) >= 100) counter += 1;
                pos = @rem(pos + clicks, 100);
            },
            'L' => {
                counter += @divTrunc(clicks, 100);
                if (pos > 0 and pos - @rem(clicks, 100) <= 0) counter += 1;
                pos = @mod(pos - clicks, 100);
            },
            else => undefined,
        }
    }
    std.debug.print("password: {}\n", .{counter});
}
