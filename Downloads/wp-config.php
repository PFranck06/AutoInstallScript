define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'wordpress_user' );
define( 'DB_PASSWORD', 'WORDPRESSPASSWORD' );
define( 'DB_HOST', 'localhost' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define('FS_METHOD', 'direct');

$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
