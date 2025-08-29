# Defining the basic GitHub labels replacements in the new set
basic_github_labels=("bug" "documentation" "duplicate" "enhancement" "good first issue" "help wanted" "invalid" "question" "wontfix")
new_basic_labels_names=("[scope] bug" "[scope] documentation" "[maintainer] duplicate" "[scope] enhancement" "[maintainer] good first issue" "[maintainer] help wanted" "[maintainer] invalid" "[maintainer] question" "[maintainer] wontfix")
number_of_basic_labels=$((${#basic_github_labels[@]}-1))

# Defining new scope labels
scope_labels_names=("bug" "documentation" "enhancement" "maintenance" "significant" "⚠️ label needed")
scope_labels_descriptions=("Bug report or fix (major.minor.PATCH)" "Documentation only changes (major.minor.patch.POST)" "Adds/improves features (major.MINOR.patch)" "Code/tooling cleanup, no feature or bugfix (major.minor.PATCH)" "Breaking or major changes (MAJOR.minor.patch)" "Automatically added to issues and PRs without a [scope] label")
number_of_scope_labels=$((${#scope_labels_names[@]}-1))

# Defining new maintainer labels
maintainer_labels_names=("duplicate" "good first issue" "help wanted" "invalid" "question" "wontfix")
maintainer_labels_descriptions=("Already reported or submitted" "Good entry-level issue for newcomers" "Needs additional help to resolve or implement" "Invalid, incorrect or outdated" "Needs clarification, discussion, or more information" "Will not be fixed or continued")
number_of_maintainer_labels=$((${#maintainer_labels_names[@]}-1))

# Defining new priority labels
priority_labels_names=("lowest" "low" "medium" "high" "highest" "⚠️ label needed")
priority_labels_descriptions=("Very low urgency" "Low importance" "Normal/default priority" "Should be prioritized soon" "Urgent. Needs attention ASAP" "Automatically added to issues without a [priority] label")
number_of_priority_labels=$((${#priority_labels_names[@]}-1))

# Get the list of repositories from the organization as a single JSON
repos_string="$(gh repo list easyscience --json name)"
# Split the JSON into an array for each repository
IFS=',' read -r -a repos_list <<< ${repos_string}
# Loop through the repositories
for repo_string in ${repos_list[@]}; do
  # Extract the repository name from the JSON part
  temp_string=$(echo ${repo_string} | cut -d ":" -f 2)
  # Remove the quotes from the string, leaving only the name
  temp_string2=${temp_string%\"*}
  repo_name=${temp_string2#\"}
  echo 'Currently Editing and creating new labels for easyscience/'${repo_name}
  # Edit the basic labels to the new set
  for i in $(seq 0 $number_of_basic_labels); do
    label=${basic_github_labels[$i]}
    {
      gh label edit "$label" --name "${new_basic_labels_names[$i]}" --repo 'easyscience/'${repo_name}
    } || {
      echo "$label not in the repository"
    }
  done
  # Create/overwrite the scope labels
  for i in $(seq 0 $number_of_scope_labels); do
    gh label create "[scope] ${scope_labels_names[$i]}" --color d73a4a --description "${scope_labels_descriptions[$i]}" --force --repo 'easyscience/'${repo_name}
  done
  # Create/overwrite the maintainer labels
  for i in $(seq 0 $number_of_maintainer_labels); do
    gh label create "[maintainer] ${maintainer_labels_names[$i]}" --color 0e8a16 --description "${maintainer_labels_descriptions[$i]}" --force --repo 'easyscience/'${repo_name}
  done
  # Create/overwrite the priority labels
  for i in $(seq 0 $number_of_priority_labels); do
    gh label create "[priority] ${priority_labels_names[$i]}" --color fbca04 --description "${priority_labels_descriptions[$i]}" --force --repo 'easyscience/'${repo_name}
  done
done