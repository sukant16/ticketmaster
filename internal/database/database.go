package database

import (
	"fmt"
	"sync"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"github.com/pkg/errors"
	"github.com/sukant16/movie-bookings/internal/env"
)

var (
	connection *sqlx.DB
	once       sync.Once
)

func connectionString() string {
	db := env.GetEnvWithDefault("DB_NAME", "bookings")
	host := env.GetEnvWithDefault("DB_HOST", "localhost")
	port := env.GetEnvWithDefault("DB_PORT", "5432")
	username := env.GetEnvWithDefault("DB_USERNAME", "postgres")
	password := env.GetEnvWithDefault("DB_PASSWORD", "postgres")

	return fmt.Sprintf("user=%s password=%s dbname=%s host=%s port=%s sslmode=disable",
		username,
		password,
		db,
		host,
		port,
	)
}

func Connection() (*sqlx.DB, error) {
	var err error
	once.Do(func() {

		c, err := sqlx.Open("postgres", connectionString())

		if err != nil {
			connection = &sqlx.DB{}
			err = errors.Wrap(err, "failed to connect to database")
		}
		connection = c
	})

	return connection, err
}
