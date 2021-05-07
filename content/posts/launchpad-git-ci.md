---
title: "Launchpad Git Project Automation"
date: 2018-06-29
tags: ["ubuntu"]
draft: false
aliases:
  - /post/launchpad-git-ci/
---

This post describes executing a CI test job on merge requests that need review and then autoland jobs that are approved on Launchpad hosted git based projects. The primary tool used is jenkins-launchpad-plugin.

The workflows are currently in use by a number of projects the Canonical Server team manages, including:

- [cloud-init](http://launchpad.net/cloud-init)
- [curtin](https://launchpad.net/curtin)
- [git-ubuntu](https://launchpad.net/usd-importer)
- [pycloudlib](https://launchpad.net/pycloudlib)
- [simplestreams](https://launchpad.net/simplestreams)

The examples used below are the actual jobs used by pycloudlib.

## Requirements

Before creating the automation jobs there are a number of pieces that need to be in place to enable this work.

### Launchpad Bot Account

A Launchpad bot account is required to vote on merge requests and to do the merging itself. This bot requires:

- A registered SSH Keys with Launchpad
- Commit rights to the projects needing review to vote on merges and autoland

### Jenkins

Jenkins instance configured with:

- The parameterized-trigger plugin, as the name implies, gives the ability to trigger other jobs with parameters.
- Below I use [jenkins-job-builder](https://docs.openstack.org/infra/jenkins-job-builder/) to deploy jobs more easily. This requires a bot account on the jenkins instance to deploy jobs.
- Optionally, the pipeline job plugin if you wish to run a test job with a pipeline based job. These are handy for more complex test jobs where a user wishes to build, unit test, and integration test as a part of CI rather than doing a simple test (e.g. `tox`)

### Jenkins Slaves

The slaves used for this work will need:

- Direct access to Launchpad
- git configured to allow `lp:` like strings:

```toml
[url "git+ssh://{{ launchpad_bot_username }}@git.launchpad.net/"]
    insteadof = lp:
```

### Jenkins Launchpad Plugin

The final step is the main library to get all of this to work is installing and configuring jenkins-launchpad-plugin.

#### Install

Install is not as simple as it could be for now, but the below would get it on a system.

```shell
apt-get update
apt-get install -y python-launchpadlib python-bzrlib python-mock \
    python-testtools python-jenkins python-lockfile python-testscenarios \
    python-pyruntest python-yaml python-git

bzr branch lp:tarmac
pushd tarmac
sudo python setup.py install
popd

bzr branch lp:jenkins-launchpad-plugin
pushd jenkins-launchpad-plugin
sudo python setup.py install
popd
```

Versions of Ubuntu from 18.04 (Bionic) onward no longer have the python-jenkins package and require to install it from pip (e.g. `pip install python-jenkins`). Note that even in pip it is called python-jenkins and not only jenkins, which is an entirely different package.

#### Configuration

Configuration of jenkins-launchpad-plugin is kept in `$HOME/.jlp/jlp.config`. The configuration lays out the configuration for connected to the Jenkins server and Launchpad credentials.

Of note is the last section for allowed users to launch CI. Keep in mind that launching CI against a user's code means that he or she is capable of launching arbitrary code on the CI system.

```yaml
# Settings specific to my instance
credential_store_path: /home/ubuntu/.launchpad/credentials
jenkins_url: http://server-team-jenkins-be.internal:8080/server
jenkins_proxy_url: https://jenkins.ubuntu.com/server
jenkins_user: server-team-bot
jenkins_password: SECRET
jenkins_build_token: BUILD_ME
launchpad_login: server-team-bot

# Other settings, kept at default
jobs_blacklisted_from_messages: []
launchpad_build_in_progress_message: 'Jenkins: testing in progress'
launchpad_review_type: continuous-integration
launchpadlocks_dir: /tmp/jenkins-launchpad-plugin/locks
lock_name: launchpad-trigger-lock
log_level: debug
lp_app: launchpad-trigger
lp_env: production
lp_version: devel
public_jenkins_url:
urls_to_hide: []
DEBEMAIL:
DEBFULLNAME:

# Specifically trusted users and groups allowed to do testing on
# the CI system. This users can execute arbitrary code!
allowed_users: [
  "server-team-ci-users",
]
```

## CI Jobs

The next section describes the individual jobs required to review merges requests in the 'Needs Review' state, run CI, and vote on them.

My examples will use Jenkins Job Builder YAML for each job, which are production examples used by the pycloudlib project.

### CI Trigger

The trigger job is something that will run every 15 mins to look for merge requests with 'Need review' status. Those merge requests will then get CI run against them by launching the corresponding CI test job.

This job will only start testing on jobs that have not already been reviewed or are not already getting reviewed. As stated earlier, the user must be in the allowed users list as well.

Note that this job will not launch CI against a merge request unless the user is in the 'allowed_users" list. That list as shown above in the configuration of jenkins-launchpad-plugin can include individual users or Launchpad groups. It is highly recommended to have a single CI user's group so the list

```yaml
- job:
    name: pycloudlib-ci-trigger
    node: any
    triggers:
        - timed: H/15 * * * *
    builders:
        - shell: |
            #!/bin/bash
            set -eux

            launchpadTrigger --lock-name=${JOB_NAME} \
                             --job=pycloudlib-ci-test \
                             --branch=lp:pycloudlib \
                             --trigger-ci
```

### CI Test

Next, comes the testing. For all intents and purposes the actual test can be whatever a projects wants: a build test, unit test, lint tests, integration test, etc. The important part here is noticing the expected parameters and publisher portions of the job.

The CI trigger job will launch this job with the information about the merge request including the revision to be tested, the repo name, branch name, and URL of the merge proposal.

By using `set -e` if any command fails during the testing then the CI will be considered a failure. The publisher triggers then launch the voting job with the appropriate test result value.

```yaml
- job:
    name: pycloudlib-ci-test
    node: any
    parameters:
      - string:
          name: candidate_revision
          description: Revision of the git branch
      - string:
          name: landing_candidate
          description: Launchpad git repo
      - string:
          name: landing_candidate_branch
          description: Branch name
      - string:
          name: merge_proposal
          description: Merge proposal URL
    auth-token: BUILD_ME
    publishers:
      - trigger-parameterized-builds:
        - project: admin-lp-git-vote
          condition: UNSTABLE_OR_WORSE
          predefined-parameters: |
            MERGE_BRANCH=${landing_candidate}
            MERGE_REVISION=${candidate_revision}
            MERGE_URL=${merge_proposal}
            TEST_RESULT=FAILED
            TEST_URL=${BUILD_URL}
      - trigger-parameterized-builds:
        - project: admin-lp-git-vote
          condition: SUCCESS
          predefined-parameters: |
            MERGE_BRANCH=${landing_candidate}
            MERGE_REVISION=${candidate_revision}
            MERGE_URL=${merge_proposal}
            TEST_RESULT=PASSED
            TEST_URL=${BUILD_URL}
    builders:
        - shell: |
            #!/bin/bash
            set -eux

            rm -rf *
            git clone --branch=${landing_candidate_branch} \
                ${landing_candidate} ci-${BUILD_NUMBER}
            cd ci-${BUILD_NUMBER}

            tox
```

### Launchpad Vote

Finally, it is time to vote on the merge proposal. The CI job passes in information about the merge request and places a vote on the actual merge proposal.

```yaml
- job:
    name: admin-lp-git-vote
    node: any
    parameters:
      - string:
          name: MERGE_BRANCH
          description: Branch name
      - string:
          name: MERGE_REVISION
          description: Revision of the git branch
      - string:
          name: MERGE_URL
          description: Merge proposal URL
      - string:
          name: TEST_RESULT
          description: Result of the CI job
      - string:
          name: TEST_URL
          description: Jenkins URL of the test job run
    builders:
      - shell: |
          #!/bin/bash
          set -eux

          voteOnMergeProposal --status=${TEST_RESULT} \
                              --build-url=${TEST_URL} \
                              --branch=${MERGE_BRANCH} \
                              --merge-proposal=${MERGE_URL} \
                              --revision=${MERGE_REVISION}
```

## Autoland Jobs

The final section describes how to autoland approved merge requests by looking for approved merge requests, running a final test against them, and landing the code. Once again, these examples use Jenkins Job Builder's YAML based configuration.

### Autoland Trigger

Similar to the CI job, the trigger job will look for merge requests, only this time in the 'Approved' state and launch the autoland test job.

```yaml
- job:
    name: pycloudlib-autoland-trigger
    node: any
    triggers:
        - timed: H/15 * * * *
    builders:
        - shell: |
            #!/bin/bash
            set -eux

            launchpadTrigger --lock-name=${JOB_NAME} \
                             --job=pycloudlib-autoland-test \
                             --branch=lp:pycloudlib \
                             --autoland
```

### Autoland Test

The autoland test job should then attempt the merge, but not push, while also running any applicable tests. This prevents any final issues sneaking in when a merge request is not quite fully updated to trunk.

Similar to the above, this test job can include any tests a project finds applicable.

```yaml
- job:
    name: pycloudlib-autoland-test
    node: any
    parameters:
      - string:
          name: candidate_revision
          description: Revision of the git branch
      - string:
          name: landing_candidate
          description: Launchpad git repo
      - string:
          name: landing_candidate_branch
          description: Branch name
      - string:
          name: merge_proposal
          description: Merge proposal URL
    auth-token: BUILD_ME
    publishers:
      - trigger-parameterized-builds:
        - project: admin-lp-git-autoland
          condition: UNSTABLE_OR_WORSE
          predefined-parameters: |
            MERGE_REVISION=${candidate_revision}
            MERGE_URL=${merge_proposal}
            TEST_RESULT=FAILED
            TEST_URL=${BUILD_URL}
      - trigger-parameterized-builds:
        - project: admin-lp-git-autoland
          condition: SUCCESS
          predefined-parameters: |
            MERGE_REVISION=${candidate_revision}
            MERGE_URL=${merge_proposal}
            TEST_RESULT=PASSED
            TEST_URL=${BUILD_URL}
    builders:
      - shell: |
          #!/bin/bash
          set -eux

          rm -rf *
          git clone lp:pycloudlib
          cd pycloudlib

          git remote add autoland ${landing_candidate}
          git fetch autoland

          git checkout master
          git merge autoland/${landing_candidate_branch} --squash

          tox
```

### Autoland

Finally, comes the autoland, which does a number of validating items before actually committing.

First, the autoland requires a test result from the previous job. If the test job had failed, then the autoland will add a comment to the merge proposal and mark it 'Needs fixing' with the URL of the test job.

The autoland will also ensure that the latest revision matches the reviewed revision to prevent any additional commits from getting added.

Next, the autoland will review the commit message to verify that it is correctly formatted. It expects at a minimum a short summary line up to 74 characters. If a longer commit message is required then immediately after the short summary a blank line and then the longer summary with lines up to 74 characters.

At the end of a commit message a list of bugs can be included that are fixed as a single list or each on its own line.

If the author of the code is someone other than the person submitting the merge request, then the separate author can be specified in the commit message. When doing the autoland the author specified here will be made the author of the final commit instead of the person who submitted the merge request.

```text
test: this is my short summary text

This is a much longer summary section that can be up to 74 characters.
If it is longer than 74 characters the merge will be rejected due to an
invalid commit message.

Additional paragraphs can be added as necessary.

LP: #1234567
LP: #1234567

Author: Joe Cool <joe.cool@canonical.com>
```

The autoland will then attempt the merge and if any part of the merge fails the process will reject the merge, again marking the merge request as 'Needs fixing' and add a message about what failed.

Finally, if any bugs were specified then the project's tasks for the bugs will be marked "Fix Committed" and a message added to them with the commit hash, project, and branch name where the fix is located.

```yaml
- job:
    name: admin-lp-git-autoland
    node: any
    parameters:
      - string:
          name: MERGE_REVISION
          description: Revision of the git branch
      - string:
          name: MERGE_URL
          description: Merge proposal URL
      - string:
          name: TEST_RESULT
          description: Result of the CI job
      - string:
          name: TEST_URL
          description: Jenkins URL of the test job run
    builders:
      - shell: |
          #!/bin/bash
          set -eux

          autoland --merge-proposal ${MERGE_URL} \
                   --revision ${MERGE_REVISION} \
                   --test-result ${TEST_RESULT} \
                   --build-job-url ${TEST_URL}
```
