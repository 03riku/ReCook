package dao;

import java.sql.Connection;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DAO {
	static DataSource ds;

	public Connection getConnection() throws Exception {

		// 既にデータベースと接続済み出ない場合実行
		if (ds == null) {
			InitialContext ic = new InitialContext();
			// context.xml で設定したデータベースへの接続情報について
			// どの設定を呼び出すか記述しある
			ds = (DataSource) ic.lookup("java:/comp/env/jdbc/Re.Cook");
		}
		return ds.getConnection();
	}
}
