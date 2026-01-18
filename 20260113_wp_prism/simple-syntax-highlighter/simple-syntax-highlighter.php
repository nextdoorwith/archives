<?php
/* 
Plugin Name: Simple Syntax Highlighter
Plugin URI:
Description: Prism.jsを使った最低限のコード表示プラグイン
Version: 0.8.0
Author: whoami
Author URI:
*/

define( 'SIMSH_NAME', 'Simple Syntax Highlighter' );
define( 'SIMSH_ID', 'simple_syntax_highlighter' );
define( 'SIMSH_VERSION', '0.8.0' );

// ショートコード名（タグ名）の定義("[scode]"などのように)
define( 'SIMSH_SHORTCODE_NAME', 'scode' );

// 既定実装だとwpauto(改行追加), do_shortcode(ショートコード展開)の順でフィルタが実行される。
// wpautoがショートコード内のコードに改行を追加してしまいデザインが崩れる。
// これを防止するために、wpautoより先にdo_shortcodeを実行するフィルタを追加する。
add_filter( 'the_content', 'simsh_preprocess_shortcode', 7 );
function simsh_preprocess_shortcode( $content ) {
    global $shortcode_tags;

    // do_shortcode()は、$shortcode_tagsに含まれるショートカットを展開する。
    // 一旦、$shortcode_tagsを本ショートカットのみにしてdo_shortcode()を実行する。
    // 後のフィルタで従来通りdo_shortcode()を実行できるよう、$shortcode_tagsは復元する。
    $orig_shortcode_tags = $shortcode_tags; // 既存を退避

    $shortcode_tags = array();
    add_shortcode( SIMSH_SHORTCODE_NAME, 'simsh_render_shortcode' );
    $content = do_shortcode( $content );

    $shortcode_tags = $orig_shortcode_tags; // 既存を復元
    return $content;
}

// ショートコードをHTMLに展開する。
function simsh_render_shortcode( $atts, $content = null ) {

    // ショートコードが含まれる場合のみjs/cssをロード
    wp_enqueue_script( 'simsh_prism_js', plugins_url( 'js/prism.js', __FILE__ ), array(), SIMSH_VERSION, true );
    wp_enqueue_style( 'simsh_prism_css', plugins_url( 'css/prism.css', __FILE__ ), array(), SIMSH_VERSION );
    wp_enqueue_style( 'simsh_style_css', plugins_url( 'css/simsh-style.css', __FILE__ ), array(), SIMSH_VERSION );

    // コピーボタンを日本語化
    // 詳細はCopy to Clipboardプラグインのリファレンスを参照
    $custom_js = 
        "document.body.setAttribute('data-prismjs-copy', 'コピー');" .
        "document.body.setAttribute('data-prismjs-copy-error', '失敗');" .
        "document.body.setAttribute('data-prismjs-copy-success', 'コピー完了');";
    wp_add_inline_script( 'simsh_prism_js', $custom_js );

    // ショートコードに指定した値を取得
    $a = shortcode_atts( array(
        'type' => 'plaintext',
        'title' => '',
        'nums' => 'true',
        'mark' => '',
    ), $atts );

    // HTMLにレンダリング
    $type_attr = ' class="language-' . esc_attr($a['type']) . '"';
    $title_attr = ( ! empty( $a['title'] ) ) ? ' data-title="' . esc_attr( $a['title'] ) . '"' : '';
    $nums_attr = ( $a['nums'] == 'true' ) ? ' class="line-numbers"' : '';
    $mark_attr = ( ! empty( $a['mark'] ) ) ? ' data-line="' . esc_attr( $a['mark'] ) . '"' : '';
    $escaped_content = htmlspecialchars( trim( $content ), ENT_QUOTES, 'UTF-8' );
    return 
        "\n" . '<div class="simsh-container"' . $title_attr . '>' . "\n" .
        '<pre' . $nums_attr . $mark_attr . '><code' . $type_attr . '>' . 
        $escaped_content . 
        '</code></pre>' . "\n" .
        '</div>' . "\n";
}

// 投稿編集画面(コードエディタ)にショートコードのボタンを追加
// （ブロックエディタで使用する場合、「ショートコード」ブロックから使用する想定。）
add_action( 'admin_enqueue_scripts', 'simsh_add_quicktags' );
function simsh_add_quicktags( $hook ) {
    if ( 'post.php' !== $hook && 'post-new.php' !== $hook ) {
        return;
    }

    // スクリプトの読み込み予約
    wp_enqueue_script( 
        'simsh_quicktags_js',     // ハンドル名
        plugins_url( 'js/simsh-quicktags.js', __FILE__ ), 
        array( 'quicktags' ),     // 依存関係(quicktagsロード後にjsロード)
        SIMSH_VERSION,            // キャッシュ対策
        true                      // フッターで読み込み
    );

    // jsでPHP変数を使えるようにする(jsに変数埋め込み)
    wp_localize_script(
        'simsh_quicktags_js',     // ハンドル名
        'simsh_vars',             // js上での名前
        array(                    // 引き渡す値リスト
            'name' => SIMSH_NAME,
            'shortcode_name' => SIMSH_SHORTCODE_NAME
        )
    );
}

?>
