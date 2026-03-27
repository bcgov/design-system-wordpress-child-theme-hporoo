#!/usr/bin/env bash


# Activate the child theme so the local environment matches the theme's development environment.
THEME_SLUG="design-system-wordpress-child-theme-hporoo"
wp theme activate "$THEME_SLUG"

# Use pretty permalinks so local links match how the theme is built.
wp option update permalink_structure "/%postname%/"
wp rewrite flush --hard >/dev/null


# Set up the Home and Posts pages. These pages are expected by the theme to be present and published, and are referenced by the header template and the homepage template parts. The specific page IDs are referenced in the theme templates, so they should not be changed without also updating the templates.
HOME_PAGE_ID=1292
POSTS_PAGE_ID=3597

# Keep a stable secondary page for local navigation and manual testing.
SAMPLE_PAGE_ID="$(wp post list --post_type=page --name=sample-page --post_status=publish,draft,pending,future,private --field=ID --format=ids | awk 'NR==1 {print $1}')"
if [ -z "$SAMPLE_PAGE_ID" ]; then
	SAMPLE_PAGE_ID="$(wp post create --post_type=page --post_title="Sample Page" --post_name="sample-page" --post_status=publish --porcelain)"
fi

# Set the front page to the Home page.
wp option update show_on_front page
wp option update page_on_front "$HOME_PAGE_ID"

# Set General settings
wp option update blogdescription "Government of British Columbia"
wp option update timezone_string "America/Vancouver"

# Set Reading settings
wp option update posts_per_page 10
wp option update page_for_posts "$POSTS_PAGE_ID"
wp option update show_on_front page
wp option update page_on_front "$HOME_PAGE_ID"
wp option update blog_public 0


# Seed the navigation post referenced by the header template.
# This script is intended to be run in the local environment after the container is up and running. It should be used to perform any necessary setup or configuration that requires the WordPress environment to be active, such as activating the theme, setting up pages, and seeding navigation.
PRIMARY_NAV_ID=1302
PRIMARY_NAV_ID="$PRIMARY_NAV_ID" SAMPLE_PAGE_ID="$SAMPLE_PAGE_ID" wp eval '
$nav_id = (int) getenv( "PRIMARY_NAV_ID" );
$sample_page_id = (int) getenv( "SAMPLE_PAGE_ID" );
'

# $nav_content = sprintf(
# 	"<!-- wp:navigation-link {\"label\":\"Home\",\"type\":\"custom\",\"url\":\"%s\",\"kind\":\"custom\",\"isTopLevelLink\":true} /-->\n" .
# 	"<!-- wp:navigation-link {\"label\":\"Sample Page\",\"type\":\"post_type\",\"id\":%d,\"url\":\"%s\",\"kind\":\"post-type\",\"isTopLevelLink\":true} /-->\n" .
# 	"<!-- wp:navigation-link {\"label\":\"Resources\",\"type\":\"custom\",\"url\":\"%s\",\"kind\":\"custom\",\"isTopLevelLink\":true} /-->",
# 	home_url( "/" ),
# 	$sample_page_id,
# 	home_url( "/sample-page/" ),
# 	home_url( "/resources/" )
# );

# $existing = get_post( $nav_id );
# if ( $existing && "wp_navigation" !== $existing->post_type ) {
# 	WP_CLI::error( sprintf( "Post ID %d exists but is not a wp_navigation post.", $nav_id ) );
# }

# $post_args = array(
# 	"post_title" => "Primary Navigation",
# 	"post_name" => "primary-navigation",
# 	"post_status" => "publish",
# 	"post_type" => "wp_navigation",
# 	"post_content" => $nav_content,
# );

# if ( $existing ) {
# 	$post_args["ID"] = $nav_id;
# 	$result = wp_update_post( $post_args, true );
# } else {
# 	$post_args["import_id"] = $nav_id;
# 	$result = wp_insert_post( $post_args, true );
# }

# if ( is_wp_error( $result ) ) {
# 	WP_CLI::error( $result->get_error_message() );
# }
# '

echo "Local bootstrap complete for $THEME_SLUG"