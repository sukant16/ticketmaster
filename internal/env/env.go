package env

import (
	"os"
)

func GetEnvWithDefault(v string, f string) string {
	if val := os.Getenv(v); val != "" {
		return val
	}
	return f
}
