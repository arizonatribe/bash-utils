#!/bin/bash

usage() {
  echo "Embeds stylesheet, svg, and javascript assets inline into HTML files."
  echo -e "Usage:\n$0"
}

if [[ ($# == "--help") ||  $# == "-h" ]]; then
  usage
  exit 0
fi

STATIC_ROOT="${BASH_SOURCE%/*}/../build/static"

# Retrieves just the asset file names from the template'd HTML file(s)
get_html_asset_urls() {
  grep -E "(<script>([A-Za-z0-9_\-\&\%\./]+)</script>|<style>([A-Za-z0-9_\-\&\%\./]+)</style>)" $1 |\
  awk -F'(<script>|</script>|<style>|</style>)' '{print $2}'
}

# For each HTML file, find any <style rel=stylesheet> or <script> blocks
# and embed the contents of the corresponding javascript or stylesheet files
# in between opening and closing <script> or <style> tags
embed_scripts_and_styles_into_html_file() {
  local html_files=$1
  for html_file_template in $html_files; do
    for asset_name in $(get_html_asset_urls "$html_file_template"); do
      local tag_pattern='(<)(script|style)(>)('"$asset_name"')(<\/)(script|style)(>)'
      sed -ri '/'$tag_pattern'/ {
        # Place this matching line into the hold buffer to use later when creating the closing tag
        H
        # Now, replace this line with beginning <script> or <style> tag
        s/'$tag_pattern'/\1\2\3/
        # Next, read in the external asset (stylesheet, javascript, etc.), embedding it below the opening tag
        r '$STATIC_ROOT/$asset_name'
        # Begin reading the next line, but do not print it
        n
        # Also place it into the hold buffer, after the copy we made of the opening <script> or <style> tag
        H
        # Exchange the hold buffer contents back into the pattern buffer
        x
        # Perform a string replace, transforming our opening <script> or <style> tags into closing tags
        s/'$tag_pattern'/\5\6\7/
      }' $html_file_template
      # Get rid of the temporary asset
      rm $STATIC_ROOT/$asset_name
    done
  done
}

embed_scripts_and_styles_into_html_file "$STATIC_ROOT/*.html"