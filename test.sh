ParentRepoPath="/usr/local/git/testSplit/"
cd $ParentRepoPath
ListOfDirectories=`ls -d */`
echo "Parent Repo is: $ParentRepoPath and pwd is: `pwd`"

for DirectoryName in $ListOfDirectories; do
    echo "DirectoryPath is: $DirectoryName"
    echo "DirectoryName is: $DirectoryName"
    echo " "
done