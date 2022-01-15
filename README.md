Rust Lambda Builder
===================

GitHub action for building statically linked Rust binaries (x86_64-unknown-linux-musl) packaged for [AWS Lambda](https://aws.amazon.com/blogs/opensource/rust-runtime-for-aws-lambda/).

```yaml
- uses: sevco/rust-lambda-cross-action@master
```
  ### Inputs
  | Variable | Description | Required | Default |
  |----------|-------------|----------|---------|
  | release  | Build with `--release` | true | |
  | git_credentials | If provided git will be configured to use these credentials and https | false | |


  ### Output
  `target/lambda/$project.zip`