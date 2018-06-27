package beans;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
public class Tb_employee_info implements Serializable {
	private String employee_id;//社員番号
	private String employee_name;//社員名
	private String department;//所属 
	private String post;//役職
	private Date entry_date;//入社日
	private String password;//パスワード
	private int admin_level;//権限レベル
	private String regist_user;//登録ユーザ
	private String update_user;//更新ユーザ
	private Timestamp update_date;//更新日時
	private int delete_flg;//削除フラグ
	
	public void setEmployee_id(String employee_id) {this.employee_id = employee_id;}
	public String getEmployee_id() {return this.employee_id;}
	
	public void setEmployee_name(String employee_name) {this.employee_name = employee_name;}
	public String getEmployee_name() {return this.employee_name;}
	
	public void setDepartment(String department) {this.department = department;}
	public String getDepartment() {return this.department;}
	
	public void setPost(String post) {this.post = post;}
	public String getPost() {return this.post;}
	
	public void setEntry_date(Date entry_date) {this.entry_date = entry_date;}
	public Date getEntry_date() {return this.entry_date;}
	
	public void setPassword(String password) {this.password = password;}
	public String getPassword() {return this.password;}
	
	public void setAdmin_level(int admin_level) {this.admin_level = admin_level;}
	public int getAdmin_level() {return this.admin_level;}
	
	public void setRegist_user(String regist_user) {this.regist_user = regist_user;}
	public String getRegist_user() {return this.regist_user;}
	
	public void setUpdate_user(String update_user) {this.update_user = update_user;}
	public String getUpdate_user() {return this.update_user;}
	
	public void setUpdate_date(Timestamp update_date) {this.update_date = update_date;}
	public Timestamp getUpdate_date() {return this.update_date;}
	
	public void setDelete_flg(int delete_flg) {this.delete_flg = delete_flg;}
	public int getDelete_flg() {return this.delete_flg;}
}
