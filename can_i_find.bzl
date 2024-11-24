def _can_i_find_impl(ctx):
    output_file = ctx.actions.declare_file(ctx.label.name + ".bash")

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

    transitive_files = []
    for target in ctx.attr.data:
        transitive_files.append(target[DefaultInfo].files)
    files = depset(transitive = transitive_files)

    return [DefaultInfo(
        executable = output_file,
        runfiles = ctx.runfiles(files = ctx.files.data,
            collect_default = True,  # <-- this is the key to including a filegroup() files in the runfiles
            transitive_files = files,  # <-- ineffective to solve this problem but may be useful long-term
        ),
    )]

can_i_find = rule(
    implementation = _can_i_find_impl,
    attrs = {
        "data": attr.label_list(allow_files = True),
    },
    executable = True,
)
