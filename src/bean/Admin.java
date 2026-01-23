package bean;

import java.io.Serializable;

/**
 * 管理者情報を保持するクラス（JavaBean）
 * Serializableを実装することで、ネットワーク転送やセッション保存ができるようになります。
 */
public class Admin implements Serializable {

    // --- フィールド（データを入れる変数） ---
    // 外部から勝手に書き換えられないように private（非公開）にしています

    private int adminId;      // 管理者のID番号
    private String adminPass; // 管理者のログインパスワード

    // --- コンストラクタ（クラスを新しく作る時の初期化処理） ---

    // 引数なしのコンストラクタ（デフォルトコンストラクタ）
    // JSPやフレームワークなどで自動的に使われることが多いため必須です
    public Admin() {}

    // 引数ありのコンストラクタ
    // IDとパスワードを一度にセットして作成したい時に便利です
    public Admin(int adminId, String adminPass) {
        this.adminId = adminId;
        this.adminPass = adminPass;
    }

    // --- ゲッターとセッター（外部からデータを取得・設定するための窓口） ---

    // adminId を取得する
    public int getAdminId() {
        return adminId;
    }

    // adminId を新しく設定する
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    // adminPass（パスワード）を取得する
    public String getAdminPass() {
        return adminPass;
    }

    // adminPass（パスワード）を新しく設定する
    public void setAdminPass(String adminPass) {
        this.adminPass = adminPass;
    }
}