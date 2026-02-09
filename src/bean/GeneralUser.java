package bean;

import java.io.Serializable;

/**
 * 【一般ユーザー情報クラス】
 * データベースの「GENERAL_USER」テーブルのデータを、
 * Javaプログラムの中で「1人分のデータ」として扱うための「入れ物」です。
 */
public class GeneralUser implements Serializable {

    // --- データを保存する変数（フィールド） ---
    // 外部から勝手に中身を書き換えられないように、すべて private（非公開）にしています。

    private int userId;           // ユーザーの識別番号（背番号のようなもの）
    private String email;         // メールアドレス（ログインIDとして使います）
    private String userPassword;  // ログインパスワード
    private String accountName;   // 画面に表示されるユーザー名（ニックネームなど）

    /**
     * コンストラクタ（初期化処理）
     * Javaのルール（JavaBeanの規約）として、中身が空の準備が必要なため記述しています。
     */
    public GeneralUser() {}

    // --- データの出し入れ口（ゲッターとセッター） ---
    // privateな変数にアクセスするための専用の「窓口」です。

    // userId（ユーザーID）の取得と設定
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    // email（メールアドレス）の取得と設定
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    // userPassword（パスワード）の取得と設定
    public String getUserPassword() { return userPassword; }
    public void setUserPassword(String userPassword) { this.userPassword = userPassword; }

    // accountName（ユーザー名）の取得と設定
    public String getAccountName() { return accountName; }
    public void setAccountName(String accountName) { this.accountName = accountName; }
}