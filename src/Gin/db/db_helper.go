package db

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	_ "github.com/go-xorm/xorm"
	"log"
)

var table_main_name string = "faq_main_item"
var table_detail_name string = "faq_detail_item"

type FaqMainItem struct {
	Id int	`xorm:id`
	MainItem string	`xorm:main_item`
}

type FaqInfo struct {
	Id int	`json:"id"`
	MainItem string	`json:"main_teim"`
	Detail sql.NullString	`json:"detail"`
}

func TestRead()([]FaqInfo) {
	db, err := sql.Open("mysql", "root:nzai123!@#@/faq?charset=utf8")
	defer db.Close()
	checkErr(err)
	/*
	//插入数据
	stmt, err := db.Prepare("INSERT userinfo SET username=?,departname=?,created=?")
	checkErr(err)
	res, err := stmt.Exec("astaxie", "WeChat", "2012-12-09")
	checkErr(err)
	id, err := res.LastInsertId()
	checkErr(err)
	fmt.Println(id)
	//更新数据
	stmt, err = db.Prepare("update userinfo set username=? where uid=?")
	checkErr(err)
	res, err = stmt.Exec("astaxieupdate", id)
	checkErr(err)
	affect, err := res.RowsAffected()
	checkErr(err)
	fmt.Println(affect)
	*/
	var infos []FaqInfo
	//查询数据
	rows, err := db.Query(`SELECT t_main.id, t_main.main_item,t_detail.detail
	 FROM faq_main_item t_main left join faq_detail_item t_detail on t_main.id=t_detail.main_id`)
	checkErr(err)

	var info FaqInfo 
	for rows.Next() {
		err = rows.Scan(&info.Id, &info.MainItem, &info.Detail)
		checkErr(err)
		detail := ""
		if info.Detail.Valid {
			detail = info.Detail.String
		}
		log.Println(fmt.Sprintf("id:%d,main_item:%s,detail:%s",info.Id, info.MainItem, detail))
		infos = append(infos, info)
	}
	/*
	//删除数据
	stmt, err = db.Prepare("delete from userinfo where uid=?")
	checkErr(err)
	res, err = stmt.Exec(id)
	checkErr(err)
	affect, err = res.RowsAffected()
	checkErr(err)
	fmt.Println(affect)
	*/
	return infos
}

// 存在 error 进行 painc
func checkErr(err error) {
	if err != nil {
		fmt.Println(err.Error())
		panic(err)
	}
}