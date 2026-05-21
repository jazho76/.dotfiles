override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom"  # keep as "Custom" for reload optimization

  # --- Layout -----------------------------------------------------------
  GIT_PROMPT_PREFIX="${DimWhite}(${ResetColor}"     # start of the git info
  GIT_PROMPT_SUFFIX="${DimWhite})${ResetColor}"     # end of the git info
  GIT_PROMPT_SEPARATOR="${DimWhite}|${ResetColor}"  # between status items

  # Line 1: <last-command indicator> <path> (<git info>)
  # Line 2: dim time + a standard prompt char ($ for user, # for root)
  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${BoldGreen}${PathShort}${ResetColor}"
  GIT_PROMPT_START_ROOT="_LAST_COMMAND_INDICATOR_ ${BoldRed}${PathShort}${ResetColor}"
  GIT_PROMPT_END_USER=" ${NewLine}${White}${Time12a}${ResetColor} $ "
  GIT_PROMPT_END_ROOT=" ${NewLine}${White}${Time12a}${ResetColor} # "

  # Last-command indicator shown at the very start of the prompt.
  # _LAST_COMMAND_STATE_ expands to the exit code of the previous command.
  GIT_PROMPT_COMMAND_OK=""
  GIT_PROMPT_COMMAND_FAIL="${Red} _LAST_COMMAND_STATE_"

  # --- Branch -----------------------------------------------------------
  GIT_PROMPT_BRANCH="${Magenta} "              #  branch glyph + name
  GIT_PROMPT_MASTER_BRANCH="${BoldMagenta} "   # color for master/main
  GIT_PROMPT_DETACHED_HEAD="${Yellow} "        # detached HEAD state
  shopt -s extglob
  GIT_PROMPT_MASTER_BRANCHES="@(master|main)"        # branches using master color

  # --- Local status symbols / colors -----------------------------------
  GIT_PROMPT_STAGED="${Green}● "       # number of staged files
  GIT_PROMPT_CONFLICTS="${BoldRed}✖ "  # number of files in conflict
  GIT_PROMPT_CHANGED="${Yellow}✚ "     # number of changed (unstaged) files
  GIT_PROMPT_UNTRACKED="${Cyan}… "     # number of untracked files
  GIT_PROMPT_STASHED="${BoldBlue}⚑ "   # number of stash entries
  GIT_PROMPT_CLEAN="${BoldGreen}✔"     # shown when the repo is clean

  # --- Remote tracking (do NOT colorize these symbols) ------------------
  GIT_PROMPT_REMOTE=" "
  GIT_PROMPT_SYMBOLS_AHEAD="↑"               # ahead of upstream by n
  GIT_PROMPT_SYMBOLS_BEHIND="↓"              # behind upstream by n
  GIT_PROMPT_SYMBOLS_PREHASH=":"             # before a commit hash (no branch)
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="L"  # local branch, not tracked
}

# Load the theme.
reload_git_prompt_colors "Custom"
