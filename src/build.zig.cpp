const std = @import("std");

pub fn build(b : *std.Build) void {
  const target = b.standardTargetOptions(.{});
  const optimize = b.standardOptimizeOption(.{});

  const exe = b.addExecutable(.{
      .name = "cppzigproject",
      .root_module = b.createModule(.{
          .target = target,
          .optimize = optimize,
          .link_libcpp = true,
      }),
  });

  // 1. Clang membuang fragmen mentah ke folder cache
  exe.root_module.addCSourceFiles(.{
      .files = &.{"src/main.cpp"},
      .flags =
          &.{
              "-Wall",
              "-Wextra",
              "-std=c++23",
              "-MJ",
              ".zig-cache/raw_cc.json",
          },
  });

  b.installArtifact(exe);

  // =========================================================================
  // CROSS-PLATFORM CLANGD STEP (WINDOWS & LINUX COMPATIBLE VIA PYTHON)
  // =========================================================================
  const format_step = b.step(
      "clangd", "Format compile_commands.json di root untuk Linux & Windows");

  // Script inline Python untuk membaca fragmen, membersihkan koma, dan
  // membungkus dengan [ ]
  const py_cmd = b.addSystemCommand(&.{
    "python", "-c",
        \\import os
        \\if os.path.exists('.zig-cache/raw_cc.json')
        :
        \\ with open('.zig-cache/raw_cc.json', 'r') as f
        : content = f.read()
                        .strip()
                        .rstrip(',')
        \\ with open('compile_commands.json', 'w') as f
        : f.write(f "[\n{content}\n]\n")
  });

  py_cmd.step.dependOn(&exe.step);
  format_step.dependOn(&py_cmd.step);
  // =========================================================================

  const run_cmd = b.addRunArtifact(exe);
  run_cmd.step.dependOn(b.getInstallStep());

  if (b.args)
    | args | { run_cmd.addArgs(args); }

  const run_step = b.step("run", "Jalankan aplikasi");
  run_step.dependOn(&run_cmd.step);
}
