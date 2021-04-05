# Setup GitHub Action Environment

Used by LeafLink repositories to setup common environment variables for use within GitHub actions

---

[![Current Release](https://img.shields.io/badge/release-0.5.0-1eb0fc.svg)](https://github.com/leaflink/setup-ga-environment-action/releases/tag/0.5.0)

## Description

This plugin currently accepts no input and returns no output. It is used only to inject environment variables into GitHub Action jobs. LeafLink uses this functionality to control various aspects of GitHub Action workflows including which Docker tag(s) to use when building images, AWS ECR configurations, and other helpful pieces of data jobs may find useful.

For more information, see `setup-environment.sh`.

### A note about Docker tagging

This action creates two environment variables related to Docker tagging: `DOCKER_TAG` and `DOCKER_TAGS`, where the plural version contains a comma-separated list of Docker tags that can be used to create, tag, and push a Docker image to a Docker repository (like ECR). LeafLink typically builds a single Docker image with one or more tags associated with it, and then pushes those tagged images to ECR.

The `DOCKER_TAG` variable contains a single Docker tag that is guaranteed to be within the comma-separated list of `DOCKER_TAGS` and can be used when you need to pull the tagged image from a Docker repository (like ECR).

LeafLink's Docker tagging scheme uses the following logic:

| Git Event | Example Tag(s) Created | Description |
| --------- | ---------------------- | ----------- |
| Push | `53b49b2` | Creates a single tag using the first 7 characters of the push's Git SHA |
| Pull Request | `PR-{\d}` | Create a single tag using the GitHub pull request number |
| Merge to `main` or `master` | `master-53b49b2`, `master`, `latest` | Creates 3 tags where one uses the first 7 characters of the merge's Git SHA |
| GitHub release published | `0.1.0`, `stable` | Creates 2 tags, one called `stable` and one representing the tag associated with the GitHub release |

## Usage

To use this plugin in a GitHub Action job, add the following step:

```yaml
- uses: leaflink/setup-ga-environment-action@<semver>
```

*NOTE*: make sure to replace `<semver>` above with the correct semver-tagged release you need to use. Typically this is the most recent release, which can be found in the [/releases](/releases) section.
