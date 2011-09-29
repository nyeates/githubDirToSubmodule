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

set -e # Error out if any command gives error

# Variables
ParentRepoPath=/usr/local/git/testSplit/
NewRepoName=CombineDS
NewRepoPath=/usr/local/git/CombineDS/
GitHubUserName=nyeates
GitHubToken=7b1f1410c48ac9aaa21d7864f80bcc90
SuperprojectPath=/usr/local/git/testSplit/ # This could reference a different repo than the ParentRepo, if you want the submodule link to show in a different repo from the original parent repo

# 0) Verify that Parent Repo Exists
if ! ls $ParentRepoPath; then
    echo "The existing parent repo does not exist where you told us to look; edit rgis scripts ParentRepoPath variable to fit your setup"
    exit 1
fi

cd $ParentRepoPath
for file in *; do
    wc -l $file # FIXME delete this, it is for testing to get into the for
    # 1) Make new dir to house new repo - appropriately named after existing zenpack

    #    * get to directory of parent repo that has dir's that you want to split
    #  * ls -la
    #    * see directories that you want to split out
    #  * Record Xth directory: $NewRepoName
    #  * mkdir   $NewRepoPath
    #  * cd $NewRepoPath

    # 2) clone entire ZP repo to new local dir
    #  * git clone --no-hardlinks $ParentRepoPath $NewRepoPath

    # 3) Cut the cloned repo down to just one directory / zenpack
    #  * git filter-branch --subdirectory-filter $NewRepoName --prune-empty --tag-name-filter cat -- --all
    #  * git remote rm origin
    #  * rm -rf .git/refs/original/
    #  * git reflog expire --expire=now --all
    #  * git gc --aggressive --prune=now

    # 4) Create new github repo
    #  * curl -F 'login=$GitHubUserName' -F 'token=$GitHubToken' https://github.com/api/v2/json/repos/create -F 'name=$NewRepoName' -F 'description=$NewRepoName ZenPack'
    #    * not sure how shell scripting brings in variables

    # 5) Set remote definition of new local repo
    #  * git remote add origin git@github.com:$GitHubUserName/$NewRepoName.git
    #    * not sure how shell scripting brings in variables

    # 6) Push new local repo to new github repo
    #  * git push origin master

    # 7) Create submodule reference
    #  * cd $SuperprojectPath
    #  * git submodule add git://github.com/$GitHubUserName/$NewRepoName.git $NewRepoNameSubModule
    #    * not sure how shell scripting brings in variables - see last part of above command
    #  * git commit -m 'first commit with submodule $NewRepoName'
    #    * not sure how shell scripting brings in variables

    # 8) ... Repeat (For or While loop)
done

# useful shell lines - remove afterwards FIXME
#echo "My name is $myname"
#echo "Hello $USER"
#echo "Today is \c ";date
#echo "Number of user login : \c" ; who | wc -l
#
#expr $x / $y
#z=`expr $x / $y`
#echo $z
#$echo "Today date is `date`"
#ls /bin/[a-c]*
# Will show all files name beginning with letter a,b or c like
#ls /bin/[!a-o]
# do not show us file name that beginning with a,b,c,e...o,

# exit status
#exit code 0            = Success
#exit code 1, non zero = Failure