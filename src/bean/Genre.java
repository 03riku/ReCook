package bean;

import java.io.Serializable;

public class Genre implements Serializable {

    private int genreId;      // ジャンルID
    private String genreName; // ジャンル名（和食、洋食など）

    public Genre() {}

    // ゲッターとセッター
    public int getGenreId() {
        return genreId;
    }
    public void setGenreId(int genreId) {
        this.genreId = genreId;
    }

    public String getGenreName() {
        return genreName;
    }
    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }
}