package db

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	_ "github.com/lib/pq"
)

var DB *sql.DB

func InitDatabase() {
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	name := os.Getenv("DB_NAME")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, name)

	var err error
	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Error conectando a la base de datos: ", err)
	}

	err = DB.Ping()

	if err != nil {
		log.Fatal("Error haciendo ping a la base de datos: ", err)
	}

	fmt.Println("Conectado a PostgreSQL exitosamente")
}
