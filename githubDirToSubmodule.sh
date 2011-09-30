#!/bin/sh
########################
# GithubDirToSubmodule
# This shell script will automate the moving of all subdirectories in an
# existing git repository. It moves directories, one by one, into seperate
# repos, and then makes a submodule reference to that new seperate repo.
# The submodule is put into the original parent repo.
#
# Assumes:
# - That git repo already exists locally (defined by ParentRepoPath)
# and is up to date with any reomote repo upstream (github). Make sure to
# have any github repo cloned locally, and that your local clone is up to
# date with the latest github repo.
# - Subdirectories have no spaces in the name ex: "abc 123" wont be picked
# up correctly.
# - A file contains the directories that you want to effect. This script
# reads from that file. You can set the file in this script by changing
# the variable DirectoryListingFile.
#
# Troubleshoot:
# - If you get part way through a number of directories and something
# errors and stops it all, you have recourse...
#  - See where you are in the process, both which directory it stopped
# on and what step (1-7). Complete the rest of the steps manually for
# that dir. Next, go and edit the text input file and remove all dir's
# that have already been properly processed. Run this script again and
# you should be in business because it will only run on the remaining
# directories.
########################

set -e # Error out if any command gives error

# Variables
ParentRepoPath="/usr/local/git/testSplit/"
DirectoryListingFile="/usr/local/git/githubDirToSubModule/output.txt"
NewContainingDir="/ZenossCommunity/"
GitHubUserName="nyeates"
GitHubToken=""
SuperprojectPath="/usr/local/git/testSplit/" # Where you want the Submodules to end up; This could reference a different repo than the ParentRepo, if you want the submodule link to show in a different repo from the original parent repo

# 0) Verify that Parent Repo Exists
echo -e "\n# 0) Verify that Parent Repo Exists"
if [ ! -d $ParentRepoPath ]; then
    echo "The parent repo $ParentRepoPath does not exist where you told us to look;"
    echo "Assure that your originating repo is in place and edit this scripts"
    echo "ParentRepoPath variable to fit your setup."
    exit 1
fi

# Debug to assure File to read-directories-from is known
echo "File to read from is: $DirectoryListingFile"

# While I can read from the file, use this line
# To see file being read from, see matching 'done' at bottom of this while
while read -r dirPath dirName
do
    # Ignore lines with # at begining (comments)
    [[ $dirPath = \#* ]] && continue
    
    echo -e "\n# 0) Start Loop"
    echo "Next directory from $DirectoryListingFile is: '$dirPath'"
    echo "and its name is: $dirName"
    
    # 1) Make new dir to house new repo - appropriately named after existing zenpack
    echo -e "\n# 1) Make new dir to house new repo - appropriately named after existing zenpack"
    
    # Get to directory of canonical / parent / originating repo that has the
    # directories that we want to export
    cd $ParentRepoPath
    echo "Parent Repo is set as: $ParentRepoPath"
    echo "Current working dir is: `pwd`"
    
    # Note that directories that are going to be acted-upon are already known
    # We do not need to read them at this point. The directories were recorded
    # in the $DirectoryListingFile. You can use the script directoryListing.sh
    # to create this file.
    
    NewRepoPath="${ParentRepoPath%/*/*}$NewContainingDir$dirName"
    NewRepoName="$dirName"
    mkdir $NewRepoPath
    cd $NewRepoPath
    echo "Created new directory: $NewRepoPath"
    echo "Current working dir is: `pwd`"

    # 2) clone entire ZP repo to new local dir
    echo -e "\n# 2) clone entire ZP repo to new local dir"
    git clone --no-hardlinks $ParentRepoPath $NewRepoPath

    # 3) Cut the cloned repo down to just one directory / zenpack
    echo -e "\n# 3) Cut the cloned repo down to just one directory / zenpack"
    git filter-branch --subdirectory-filter $NewRepoName --prune-empty --tag-name-filter cat -- --all
    git remote rm origin
    rm -rf .git/refs/original/
    git reflog expire --expire=now --all
    git gc --aggressive --prune=now

    # 4) Create new github repo
    echo -e "\n# 4) Create new github repo"
    curl -F "login=$GitHubUserName" -F "token=$GitHubToken" https://github.com/api/v2/json/repos/create -F "name=$NewRepoName" -F "description=$NewRepoName ZenPack"
    
    # 5) Set remote definition of new local repo
    echo -e "\n\n# 5) Set remote definition of new local repo"
    git remote add origin git@github.com:$GitHubUserName/$NewRepoName.git

    # 6) Push new local repo to new github repo
    echo -e "\n# 6) Push new local repo to new github repo"
    git push origin master

    # 7) Create submodule reference
    echo -e "\n# 7) Create submodule reference"
    cd $SuperprojectPath
    git submodule add git://github.com/$GitHubUserName/$NewRepoName.git ${NewRepoName}SubModule # You can remove "SubModule" from the name given to the new submodule IF SuperProjectPath != ParentProjectPath; otherwise, you will get name conflicts
    git commit -m "first commit with submodule $NewRepoName"

    # 8) ... Repeat (While loop)
    break # Use this line to try out just one directory - the break will exit the while loop first time around - comment it out when you are ready to try it on many directories
    
# this is the file that is read from for the listing of which dir's to effect
done < "$DirectoryListingFile" 
