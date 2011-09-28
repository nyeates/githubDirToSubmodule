########################
# GithubDirToSubmodule
# This shell script will automate the moving of all subdirectories in an
# existing git repository. It moves directories, one by one, into seperate
# repos, and then makes a submodule reference to that new seperate repo.
# The submodule is put into the original parent repo.
#
# Assumes that git repo already exists locally (defined by ParentRepoPath)
# and is up to date with any reomote repo upstream (github). Make sure to
# have any github repo cloned locally, and that your local clone is up to
# date with the latest github repo.
########################

# Variables
ParentRepoPath /usr/local/git/testSplit/
NewRepoName=CombineDS
NewRepoPath=/usr/local/git/CombineDS/
GitHubUserName=nyeates
GitHubToken=
SuperprojectPath=/usr/local/git/testSplit/ # This could reference a different repo than the ParentRepo, if you want the submodule link to show in a different repo from the original parent repo

