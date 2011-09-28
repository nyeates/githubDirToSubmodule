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

# 0) Verify that Parent Repo Exists

# 1) Make new dir to house new repo - appropriately named after existing zenpack
  * cd $PARENTREPOPATH
    * get to directory of parent repo that has dir's that you want to split
  * ls -la
    * see directories that you want to split out
  * Record Xth directory: $NEWREPONAME
  * mkdir $NEWREPOPATH
  * cd $NEWREPOPATH

# 2) clone entire ZP repo to new local dir
  * git clone --no-hardlinks $PARENTREPOPATH $NEWREPOPATH

# 3) Cut the cloned repo down to just one directory / zenpack
  * git filter-branch --subdirectory-filter $NEWREPONAME --prune-empty --tag-name-filter cat -- --all
  * git remote rm origin
  * rm -rf .git/refs/original/
  * git reflog expire --expire=now --all
  * git gc --aggressive --prune=now

# 4) Create new github repo
  * curl -F 'login=$GITHUBUSERNAME' -F 'token=$GITHUBTOKEN' https://github.com/api/v2/json/repos/create -F 'name=$NEWREPONAME' -F 'description=$NEWREPONAME ZenPack'
    * not sure how shell scripting brings in variables
# 5) Set remote definition of new local repo
  * git remote add origin git@github.com:$GITHUBUSERNAME/$NEWREPONAME.git
    * not sure how shell scripting brings in variables
# 6) Push new local repo to new github repo
  * git push origin master
# 7) Create submodule reference
  * cd $SUPERPROJECTPATH
  * git submodule add git://github.com/$GITHUBUSERNAME/$NEWREPONAME.git $NEWREPONAMESubModule
    * not sure how shell scripting brings in variables - see last part of above command
  * git commit -m 'first commit with submodule $NEWREPONAME'
    * not sure how shell scripting brings in variables
# 8) ... Repeat (For or While loop)
