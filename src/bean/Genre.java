package bean;

import java.io.Serializable;

/**
 * 【料理ジャンル情報クラス】
 * 料理を「和食」「洋食」「節約メシ」などのカテゴリで分けるための入れ物です。
 * Serializable をつけているので、データの保存や受け渡しがスムーズにできます。
 */
public class Genre implements Serializable {

    // --- データを保存する変数（フィールド） ---

    private int genreId;      // ジャンルの番号（ID）。データベースの番号と一致します。
    private String genreName; // ジャンルの名前（例：「和食」「洋食」「漢メシ」など）。

    /**
     * コンストラクタ（初期化処理）
     * Javaのルールとして、空っぽの状態で準備しておくためのものです。
     */
    public Genre() {}

    // --- データの出し入れ口（ゲッターとセッター） ---

    // genreId（番号）を取得する
    public int getGenreId() {
        return genreId;
    }
    // genreId（番号）を新しく設定する
    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    // genreName（ジャンル名）を取得する
    public String getGenreName() {
        return genreName;
    }
    // genreName（ジャンル名）を新しく設定する
    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }
}