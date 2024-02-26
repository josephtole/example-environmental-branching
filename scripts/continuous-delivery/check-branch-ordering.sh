#!/bin/bash

# GITHUB_HEAD_REF: source branch in PR
# GITHUB_BASE_REF: target branch in PR

if ! [[ "$GITHUB_HEAD_REF" && "$GITHUB_BASE_REF" ]]
then
    echo "[ERROR] The following environment variables are required: GITHUB_HEAD_REF, GITHUB_BASE_REF"
    exit 1
fi

branch_order_str="$(paste -s -d '|' branch-ordering.txt | sed -e 's/|/ -> /g')"

echo "Verifying branch ordering: $branch_order_str"

while read check_base_ref
do
  if ! [[ "$check_head_ref" ]]
  then
    check_head_ref="$check_base_ref"
    continue
  fi

  if [[ "$GITHUB_BASE_REF" == "$check_base_ref" && "$GITHUB_HEAD_REF" == "$check_head_ref" ]]
  then
    echo "[VALID] $GITHUB_HEAD_REF-> $GITHUB_BASE_REF is acceptable branch ordering."
    exit 0
  else
    check_head_ref="$check_base_ref"
    continue
  fi
done < 'branch-ordering.txt'

echo "[ERROR] $GITHUB_HEAD_REF -> $GITHUB_BASE_REF is not a valid branch ordering. Valid branch orderings are: $branch_order_str"
exit 1
