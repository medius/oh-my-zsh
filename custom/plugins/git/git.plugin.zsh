alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gp='git push'
alias gpl='git pull'
alias gdc='git diff --cached'
alias gpq='git pull-request'
alias gco='git checkout'
alias gcm='git commit -am'
alias ga='git add'
alias ga='git log'
alias gcnb='git checkout -b'
alias gst='git stash'
alias gstp='git stash pop'
alias gld="gl | grep Updating | cut -d ' ' -f2 | xargs git diff"
alias grm="git status | awk '/deleted/{print \$3}' | xargs git rm"
alias gm='git merge --no-ff'
alias gmff='git merge'
alias gf='git fetch -p'
alias clean='find ./**/*.orig | xargs rm'
alias migrate='rake db:migrate db:test:prepare parallel:prepare'
alias migrater='rake db:migrate:reset db:test:prepare parallel:prepare'
alias mongod='mongod --fork --logpath /var/log/mongod/mongod.log --logappend'
alias unic='unicorn -p3000 -c ~/.local_unicorn_config.rb'
alias redis-server='redis-server ~/.redis/redis.conf'
alias vim\?='ps -ef | grep vim | grep -v grep | wc -l'

function gbd() {
  if [[ -n $1 ]]; then
    if [[ -n $2 ]]; then
      git push $1 :$2
      git branch -d $2
    else
      git push origin :$1
      git branch -d $1
    fi
  fi
}
compdef _git gbd=git-branch

function gbisect() {
  good=$1
  bad=${$2:-"HEAD"}
  git bisect start ;
  git bisect bad $bad ;
  git bisect good $good ;
  git bisect run ~/git-bisect.sh ;
}

function git_diff_count() {
  foreach b (`git branch | grep -v '*' | grep -v 'master'`); echo $b `git cherry -v master $b | wc -l`; end
}

function git_diff_clean() {
  foreach b (`git_diff_count | awk '/([a-zA-Z0-9]+) 0/{print $1}'`); gbd medius $b; end
}

function git_clean_remote() {
  remote=$1
  [[ -z "$remote" ]] && echo "Must provide a remote" && return 1

  for branch in $(git branch -r | grep $remote | grep -v master)
  do
    diff=$(git cherry -v master $branch | wc -l)
    short_branch=$(echo $branch | cut -d'/' -f2)
    if [ "$diff" -eq 0 ]; then
      git push $remote :$short_branch > /dev/null 2>&1
      git branch -d $short_branch > /dev/null 2>&1
      echo "Deleted branch $branch"
    else
      echo "Can't delete $branch"
    fi
  done
}
