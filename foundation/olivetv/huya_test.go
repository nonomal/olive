package olivetv_test

import (
	"testing"

	tv "github.com/go-olive/olive/foundation/olivetv"
)

func TestHuya_Snap(t *testing.T) {
	u := "https://www.huya.com/uzi"
	huya, err := tv.NewWithURL(u)
	if err != nil {
		println(err.Error())
		return
	}
	huya.Snap()
	t.Log(huya)
}
