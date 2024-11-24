# bazel-example-data-label-list-runfiles

Example of the run files in a file group not propagating through run files in a label_list

## What are we working with

Our required data is represented in two ways:
 - a filegroup(name="//:some_data")
 - the file directly, at //:some_data/dog.yaml

The file we need to use in the rule that this error represents is the "dog.yaml".

.. because dogs are good to find, of course.

There are three targets that show this:

1.  //check:check-succeeds -- with a file as data -- shows the successful mapping of runfiles to
    include a source file. 'bazel run //check:check-succeeds' won't pass nor fail where bazel can
    see, but will show an output of the "find" command that shows the precious "dog.yaml".  

2.  //check:check-fails -- with a filegroup() as data -- shows how runfiles doesn't propagate
    through the filegroup, so it's not there during the 'bazel run', so the "find" in the bash
    script doesn't find it.  'bazel run //check:check-fails' won't pass nor fail where bazel can
    see, but will show an output where the "dog.yaml" isn't visible.

3.  //check:check-repaired -- with check-fails wrapped in a sh_binary() -- shows how sh_binary()
    appends the correct runfiles to the returned DefaultInfo: the "find" sees "some_data/dog.yaml"

## So what

So..the issue is how to replicate the same benefit of the sh_binary() wrapper in the naked
//check:check-fails

This helps me resolve an issue in a larger ruleset that is really being a drag right now.  Total
ballast thart I'd like to be past and drop in a completed form.  ...but dammit, it's not
cooperating :) 
