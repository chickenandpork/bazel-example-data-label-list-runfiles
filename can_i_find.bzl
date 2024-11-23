def _can_i_find_impl(ctx):
    output_file = ctx.actions.declare_file(ctx.label.name + ".bash")

    # https://github.com/bazelbuild/examples/blob/fdfabba6aa8065f5b1349931dc08678fdccdb678/rules/runfiles/complex_tool.bzl#L32
    ctx.actions.write(
        output = output_file,
        is_executable = True,
        content = r"""\
set -x
pwd
find . -print
exec test -f some_data/dog.yaml
""",
    )
    # find . -name dog.yaml| grep dog ||  exit 1

    return [DefaultInfo(
        executable = output_file,
        runfiles = ctx.runfiles(files = ctx.files.data),
    )]

can_i_find = rule(
    implementation = _can_i_find_impl,
    attrs = {
        "data": attr.label_list(allow_files = True),
    },
    executable = True,
)
