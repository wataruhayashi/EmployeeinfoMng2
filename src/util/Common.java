package util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Common {
	//管理権限
	public static final Integer AUTH_GENE = 0;
	public static final Integer AUTH_MANE = 2;
	//削除フラグ
	public static final Integer Active = 0;
	public static final Integer Delete = 1;

	public static final String NulId = "社員番号は必須です。";
	public static final String NulName = "社員名は必須です。";
	public static final String NulDep = "社員所属は必須です。";
	public static final String NulPass = "パスワードは必須です。";
	public static final String NulErr = "未入力項目があります。";
	public static final String IdPassErr = "社員番号かパスワードに誤りがあります。";
	public static final String DepErr = "入力された所属はすでに登録されています。";
	public static final String IdErr = "入力された社員番号は既に登録されています。";
	public static final String BackErr = "セッションが無効です。社員番号とパスワードを入力してください。";
	public static final String MisErr = "入社日は2015-01-01のような形式で入力してください。";
	public static final String IdMiss = "社員番号は半角数字で入力してください。";
	public static final String NameMiss = "社員名項目で記号は入力しないでください。";

	//カレンダー正規表現
	public static boolean DateMatch(String cal) {
		Pattern pattern = Pattern.compile("^[0-9]{4}-[0-9]{2}-[0-9]{2}$");
		Matcher match = pattern.matcher(cal);
		return match.find();
	}

	//社員番号正規表現
	public static boolean IdMatch(String id) {
		Pattern pattern = Pattern.compile("^[0-9]*$");
		Matcher match = pattern.matcher(id);
		return match.find();
	}

	//社員名正規表現
	public static boolean NameMatch(String name) {
		Pattern pattern = Pattern.compile("[a-zA-Zあ-ん]");
		Matcher match = pattern.matcher(name);
		return match.find();
	}

}
