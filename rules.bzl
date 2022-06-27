load("@npm//@bazel/concatjs:index.bzl", _karma_web_test_suite = "karma_web_test_suite")
load("@rules_proto_grpc//js:defs.bzl", "js_proto_compile")
load("@npm//@bazel/concatjs:index.bzl", "ts_library")
load("@npm//@bazel/typescript:index.bzl", "ts_project")
load("@build_bazel_rules_nodejs//:index.bzl", "js_library")
load("@bazel_skylib//lib:paths.bzl", "paths")

def karma_web_test_suite(deps = [], **kwargs):
    _karma_web_test_suite(
        deps = [
            "//:material-ui-styles__umd",
            "//:material-ui__umd",
            "//:react-dom__umd",
            "@npm//react:react__umd",
        ] + deps,
        **kwargs
    )

def ts_proto_library(name, proto_library_rule, proto_path, proto_mod, **kwargs):
    js_proto_compile_name = "_%s_js_proto_compile" % name
    js_proto_compile(
        name = js_proto_compile_name,
        extra_protoc_args = ["--js_out=import_style=es6,binary:."],
        protos = [proto_library_rule],
        verbose = 4,
        **kwargs
    )

    # "_example_tspb_js_proto_compile/lib/ts/proto/example_pb"
    compiled_srcs_path = "%s/%s_pb" % (js_proto_compile_name, proto_path)

    # "_example_tspb_js_proto_compile/lib/ts/proto/example_pb.js"
    compiled_js = "%s.js" % compiled_srcs_path

    native.filegroup(
        name = compiled_js,
        srcs = [js_proto_compile_name],
    )

    native.genrule(
        name = "%s_ts" % name,
        srcs = [
            compiled_js,
        ],
        outs = ["%s.ts" % name],
        cmd = 'set -ex; for f in $(locations %s); do if [[ $$f =~ .*\\.js$$ ]]; then cat $$f > "$@" && echo "import \\"google-protobuf\\";\nexport default proto.%s" >> "$@"; fi; done' % (compiled_js, proto_mod),
    )

    # Broken. Causes error ERROR: file 'lib/ts/proto/example_tspb.d.ts' is generated by these conflicting actions:
    # Label: //lib/ts/proto:example_tspb, //lib/ts/proto:example_tspb_tsd
    native.genrule(
        name = "%s_tsd" % name,
        srcs = [
            compiled_js,
        ],
        outs = ["%s.d.ts" % name],
        cmd = 'set -ex; for f in $(locations %s); do if [[ $$f =~ .*\\.d.ts$$ ]]; then cat $$f > "$@"; fi; done' % (compiled_js),
    )

    ts_library(
        name = name,
        srcs = [
            "%s.ts" % name,
            "%s.d.ts" % name,
        ],
        deps = [
            "@npm//@types/google-protobuf",
            "@npm//@types/node",
            "@npm//@types/jasmine",
            "@npm//google-protobuf",
        ],
        package_path = "__main__/%s_tspb" % proto_path,
    )
