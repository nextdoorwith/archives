// 投稿編集画面(コードエディタ)にショートコードのボタンを追加

// PHPからの変数受け渡し
var pluginName = simsh_vars.name;
var tagName = simsh_vars.shortcode_name;

// ボタン群(QTags)に新しいボタンを追加
if (typeof QTags !== 'undefined') {
    QTags.addButton(
        'simsh_qt_button',      // ID
        'scode',                // ボタンの表示名
        '[' + tagName + ' type="" title="" nums=true mark=""]\n', // 開始タグ
        '\n[/' + tagName + ']', // 終了タグ
        'q',                    // アクセスキー
        'コードを挿入(prism)',   // 説明
        150                     // 優先順位: 標準ボタン(～140)の後ろに配置
    );
}