package main

import (
	"fmt"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/push"
)

func main() {
	// 创建一个新的Gauge指标
	myMetric := prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "cpu_usage",
		Help: "cpu stat",
	})

	// 注册指标
	prometheus.MustRegister(myMetric)

	// 设置指标值
	myMetric.Set(20.5)

	// 创建Pusher并设置推送网关地址
	pusher := push.New("http://134.175.197.22:9091", "android_phone").
		Collector(myMetric).
		Grouping("lable", "127.0.0.3")

	// 推送指标数据到Pushgateway
	if err := pusher.Push(); err != nil {
		fmt.Println("Error pushing metrics:", err)
		return
	}

	fmt.Println("Metrics pushed successfully")
}
