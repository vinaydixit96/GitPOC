#!/bin/bash
GIT_REPOSITORY_PATH="/mnt/c/Users/vdixits/Vinay/Software/PortableGit/CVS/GitPOC"
GIT_BRANCH="main"
CURRENT_DIRECTORY=`pwd`
read -p "Please enter the tag which needs to be finalized: " BUILD_TAG;
echo $BUILD_TAG > tag.txt
#SDE-2022.1.0-RC115
if [[ `grep  'SDE-[0-9]\{4\}\.[0-9]\{1\}\.[0-9]-RC[0-9]\{1,3\}' "tag.txt"` ]] || [[ `grep  'CBS-[0-9]\{4\}\.[0-9]\{1\}\.[0-9]-RC[0-9]\{1,3\}' "tag.txt"` ]] || [[ `grep  '[0-9]\{4\}\.[0-9]\{1\}\.[0-9]-RC[0-9]\{1,3\}' "tag.txt"` ]]
then
    cd ${GIT_REPOSITORY_PATH}
    git checkout ${GIT_BRANCH}
    git pull origin ${GIT_BRANCH}
    if [[ `git status | head -1 | grep "${GIT_BRANCH}" ` ]] 
    then
        echo "successfully switched to gitline ${GIT_BRANCH}"
    else
        git add -A
        git stash
        git checkout ${GIT_BRANCH}
        git pull origin ${GIT_BRANCH}
        if [[ `git status | head -1 | grep "${GIT_BRANCH}"` ]]
        then
            echo "successfully switched to gitline ${GIT_BRANCH}"
        else 
            echo "unable to switch to branch ${GIT_BRANCH}. Please try again"
            return 1
        fi
    fi
    cd ${CURRENT_DIRECTORY}
    NEW_TAG=$(cat tag.txt | sed "s#SDE-##g" | sed "s#CBS-##g")
    RELEASE_BRANCH=$(cat tag.txt | sed "s#SDE-##g" | sed "s#CBS-##g" | awk -F '-' '{print $1}')
    cd ${GIT_REPOSITORY_PATH}
    if [[  $(git tag | grep  ${RELEASE_BRANCH} | sort -V | tail -1 | grep ${NEW_TAG} ) ]]
    then
        COMMIT_HASH=$(git rev-list -n 1 $NEW_TAG)
        git tag ${RELEASE_BRANCH} ${COMMIT_ID}
        git push origin ${RELEASE_BRANCH}
        git tag -l
    else
        echo "not hello"
    fi

else
    echo "Please enter valid tag" ;
fi